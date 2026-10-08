# PSCoder - Complete Tests for ALL Features
# ============================================================
# This file tests every PSCoder capability:
# - 8 Skills (code-generation, data-extraction, debug, docs, file-analysis, ps-admin, refactor, web-research)
# - 20 Tools registered in ToolRegistry
# - 5 Core Systems (AutoHealing, AutoImprove, MemoryDecision, Hooks, ReasoningEngine)
# - 3 Providers (Custom, Groq, OrcaRouter)
# - Slash commands (/help, /model, /provider, /memory, /config, /narrate, /tools)
#
# Provider: /provider orca
# Model: /model z-ai/glm-5.3-flash-free
# ============================================================

## ============================================================
## SECTION A: BASIC SLASH COMMANDS (1-6)
## ============================================================

1. "/help — Run /help and verify that it shows all available commands: /clear, /model, /provider, /memory, /tools, /config, /narrate, /speak, /pwd, /exit. Are they all listed?"

2. "/tools — Run /tools and verify that it lists the 20 tools: execute_powershell, read_file, write_file, edit_file, search_files, glob_files, list_directory, get_current_dir, web_search, web_fetch, auto_heal, learn_from_error, find_solution, ocr_image, create_plan, verify_step, verify_task, save_learning, list_skills, read_skill, add_plan_step."

3. "/model — Run /model with no arguments and verify that it shows models from Custom, Groq AND OrcaRouter (including the -free models)."

4. "/provider — Run /provider with no arguments. It should show: custom, groq, orca. Then run /provider orca and verify that it switches the provider and the model to z-ai/glm-5.3-flash-free."

5. "/config — Run /config and verify that it shows all configuration keys: apiKey, groqApiKey, orcaApiKey, provider, model, orcaModel, maxTokens, temperature, etc. Then run /config temperature 0.5 and verify that it is updated."

6. "/memory add test — Run /memory add 'This is a memory test'. Then run /memory and verify that the note appears. Then /memory clear to clean up."

## ============================================================
## SECTION B: SKILLS — Skill System (7-14)
## ============================================================

### Skill: code-generation
7. "I need you to generate a PowerShell script that monitors CPU and memory usage every 5 seconds, and generates an alert if CPU exceeds 80%. Use the code-generation skill."

### Skill: data-extraction
8. "Extract all the data from the following text and structure it in table format: 'Server SRV-01 with IP 192.168.1.10 has 8GB RAM, Intel Xeon E5 CPU, 500GB SSD disk, Windows Server 2019. Server SRV-02 with IP 192.168.1.11 has 16GB RAM, AMD EPYC CPU, 1TB NVMe disk, Ubuntu 22.04.'"

### Skill: debug-error
9. "I have this error in PowerShell: 'Cannot bind argument to parameter Path because it is null. At line:5 char:15 + Get-Content $file <<<<'. How do I fix it? Use the debug skill."

### Skill: documentation
10. "Generate complete documentation for this PowerShell function: function Get-SystemInfo { param([string]$ComputerName='localhost') Get-CimInstance Win32_ComputerSystem -ComputerName $ComputerName | Select-Object Name, Manufacturer, Model, TotalPhysicalMemory }. Create a README.md with description, parameters, examples and requirements."

### Skill: file-analysis
11. "Analyze the structure of the current directory. List all .ps1 files, identify the main modules, detect dependencies between files (who imports whom), and generate a dependency tree."

### Skill: powershell-admin
12. "As a system administrator, I need to: 1) list the 10 processes that consume the most CPU, 2) check the disk space of all drives, 3) show the services that are configured to start automatically but are stopped. Use the powershell-admin skill."

### Skill: refactor
13. "Refactor this PowerShell code to make it more efficient and readable: `$r = @(); foreach ($i in 1..100) { $r += Get-Random }; return $r. Suggest improvements: use a pipeline, measure performance, explain why it is better."

### Skill: web-research
14. "Search the internet for the latest version of PowerShell and what the main new features are. Use the web-research skill and the web_search tool."

## ============================================================
## SECTION C: TOOLS — Each tool individually (15-30)
## ============================================================

### execute_powershell
15. "Run this PowerShell command: Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 Name, CPU, WorkingSet. Show the 5 processes that consume the most CPU."

16. "Run: Get-CimInstance Win32_LogicalDisk | Select-Object DeviceID, @{N='Size(GB)';E={[math]::Round($_.Size/1GB,2)}}, @{N='Free(GB)';E={[math]::Round($_.FreeSpace/1GB,2)}}. Show the disk space."

### read_file + write_file
17. "Create a file called test-pscoder.txt with the content 'Hello from PSCoder'. Then read it and show me the content to verify that it was created correctly."

### edit_file
18. "Create a config-test.txt file with the text 'version=1.0' and 'name=test'. Then use edit_file to change 'version=1.0' to 'version=2.0'. Read the file again to verify the change."

### search_files
19. "Search the current directory for all files containing the word 'function'. Use search_files with the pattern 'function'. Show the results with the file and the line where it appears."

### glob_files
20. "Find all .ps1 files in the current directory using glob_files with the pattern *.ps1. List how many files it found."

### list_directory
21. "List the contents of the current directory using list_directory. Show files and folders with their sizes and modification dates."

### get_current_dir
22. "Show the current working directory using get_current_dir."

### web_search
23. "Search the internet for 'PowerShell 7.5 release date' using web_search. Return the titles and URLs of the results."

### web_fetch
24. "Fetch the content of the URL https://httpbin.org/json using web_fetch. Return the parsed JSON."

### auto_heal
25. "Simulate an error: run 'Get-Content /path/nonexistent.txt' which will produce an error. Then use auto_heal to analyze the error and suggest a solution. Verify that the suggestion is useful."

### learn_from_error + find_solution
26. "Use learn_from_error to record: category='file_access', problem='File not found when using Get-Content', solution='Verify that the path exists with Test-Path before reading'. Then use find_solution searching for 'file not found' and verify that it finds the recorded solution."

### ocr_image
27. "If you have an image with text in the current directory (screenshot, photo), use ocr_image to extract the text. If there is no image, describe how you would use this tool and what formats it supports."

### create_plan + add_plan_step + verify_step + verify_task
28. "Create a plan for this task: 'Create a script that backs up a folder'. Use create_plan, then add_plan_step to add 3 steps: 1) identify the folder, 2) create the backup script, 3) run and verify. Use verify_step after each step and verify_task at the end."

### save_learning
29. "Use save_learning to save a learning: category='command_workflow', information='To compress files in PowerShell use Compress-Archive -Path origen -DestinationPath destino.zip'. Verify that it was saved."

### list_skills + read_skill
30. "Run list_skills to show all available skills (8 skills). Then use read_skill to load the 'powershell-admin' skill and describe what it contains: description, tools to use, workflow."

## ============================================================
## SECTION D: CORE SYSTEMS (31-35)
## ============================================================

### AutoHealing
31. "Trigger an intentional error: run 'Get-Service NonexistentService'. When it fails, the AutoHealing system should analyze the error automatically. Describe what AutoHealing suggests and whether the suggestion is useful."

### AutoImprove + Learning
32. "Record 3 different errors with learn_from_error (file_access, command_not_found, permission_denied). Then use find_solution to search for each one. Verify that the system remembers all the solutions. How many solutions does it have stored?"

### MemoryDecision
33. "During a conversation about network configuration, mention: 'I always prefer to use Cloudflare DNS 1.1.1.1'. The MemoryDecision system should detect this as a user preference and save it to memory automatically. Verify by running /memory afterwards."

### Hooks (PreToolUse, PostToolUse, Stop)
34. "Verify that the hooks are configured: 1) PreToolUse should run before each tool (check the logs), 2) PostToolUse afterwards (check the logs), 3) Stop at the end of each turn. Describe how you would create a hook that blocks commands with 'Remove-Item -Recurse'."

### ReasoningEngine (create_plan, verify_step, verify_task)
35. "Create a complex 5-step plan for: 'Audit the security of a Windows server'. Use create_plan, add 5 steps with add_plan_step (each one with tool and successCriteria), run each step with verify_step (simulating success or failure), and at the end use verify_task to generate the complete report. Verify that the report includes the status of each step, the tools used and the files created."

## ============================================================
## SECTION E: AGENT NARRATION + SPEECH (36-37)
## ============================================================

### Visual narration + voice
36. "Run /narrate on to enable agent narration. Then ask a complex question such as 'explain how DNS works' and verify that: 1) 'Thinking...' is shown while it processes, 2) the tool actions are narrated, 3) the result is shown. Then run /narrate off."

### Text-to-Speech
37. "Run /speak 'Hello, I am PSCoder and I am working correctly'. Verify that audio plays. If there is no audio, run /narrate voice to enable voice and try again with /narrate test."

## ============================================================
## SECTION F: CONTEXT + PERSISTENT MEMORY (38-40)
## ============================================================

### Context Builder (Git + PSCODER.md)
38. "If you are in a directory with a git repository, run a command and verify that ContextBuilder detects: 1) the git state (branch, uncommitted changes), 2) whether a PSCODER.md or README.md file exists, 3) that this information is included in the system prompt."

### Persistent memory between sessions
39. "Save to memory: /memory add 'My main server is SRV-PROD-01 with IP 10.0.0.5'. Then run /exit to quit. Start PSCoder again and ask a question related to your server. Verify that the system remembers the saved information."

### Session history
40. "After having a multi-turn conversation, run /exit. Then start PSCoder again and run /history to list the saved sessions. Use /load <id> to load a previous session and verify that the complete context is restored."

## ============================================================
## SECTION G: MULTI-TOOL INTEGRATION (41-45)
## ============================================================

### Complete multi-step task
41. "Complete task: 1) Create a folder 'test-pscoder', 2) inside it create a script 'monitor.ps1' that pings 8.8.8.8, 3) run it, 4) read the result, 5) if there are errors use auto_heal, 6) delete the test folder. Use create_plan to plan, verify each step."

### Real code analysis
42. "Read the complete PSCoder.psm1 file. Then: 1) identify how many modules it loads, 2) check whether there are duplicate imports, 3) suggest 2 improvements to the code, 4) generate a report. Use read_file, search_files, and the refactor skill."

### Assisted debugging
43. "Create a script with an intentional bug: '$items = @(1,2,3); foreach ($i in $items) { Write-Host $items[$i] }'. Run it and when you see the incorrect result (it shows 2, 3 and an empty one), use auto_heal to diagnose. Then fix the code with edit_file and run it again to verify."

### Research workflow
44. "Research what 'Windows Terminal' is and what its advantages are: 1) use web_search to find information, 2) use web_fetch to read the official documentation, 3) create a summary file with the key points, 4) save what you learned with save_learning."

### Complete system audit
45. "Perform a complete audit: 1) list the current directory, 2) read the 3 most important files, 3) search for hardcoded credentials (pattern: password=, apiKey=, token=), 4) check whether there are dangerous commands (Invoke-Expression, iex), 5) generate a security report with the conclusions. Use create_plan to plan, run each step, and verify_task at the end."

## ============================================================
## SECTION H: STRESS AND LIMIT TESTS (46-50)
## ============================================================

### Long context
46. "Generate a list of 50 fictitious servers (name, IP, status). Then ask the model to analyze which ones are down and suggest actions. Verify that the model can handle a long context without losing information."

### Multiple tools in one turn
47. "In a single request, ask to: 1) list the directory, 2) read a file, 3) search for a pattern, 4) run a command. Verify that the model chains 4 tools in a single turn without losing the thread."

### Auto-compaction
48. "Hold a long conversation (more than 20 turns) with varied questions. When the context approaches the limit, the system should auto-compact automatically. Verify that after compacting, the model still remembers the key points of the conversation."

### Recoverable error handling
49. "Run a command that will fail (e.g., access a protected system file). Verify that: 1) the system captures the error, 2) AutoHealing suggests a solution, 3) the model can retry with a different approach, 4) learn_from_error records the learning."

### Multi-format response
50. "Ask the model to respond in 3 different formats: 1) an explanation in plain text, 2) a table in Markdown, 3) an executable PowerShell script. Verify that the 3 formats are correct and the script works when run."

## ============================================================
## EVALUATION CRITERIA BY COMPONENT (1-10)
## ============================================================

| Component | What to evaluate | Score 1-3 | Score 4-6 | Score 7-8 | Score 9-10 |
|-----------|-------------|-----------|-----------|-----------|------------|
| **Skills** | Does it load the correct skill? | Does not load skill | Loads but does not follow workflow | Loads and follows workflow partially | Loads, follows workflow and executes correctly |
| **Tools** | Does it run the correct tool? | Does not run tool | Runs tool but with errors | Runs correctly | Runs + verifies result |
| **AutoHealing** | Does it analyze and suggest? | Does not analyze | Suggests something generic | Suggests something specific | Suggests + applies automatic fix |
| **AutoImprove** | Does it learn from errors? | Does not learn | Records but does not retrieve | Records and retrieves | Records, retrieves and applies proactively |
| **MemoryDecision** | Does it save automatically? | Does not save | Saves noise | Saves relevant info | Saves + classifies + retrieves |
| **Hooks** | Do they run? | They do not run | They run but do not log | They run and log | They run, log and block correctly |
| **ReasoningEngine** | Does it plan and verify? | Does not plan | Plans but does not verify | Plans and verifies | Plans, verifies and self-corrects |
| **Narration** | Does it narrate actions? | Does not narrate | Narrates but late | Narrates in real time | Narrates + voice + optimal speed |
| **Multi-tool** | Does it chain tools? | Does not chain | Chains 2 tools | Chains 3-4 tools | Chains 5+ tools with verification |
| **Context** | Does it handle long context? | Loses context <10 turns | Loses >15 turns | Auto-compacts well | Auto-compacts + summarizes + remembers everything |

## ============================================================
## SUMMARY OF TESTED COMPONENTS
## ============================================================

### 8 Skills
- [ ] code-generation (Test 7)
- [ ] data-extraction (Test 8)
- [ ] debug-error (Test 9)
- [ ] documentation (Test 10)
- [ ] file-analysis (Test 11)
- [ ] powershell-admin (Test 12)
- [ ] refactor (Test 13)
- [ ] web-research (Test 14)

### 20 Tools
- [ ] execute_powershell (Tests 15-16)
- [ ] read_file (Test 17)
- [ ] write_file (Test 17)
- [ ] edit_file (Test 18)
- [ ] search_files (Test 19)
- [ ] glob_files (Test 20)
- [ ] list_directory (Test 21)
- [ ] get_current_dir (Test 22)
- [ ] web_search (Test 23)
- [ ] web_fetch (Test 24)
- [ ] auto_heal (Test 25)
- [ ] learn_from_error (Test 26)
- [ ] find_solution (Test 26)
- [ ] ocr_image (Test 27)
- [ ] create_plan (Test 28)
- [ ] add_plan_step (Test 28)
- [ ] verify_step (Test 28)
- [ ] verify_task (Test 28)
- [ ] save_learning (Test 29)
- [ ] list_skills (Test 30)
- [ ] read_skill (Test 30)

### 5 Core Systems
- [ ] AutoHealing (Test 31)
- [ ] AutoImprove (Tests 32, 49)
- [ ] MemoryDecision (Test 33)
- [ ] Hooks (Test 34)
- [ ] ReasoningEngine (Tests 28, 35)

### 3 Providers
- [ ] Custom (Test 3)
- [ ] Groq (Test 3)
- [ ] OrcaRouter (Test 4)

### Slash Commands
- [ ] /help (Test 1)
- [ ] /tools (Test 2)
- [ ] /model (Test 3)
- [ ] /provider (Test 4)
- [ ] /config (Test 5)
- [ ] /memory (Test 6, 39)
- [ ] /narrate (Test 36)
- [ ] /speak (Test 37)
- [ ] /history (Test 40)
- [ ] /load (Test 40)

### Advanced Capabilities
- [ ] Visual narration + voice (Tests 36-37)
- [ ] Context Builder with Git (Test 38)
- [ ] Persistent memory (Test 39)
- [ ] Session history (Test 40)
- [ ] Multi-tool chaining (Tests 41-45)
- [ ] Long context + auto-compact (Test 48)
- [ ] Recoverable error handling (Test 49)
- [ ] Multi-format response (Test 50)

### Total: 50 tests covering ALL of PSCoder's functionality
