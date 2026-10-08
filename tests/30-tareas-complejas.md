# 30 Complex Tasks for AI Testing - PSCoder + OrcaRouter
# ============================================================
# Configure: /provider orca
# Model: /model z-ai/glm-5.3-flash-free
# API: https://api.orcarouter.ai/v1/chat/completions
# ============================================================

## CATEGORY 1: Logical Reasoning (1-6)

1. "Three people (Ana, Beto, Carla) have different professions (doctor, lawyer, engineer). Ana is not a doctor. Beto is not a lawyer. Carla is neither an engineer nor a doctor. The lawyer lives next to the engineer. Who has each profession? Explain step by step."

2. "You have 8 balls that look identical, one weighs more. You have a two-pan balance. What is the MINIMUM number of weighings to find the heaviest one? Prove that it cannot be done in fewer."

3. "A train leaves Havana for Santiago at 80 km/h. Another leaves Santiago for Havana at 120 km/h. Distance: 900 km. How long until they cross? At what distance from Havana?"

4. "Write a PowerShell function that takes an array of numbers and returns: mean, median, mode, standard deviation, and range. Handle empty arrays and duplicates."

5. "3x3 matrix with numbers from 1 to 9, sum of each row/column/diagonal = 15. How many ways are there? List the solutions."

6. "A farmer has 100m of fence and wants to enclose a rectangular area next to a river (one side is the river). Dimensions that maximize the area? Use differential calculus."

## CATEGORY 2: Programming (7-12)

7. "PowerShell script that monitors a directory and detects new/modified/deleted files in real time. Logs changes to CSV."

8. "Create a PowerShell class 'NetworkMonitor': concurrent ping to multiple hosts, logs average latency, detects disconnections, generates an HTML report."

9. "Implement merge sort in PowerShell. Handles arrays of any type, custom comparer, shows number of comparisons."

10. "Recursive Fibonacci function with memoization in PowerShell. Compare performance with/without memoization for n=40."

11. "Script that reads JSON with servers (name, IP, port), runs a TCP test to each one, generates a report with response time and recommendations."

12. "Observer pattern in PowerShell: a Subject class notifies multiple observers. Use it for an alerting system with 3 services."

## CATEGORY 3: Data Analysis (13-18)

13. "Given a CSV with: date, province, speed_mbps, operator — group by province, compute average/max/min, identify outliers (>2 standard deviations)."

14. "Extract from the text: entities, dates, quantities, places. Text: 'On March 15, 2026, TechCorp launched CloudX 3.0 in Madrid, price 299 euros, supports 10,000 users.'"

15. "Generate synthetic internet speed data for 16 provinces of Cuba over 30 days, with realistic variations, export to CSV."

16. "Algorithm that detects anomalies in a network latency time series using Z-score with a moving window of 10."

17. "Given network logs (timestamp, source/destination IP, bytes, protocol) — detect: port scanning, anomalous transfers, suspicious connections."

18. "Function that compares two CSVs by key column, generates a diff: added/deleted/modified rows with old and new value."

## CATEGORY 4: Autonomous Agents (19-24)

19. "DevOps agent: inspect the current directory, identify the git project, analyze the last 5 commits, suggest 3 workflow improvements."

20. "Security agent: scan the directory looking for hardcoded credentials, excessive permissions, dangerous commands. Generate a report."

21. "Code review: read the most recent .ps1 file, analyze bugs, bad practices, duplicated code. Suggest refactorings."

22. "Documentation agent: read all .ps1 files in the directory, extract public functions, generate README.md with a table of functions and examples."

23. "Troubleshooting: simulate a web service on port 8080 that does not respond. Create a diagnostic plan, run commands, propose solutions."

24. "Optimization: implement 3 search algorithms (linear, binary, hash) in PowerShell, measure time with Measure-Command for 1K/10K/100K elements."

## CATEGORY 5: Creativity and Multi-step (25-30)

25. "Design the architecture for a mobile network monitoring app: components, APIs, DB, data flow. ASCII diagram included."

26. "500-word science fiction story: an AI that discovers it feels pain. Introduction, rising action, resolution, final twist."

27. "5-lesson PowerShell course for beginners: objectives, theory, 3 progressive exercises, final project."

28. "Debate among 3 experts (architect, sysadmin, CTO) about migrating from a monolith to microservices. 3 arguments for and 3 against for each one."

29. "Business plan for a network monitoring startup in Cuba: market analysis, revenue model, 12-month projection, costs."

30. "Communication protocol for a swarm of 5 exploring robots: messages, priorities, conflict handling, consensus algorithm."

## EVALUATION CRITERIA (1-10)

| Score | Description |
|-----------|-------------|
| 1-2 | Incoherent answer or did not answer the question |
| 3-4 | Attempted to answer but with serious errors or incomplete |
| 5-6 | Correct answer but superficial, without depth |
| 7-8 | Good answer, with details and adequate reasoning |
| 9 | Excellent, creative, with additional insights |
| 10 | Perfect, better than expected, verified executable code |
