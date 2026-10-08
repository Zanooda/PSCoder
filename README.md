# PSCoder

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PowerShell](https://img.shields.io/badge/PowerShell-%3E%3D5.1-blue)](https://github.com/PowerShell/PowerShell)
[![GitHub repo](https://img.shields.io/badge/GitHub-PSCoder-blue?logo=github)](https://github.com/josevdr95new/PSCoder)

AI-powered coding assistant that runs in your PowerShell terminal. Uses a custom OpenAI-compatible endpoint (slop.storo.cloud) or Groq to understand your codebase, edit files, search the web, and solve problems autonomously.

**Repository:** https://github.com/josevdr95new/PSCoder

## Features

### Core Capabilities
- **19 Built-in Tools** - File operations, shell execution, web search, OCR, and more
- **8 Specialized Skills** - Pre-built workflows for debugging, code generation, web research, and more
- **Persistent Memory** - Long-term memory that persists between sessions
- **Auto-Learning** - Automatically saves errors, solutions, and patterns for future reference
- **Auto-Healing** - Diagnoses errors and suggests fixes with alternative approaches
- **Session History** - Save, list, and load previous conversations

### Tools
| Tool | Description |
|------|-------------|
| `execute_powershell` | Run PowerShell commands (hidden window, doesn't interrupt chat) |
| `read_file` | Read file contents |
| `write_file` | Create or overwrite files |
| `edit_file` | Replace text in existing files |
| `search_files` | Search for patterns across files (grep) |
| `glob_files` | Find files matching patterns (supports `**`) |
| `list_directory` | List files and directories |
| `web_search` | Search the web (Brave API + DuckDuckGo fallback) |
| `web_fetch` | Fetch content from URLs (supports Markdown for Agents) |
| `ocr_image` | Extract text from images (Windows OCR) |
| `auto_heal` | Analyze errors and get fix suggestions |
| `learn_from_error` | Register solutions for future reference |
| `find_solution` | Search for previously solved problems |
| `create_plan` | Create structured step-by-step plans |
| `verify_step` | Verify individual step execution |
| `verify_task` | Verify complete task outcome |
| `save_learning` | Save learnings automatically |
| `list_skills` | List available specialized workflows |
| `read_skill` | Load skill instructions |

### Skills
| Skill | Purpose |
|-------|---------|
| **Web Research** | Search, fetch, and synthesize current information from the web |
| **File Analysis** | Analyze project structure, codebases, and configurations |
| **Debug Error** | Diagnose and resolve errors with systematic troubleshooting |
| **Code Generation** | Create new scripts, functions, and modules from scratch |
| **Refactor** | Improve code quality, readability, and performance |
| **PowerShell Admin** | Windows system administration tasks |
| **Data Extraction** | Parse and transform data from files, APIs, and web pages |
| **Documentation** | Create and improve project documentation |

### Smart Systems
- **Memory Decision** - Automatically analyzes conversations and saves valuable information
- **Reasoning Engine** - Plans, executes, and verifies multi-step tasks
- **Permission System** - Safe tools auto-approved, dangerous tools require confirmation
- **Hooks** - Pre/Post tool execution hooks for custom behavior
- **Context Builder** - Automatically includes Git status and project context
- **Agent Narration** - Visual and speech feedback for agent actions

## Installation

### Prerequisites
- PowerShell 5.1 or later (Windows 10/11)
- An API key for the custom OpenAI-compatible endpoint (https://slop.storo.cloud/v1) or [Groq](https://groq.com)

### Language mode
PSCoder runs in both **FullLanguage** and **ConstrainedLanguage** mode. On machines
with an application control policy (WDAC / AppLocker), PowerShell starts in
`ConstrainedLanguage` mode, where .NET APIs are unavailable; PSCoder uses cmdlets
and allowed types only, so the assistant, tools, and web access still work. The only
features that are disabled in that mode are Windows speech (SAPI/COM) and OCR
(WinRT), which require FullLanguage.

### Setup
```powershell
# Clone the repository
git clone https://github.com/josevdr95new/PSCoder.git
cd PSCoder

# Import the module
Import-Module .\PSCoder.psd1

# Set your API key (choose one)
# Option 1: Environment variable
$env:SLOP_API_KEY = "your-key-here"

# Option 2: Interactive config
Start-PSCoder
# Then use: /config apiKey your-key-here
```

## Configuration

### API Keys
```powershell
# Custom OpenAI-compatible endpoint (default; slop.storo.cloud)
$env:SLOP_API_KEY = "your-key"

# Groq (fast inference)
$env:GROQ_API_KEY = "your-key"

# Brave Search (optional, for better web search)
$env:BRAVE_SEARCH_API_KEY = "your-key"
```

### Models
```powershell
# Inside PSCoder, change model
/model deepseek-v4.1-flash

# Change provider
/provider custom
/provider groq
```

## Usage

### Start PSCoder
```powershell
Start-PSCoder
```

### Commands
| Command | Description |
|---------|-------------|
| `/help` | Show all commands |
| `/clear` | Clear conversation |
| `/new` | New conversation (reload memory) |
| `/model` | Change AI model |
| `/provider` | Change provider |
| `/history` | List saved sessions |
| `/load <id>` | Load a previous session |
| `/memory` | Show long-term memory |
| `/memory add X` | Add info to memory |
| `/memory edit` | Open memory file |
| `/memory clear` | Clear memory |
| `/tools` | List available tools |
| `/config` | Show/change configuration |
| `/narrate on` | Enable agent narration |
| `/narrate off` | Disable narration |
| `/speak <text>` | Speak custom text |
| `/exit` | Save and exit |

### Example Workflow
```
> How do I fix this PowerShell error: "The term 'Get-Foo' is not recognized"?

[AI loads skill: debug-error]
[AI checks for previous solutions]
[AI suggests fix and explains]

> Create a script that monitors disk space and alerts when below 10%

[AI loads skill: code-generation]
[AI creates plan with steps]
[AI writes the script using write_file]
[AI tests the script using execute_powershell]
[AI verifies the result]
```

## Architecture

```
PSCoder/
├── API/                    # API clients (custom, Groq)
│   ├── BaseClient.ps1      # Shared HTTP client with retry logic
│   ├── Custom.ps1          # Custom OpenAI-compatible endpoint integration
│   └── Groq.ps1            # Groq API integration
├── Commands/
│   └── SlashCommands.ps1   # Slash command handler
├── Config/
│   └── Config.ps1          # Configuration management
├── Core/
│   ├── AgentNarration.ps1  # Visual + speech feedback
│   ├── AutoHealing.ps1     # Error diagnosis and recovery
│   ├── AutoImprove.ps1     # Learning system (errors, patterns)
│   ├── ContextBuilder.ps1  # Git + project context
│   ├── Hooks.ps1           # Pre/Post tool execution hooks
│   ├── Init.ps1            # Subsystem initialization
│   ├── Logger.ps1          # Logging system
│   ├── Main-Loop.ps1       # Main REPL loop
│   ├── MemoryDecision.ps1  # Auto memory decisions
│   ├── Permissions.ps1     # Permission system
│   ├── ReasoningEngine.ps1 # Planning and verification
│   └── SystemPrompt.ps1    # System prompt builder
├── History/
│   └── History.ps1         # Session save/load
├── Memory/
│   └── Memory.ps1          # Persistent memory (MEMORY.md)
├── Skills/                 # Specialized workflow definitions
│   ├── code-generation.md
│   ├── data-extraction.md
│   ├── debug-error.md
│   ├── documentation.md
│   ├── file-analysis.md
│   ├── powershell-admin.md
│   ├── refactor.md
│   └── web-research.md
├── Tools/                  # Individual tool implementations
│   ├── Cache.ps1           # Caching system
│   ├── EditFile.ps1
│   ├── ExecutePowerShell.ps1
│   ├── GlobFiles.ps1
│   ├── Invoke-Tool.ps1     # Tool dispatcher
│   ├── ListDirectory.ps1
│   ├── OcrImage.ps1
│   ├── ReadFile.ps1
│   ├── SearchFiles.ps1
│   ├── SkillManager.ps1    # Skill discovery/loading
│   ├── ToolRegistry.ps1    # Tool schemas for LLM
│   ├── WebFetch.ps1
│   ├── WebSearch.ps1
│   └── WriteFile.ps1
├── UI/
│   └── Formatter.ps1       # CLI output formatting
├── PSCoder.psd1            # Module manifest
├── PSCoder.psm1            # Module loader
├── Start-PSCoder.ps1       # Quick start script
├── Iniciar-PSCoder.bat     # Windows launcher
├── Test-Human.ps1          # Comprehensive human simulation tests
├── Test-PSCoder.ps1        # Module tests
└── Verify-Fixes.ps1        # Fix verification tests
```

## Data Storage

All user data is stored in `~/.pscoder/`:
```
~/.pscoder/
├── config.json             # Configuration (API keys, model, etc.)
├── MEMORY.md               # Long-term memory
├── Sessions/               # Saved conversation sessions
├── improve/
│   ├── learnings.json      # Registered learnings
│   └── patterns.json       # Learned patterns
├── cache/                  # Web search/fetch cache
├── reasoning/              # Plan history
├── memory_decisions/       # Auto-decision log
└── hooks/                  # Custom hook scripts
```

**No API keys or sensitive data are stored in the repository.**

## License

MIT
