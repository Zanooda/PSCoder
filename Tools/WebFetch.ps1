# WebFetch.ps1 - Get URL content for PSCoder
# Supports Markdown for Agents (Cloudflare), HTML cleaning, caching, and content detection
# Markdown for Agents: https://blog.cloudflare.com/markdown-for-agents/
# When sites support it, returns markdown directly (80% token savings!)

$Script:FetchCacheTTL = [TimeSpan]::FromMinutes(10)
$Script:MarkdownCacheTTL = [TimeSpan]::FromMinutes(30)

function Detect-ContentType {
    param([string]$Content, [string]$ContentType = "")
    if ($ContentType -match "application/json") { return "json" }
    if ($ContentType -match "application/xml") { return "xml" }
    if ($ContentType -match "text/xml") { return "xml" }
    if ($ContentType -match "text/markdown") { return "markdown" }
    if ($ContentType -match "text/html") { return "html" }
    if ($ContentType -match "text/plain") { return "text" }
    $trimmed = $Content.TrimStart()
    if ($trimmed.StartsWith("{") -or $trimmed.StartsWith("[")) {
        try { $null = $trimmed | ConvertFrom-Json; return "json" } catch {}
    }
    if ($trimmed.StartsWith("<?xml") -or $trimmed.StartsWith("<rss") -or $trimmed.StartsWith("<feed")) { return "xml" }
    if ($trimmed.StartsWith("<!DOCTYPE") -or $trimmed.StartsWith("<html")) { return "html" }
    if ($trimmed -match "^#{1,6}\s" -and $trimmed -match "\n") { return "markdown" }
    return "text"
}

function Format-Content {
    param([string]$Content, [string]$ContentType, [int]$MaxChars, [int]$Tokens = 0)
    $output = ""
    switch ($ContentType) {
        "json" {
            try {
                $json = $Content | ConvertFrom-Json
                $formatted = $json | ConvertTo-Json -Depth 10
                if ($formatted.Length -gt $MaxChars) { $formatted = $formatted.Substring(0, $MaxChars) + "`n... (truncated)" }
                $output = $formatted
            } catch {
                if ($Content.Length -gt $MaxChars) { $output = $Content.Substring(0, $MaxChars) + "`n... (truncated)" }
                else { $output = $Content }
            }
        }
        "xml" {
            # Pretty-printing via System.Xml.XmlTextWriter is unavailable in ConstrainedLanguage mode.
            if ($Content.Length -gt $MaxChars) { $output = $Content.Substring(0, $MaxChars) + "`n... (truncated)" }
            else { $output = $Content }
        }
        "markdown" {
            if ($Tokens -gt 0) {
                $output += "[Markdown via Cloudflare - ~$Tokens tokens (80% savings vs HTML)]`n`n"
            }
            if ($Content.Length -gt $MaxChars) { $output += $Content.Substring(0, $MaxChars) + "`n... (truncated)" }
            else { $output += $Content }
        }
        "html" {
            $output = Clean-HtmlContent -Html $Content -MaxChars $MaxChars
        }
        default {
            $text = Clean-Text $Content
            if ($text.Length -gt $MaxChars) { $output = $text.Substring(0, $MaxChars) + "`n... (truncated)" }
            else { $output = $text }
        }
    }
    return $output
}

function Invoke-WebFetch {
    param(
        [Parameter(Mandatory)][string]$Url,
        [int]$MaxChars = 15000
    )

    if (-not $Url.StartsWith("http://") -and -not $Url.StartsWith("https://")) {
        $Url = "https://$Url"
    }

    $cached = Get-Cache -Namespace "fetch" -Key $Url -TTL $Script:FetchCacheTTL
    if ($cached -and $cached.content) {
        $formatted = Format-Content -Content $cached.content -ContentType $cached.contentType -MaxChars $MaxChars -Tokens $cached.tokens
        $result = "Fetched (cached): $Url`n"
        $result += "-" * 60 + "`n"
        $result += "Type: $($cached.contentType) | Size: $(([double]($cached.size / 1KB)).ToString('F1'))KB"
        if ($cached.tokens -gt 0) { $result += " | Tokens: ~$($cached.tokens)" }
        $result += "`n" + "-" * 60 + "`n"
        $result += $formatted
        return $result
    }

    # Request markdown first, fallback to HTML
    # This enables Cloudflare's Markdown for Agents: https://blog.cloudflare.com/markdown-for-agents/
    $headers = @{
        "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
        "Accept" = "text/markdown, text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
        "Accept-Language" = "en-US,en;q=0.9"
        "Accept-Encoding" = "gzip, deflate, br"
        "Connection" = "keep-alive"
    }

    $fetchStart = Get-Date

    try {
        $response = Invoke-WebRequest -Uri $Url -Headers $headers -UseBasicParsing -TimeoutSec 30 -MaximumRedirection 5 -ErrorAction Stop
        $content = $response.Content
        $contentType = $response.Headers["Content-Type"]
        $statusCode = [int]$response.StatusCode
        $fetchTime = ((Get-Date) - $fetchStart).TotalSeconds

        # Check for Cloudflare markdown token count header
        $tokenCount = 0
        $tokenHeader = $response.Headers["x-markdown-tokens"]
        if ($tokenHeader) {
            try { $tokenCount = [int]$tokenHeader } catch {}
        }

        $detectedType = Detect-ContentType -Content $content -ContentType $contentType
        $contentSize = $content.Length
        $formatted = Format-Content -Content $content -ContentType $detectedType -MaxChars $MaxChars -Tokens $tokenCount
        Set-Cache -Namespace "fetch" -Key $Url -Data @{ content = $content; contentType = $detectedType; size = $contentSize; tokens = $tokenCount } -ContentType $detectedType

        $result = "Fetched: $Url`n"
        $result += "-" * 60 + "`n"
        $result += "Type: $detectedType | Size: $(([double]($contentSize / 1KB)).ToString('F1'))KB | Time: $($fetchTime.ToString('F2'))s"
        if ($tokenCount -gt 0) {
            $htmlTokens = [int]($tokenCount * 5)
            $savings = [int]((1 - ($tokenCount / $htmlTokens)) * 100)
            $result += " | Tokens: ~$tokenCount (saved ~$savings% vs HTML)"
        }
        $result += "`nStatus: $statusCode`n" + "-" * 60 + "`n"
        $result += $formatted
        return $result
    }
    catch {
        $errorMsg = $_.Exception.Message
        if ($errorMsg -match "403|Forbidden") { return "Error: Access denied (403). Site blocks automated requests." }
        elseif ($errorMsg -match "404|Not Found") { return "Error: Page not found (404). Check the URL." }
        elseif ($errorMsg -match "timeout|tiempo") { return "Error: Timeout. Site is taking too long to respond." }
        elseif ($errorMsg -match "conexion|connection|DNS") { return "Error: Could not connect. Check your internet connection and URL." }
        else { return "Error fetching URL: $errorMsg" }
    }
}

function Clean-HtmlContent {
    param([string]$Html, [int]$MaxChars)
    $text = $Html
    $text = [regex]::Replace($text, '<script[^>]*>.*?</script>', '', 'Singleline,IgnoreCase')
    $text = [regex]::Replace($text, '<style[^>]*>.*?</style>', '', 'Singleline,IgnoreCase')
    $text = [regex]::Replace($text, '<header[^>]*>.*?</header>', '', 'Singleline,IgnoreCase')
    $text = [regex]::Replace($text, '<footer[^>]*>.*?</footer>', '', 'Singleline,IgnoreCase')
    $text = [regex]::Replace($text, '<nav[^>]*>.*?</nav>', '', 'Singleline,IgnoreCase')
    $text = [regex]::Replace($text, '<aside[^>]*>.*?</aside>', '', 'Singleline,IgnoreCase')
    $text = [regex]::Replace($text, '<form[^>]*>.*?</form>', '', 'Singleline,IgnoreCase')
    $text = [regex]::Replace($text, '<button[^>]*>.*?</button>', '', 'Singleline,IgnoreCase')
    $text = [regex]::Replace($text, '<input[^>]*>', '', 'IgnoreCase')
    $text = [regex]::Replace($text, '<select[^>]*>.*?</select>', '', 'Singleline,IgnoreCase')
    $text = [regex]::Replace($text, '<textarea[^>]*>.*?</textarea>', '', 'Singleline,IgnoreCase')
    $text = [regex]::Replace($text, '<iframe[^>]*>.*?</iframe>', '', 'Singleline,IgnoreCase')
    $text = [regex]::Replace($text, '<embed[^>]*>', '', 'IgnoreCase')
    $text = [regex]::Replace($text, '<object[^>]*>.*?</object>', '', 'Singleline,IgnoreCase')
    $text = [regex]::Replace($text, '<video[^>]*>.*?</video>', '', 'Singleline,IgnoreCase')
    $text = [regex]::Replace($text, '<audio[^>]*>.*?</audio>', '', 'Singleline,IgnoreCase')
    $text = [regex]::Replace($text, '<canvas[^>]*>.*?</canvas>', '', 'Singleline,IgnoreCase')
    $text = [regex]::Replace($text, '<svg[^>]*>.*?</svg>', '', 'Singleline,IgnoreCase')
    $text = [regex]::Replace($text, '<img[^>]*>', '', 'IgnoreCase')
    $text = [regex]::Replace($text, '<!--.*?-->', '', 'Singleline')
    $text = [regex]::Replace($text, '<code[^>]*>', ' [code] ', 'IgnoreCase')
    $text = [regex]::Replace($text, '</code>', ' [/code] ', 'IgnoreCase')
    $text = [regex]::Replace($text, '<pre[^>]*>', "`n[code block]`n", 'IgnoreCase')
    $text = [regex]::Replace($text, '</pre>', "`n[/code block]`n", 'IgnoreCase')
    $blockTags = @('div', 'p', 'br', 'hr', 'li', 'tr', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'article', 'section', 'main', 'blockquote', 'dd', 'dt', 'figcaption', 'figure')
    foreach ($tag in $blockTags) {
        $text = [regex]::Replace($text, "</$tag>", "`n", 'IgnoreCase')
        $text = [regex]::Replace($text, "<$tag[^>]*>", "`n", 'IgnoreCase')
    }
    $text = [regex]::Replace($text, '<[^>]+>', ' ')
    $text = Convert-HtmlEntities $text
    $lines = $text -split "`n"
    $cleanLines = @()
    foreach ($line in $lines) {
        $line = [regex]::Replace($line, '\s+', ' ').Trim()
        if ($line.Length -lt 3) { continue }
        if ($line -match '^[\s\-\*\=\#\@\!\$\%\^\&\(\)\[\]\{\}\<\>\,\.\;\:]+$') { continue }
        $cleanLines += $line
    }
    $text = $cleanLines -join "`n"
    $text = [regex]::Replace($text, "`n{3,}", "`n`n")
    try {
        $text = [regex]::Replace($text, '\\u([0-9a-fA-F]{4})', { param($m); [char][int]::Parse($m.Groups[1].Value, 'HexNumber') })
    } catch {}
    if ($text.Length -gt $MaxChars) { $text = $text.Substring(0, $MaxChars) + "`n... (truncated)" }
    return $text.Trim()
}

function Clean-Text {
    param([string]$Text)
    $text = Convert-HtmlEntities $Text
    $text = [regex]::Replace($text, '<[^>]+>', ' ')
    $text = [regex]::Replace($text, '\s+', ' ')
    return $text.Trim()
}

# HTML entity decoder (System.Web.HttpUtility is unavailable in ConstrainedLanguage mode).
function Convert-HtmlEntities {
    param([string]$Text)
    if ([string]::IsNullOrEmpty($Text)) { return $Text }
    $entities = @{
        '&nbsp;' = ' '; '&amp;' = '&'; '&lt;' = '<'; '&gt;' = '>'; '&quot;' = '"'
        '&#39;' = "'"; '&#039;' = "'"; '&apos;' = "'"; '&mdash;' = '-'; '&ndash;' = '-'
        '&hellip;' = '...'; '&laquo;' = '<<'; '&raquo;' = '>>'; '&copy;' = '(c)'
        '&reg;' = '(R)'; '&trade;' = '(TM)'; '&lsquo;' = "'"; '&rsquo;' = "'"
        '&ldquo;' = '"'; '&rdquo;' = '"'; '&middot;' = '.'
    }
    foreach ($entity in $entities.GetEnumerator()) {
        $Text = $Text -replace [regex]::Escape($entity.Key), $entity.Value
    }
    $Text = [regex]::Replace($Text, '&#x([0-9a-fA-F]+);', { param($m) [char][int]::Parse($m.Groups[1].Value, 'HexNumber') })
    $Text = [regex]::Replace($Text, '&#(\d+);', { param($m) [char][int]$m.Groups[1].Value })
    return $Text
}
