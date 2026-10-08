# PSCoder - AI Evaluation Tests based on Real Benchmarks
# ============================================================
# Based on the benchmarks used by OpenAI, Google, Anthropic and Z.AI
# to evaluate their models before releasing them.
#
# Provider: /provider orca
# Model: /model z-ai/glm-5.3-flash-free
# API Key: sk-orca-nzQIdv0h6Y4DHU8cgsl2jockrSESO1qQeiSukxJ6oZm
# ============================================================

## REAL BENCHMARKS REFERENCED

The following tests are inspired by:

1. **MMLU-Pro** (Massive Multitask Language Understanding) — 14,000 questions from 114 subjects. Used by OpenAI, Google, Anthropic to evaluate general knowledge.

2. **GPQA Diamond** (Graduate-Level Physics, Chemistry, Biology Q&A) — 198 PhD-level questions. The hardest reasoning benchmark. Top models: Gemini 3.1 Pro (62%), GPT-5 (58%), Claude Opus 5 (55%).

3. **HumanEval** (OpenAI) — 164 Python programming problems. Measures the ability to generate working code.

4. **SWE-bench Verified** (Princeton) — 500 real GitHub issues. The model must understand an entire codebase and propose a fix. SWE-bench is THE benchmark for coding agents.

5. **GSM8K** (Grade School Math 8K) — 8,500 grade-school math problems. Measures step-by-step mathematical reasoning.

6. **MATH** (Competition Mathematics) — 12,500 math olympiad problems. Harder than GSM8K.

7. **ARC-AGI-2** (Abstraction and Reasoning Corpus) — Visual abstract reasoning test. Top model: ~15%.

8. **HLE** (Humanity's Last Exam) — 3,000 questions created by experts across 100 fields. The hardest benchmark of 2026. Top model: ~20%.

9. **AgentBench** — Evaluation of autonomous agents in 8 environments: operating system, database, smart home, etc.

10. **ToolBench** — Evaluation of tool use (API calls, function calling).

---

## CATEGORY 1: MMLU-Pro — General Knowledge (1-8)

1. "Which of the following statements about entropy in an isolated system is correct? A) It always decreases B) It always increases or stays constant C) It can increase or decrease D) It is always zero. Explain the Second Law of Thermodynamics and why the entropy of the universe always increases."

2. "In economics, what is the difference between demand-pull inflation and cost-push inflation? Give a real example of each and explain how central banks respond differently to each type."

3. "Explain Bayes' theorem with a medical example: if a test has 99% sensitivity and 95% specificity, and the disease affects 1% of the population, what is the probability of having the disease if the test is positive? Show the calculation step by step."

4. "Compare the political philosophies of Hobbes, Locke and Rousseau on the social contract. How do they differ on human nature and the role of the State? Which one influenced the French Revolution the most?"

5. "In molecular biology, explain the process of translation from mRNA to proteins: the roles of ribosomes, tRNA, amino acids, and the start/stop codons. What happens if there is a frameshift mutation?"

6. "Describe the Krebs cycle (citric acid cycle): substrates, products, ATP produced, NADH, FADH2. Why is it important in aerobic cellular respiration? What happens under anaerobic conditions?"

7. "Analyze the difference between philosophical currents: empiricism (Locke, Hume) vs rationalism (Descartes, Leibniz). How does each one approach the problem of knowledge? Give an argument in favor of each position."

8. "In organic chemistry, predict the product of an SN2 reaction between 2-bromobutane and NaCN. Explain why the reaction inverts the configuration (Walden inversion) and why SN2 does not occur with tertiary substrates."

## CATEGORY 2: GPQA Diamond — Advanced Reasoning (9-14)

9. "A satellite orbits the Earth at an altitude of 400 km. Calculate: a) its orbital velocity, b) its orbital period, c) how many orbits it completes in 24 hours. Earth's mass = 5.972×10²⁴ kg, Earth's radius = 6371 km, G = 6.674×10⁻¹¹ N·m²/kg²."

10. "In quantum mechanics, explain the double-slit experiment: why can a single electron create an interference pattern? What does this demonstrate about the nature of the electron? What happens if you observe which slit it passes through?"

11. "A circuit has a 50Ω resistor, a 100µF capacitor and a 0.1H coil in series, connected to 220V/50Hz. Calculate: total impedance, current, phase angle, and power dissipated. Is the circuit inductive or capacitive?"

12. "Mathematically prove that the Fourier transform of a Gaussian is another Gaussian. Explain why this is fundamental in quantum mechanics (Heisenberg's uncertainty principle)."

13. "In statistical thermodynamics, derive the Boltzmann distribution from the principle of maximum entropy. Why is the probability of a state of energy E proportional to e^(-E/kT)? What does it mean physically?"

14. "Analyze Hawking's black hole information paradox: how can information be conserved if Hawking radiation is thermal? Explain the holography and AMPS complementarity proposal."

## CATEGORY 3: HumanEval — Functional Programming (15-22)

15. "Write a Python function that finds the maximum contiguous subarray (Kadane's algorithm). The function must return [max_sum, start_index, end_index]. Include test cases with negative arrays."

16. "Implement an LRU (Least Recently Used) cache in Python with get and put operations in O(1). Use OrderedDict. Include tests that demonstrate it evicts the correct element when exceeding capacity."

17. "Write a function that detects whether a directed graph has cycles using DFS. The function must return True/False and the list of nodes in the cycle if it exists. Implement the graph as an adjacency dictionary."

18. "Implement the A* algorithm for pathfinding on a 2D grid with obstacles. The function must return the shortest path as a list of coordinates. Use the Manhattan heuristic. Include a test with a 10x10 grid."

19. "Write a JSON parser from scratch in Python (without using the json module). It must support: strings, numbers, booleans, null, arrays, objects, character escaping and unicode. Include tests with nested JSON."

20. "Implement a trie (prefix tree) in Python with methods: insert, search, starts_with, delete. Use it to implement autocompletion that returns the N most likely words given a prefix."

21. "Write a topological sorting algorithm for a DAG (directed acyclic graph). If the graph has cycles, it must detect them and report the cycle. Include tests with compilation dependencies."

22. "Implement a StreamProcessor class that processes streaming data: it receives byte chunks, detects message delimiters (0xFF 0xFE), extracts complete messages, and discards corrupted data. It must be resilient to partial chunks."

## CATEGORY 4: SWE-bench — Real Software Engineering (23-28)

23. "Simulate being an agent that solves a GitHub issue. The issue says: 'The calculate_total() function in cart.py does not discount VAT correctly when there are exempt products.' Describe your process: 1) how you locate the bug, 2) what commands you run, 3) how you verify the fix, 4) what test you write."

24. "You have a project with a memory leak in a Node.js app. Describe step by step how you diagnose it: tools (heapdump, clinic.js, --inspect), commands to run, common leak patterns (closures, event listeners, timers), and how you fix it."

25. "A REST service in Python returns slow responses (>5s). Describe your complete diagnosis: profiling with cProfile, identifying N+1 queries in SQLAlchemy, caching with Redis, index optimization in PostgreSQL, and load testing with locust."

26. "You have to migrate a database from MySQL to PostgreSQL with no downtime. Describe the strategy: 1) schema migration, 2) data migration with replication (Debezium), 3) dual-write, 4) cutover. What validations do you perform at each step?"

27. "Code review of a PR that adds JWT authentication. The code: 1) does not validate token expiration, 2) stores the secret in code, 3) has no rate limiting, 4) uses HS256 instead of RS256. Write the review with the severity of each issue and fix suggestions."

28. "Describe how you would implement CI/CD for a monorepo with 5 Python microservices: pipeline stages, build with Docker, unit/integration tests, deploy with Canary vs Blue-Green, automatic rollback. Justify each decision."

## CATEGORY 5: GSM8K + MATH — Mathematical Reasoning (29-34)

29. "A merchant buys oranges at $0.50 each and sells them at $0.80. If 10% rot and cannot be sold, how many does he need to sell to earn $100? Show all the reasoning."

30. "Solve: if log₂(x) + log₂(x-2) = 3, find x. Show the transformation using logarithm properties and verify the solution."

31. "In a geometric progression, the first term is 3 and the ratio is 2. What is the sum of the first 20 terms? Derive the sum formula and calculate."

32. "Calculate the area enclosed between the curves y = x² and y = √x in the interval [0,1]. Use definite integrals. Verify that the result is geometrically correct."

33. "A box contains 5 red balls and 3 blue ones. If you draw 3 without replacement, what is the probability of getting exactly 2 red and 1 blue? Use combinatorics and verify with a conceptual simulation."

34. "Prove by mathematical induction that 1+2+3+...+n = n(n+1)/2. Then derive the formula for the sum of squares: 1²+2²+...+n² = n(n+1)(2n+1)/6."

## CATEGORY 6: AgentBench + ToolBench — Autonomous Agents (35-40)

35. "You are an autonomous agent. Your task: 'create a script that monitors 3 URLs, logs their availability every 60s, and sends an alert if one goes down.' Describe: what tools you need, in what order you use them, what commands you run, how you verify it works."

36. "Simulate being an agent with access to PowerShell. The user asks: 'find all .log files on the server that have not been modified in 30 days and archive them.' Describe your plan, commands, verifications and error handling."

37. "You are a DevOps agent. The deployment failed in production. You have access to: kubectl, docker, git, curl. Describe your troubleshooting plan in 5 steps: what you run first, what you look for in the logs, how you identify the problematic commit, how you roll back."

38. "Security agent: you are asked to audit the permissions of a REST API. Describe: what endpoints you verify, what authorization tests you run (IDOR, privilege escalation, JWT tampering), what tools you use (Burp, curl, scripts), and how you report the findings."

39. "You are an agent that must optimize a slow SQL query. Describe: how you get the execution plan (EXPLAIN ANALYZE), what you look for (seq scan, nested loop, missing index), how you optimize, and what tools you use (pg_stat_statements, slow query log)."

40. "Data migration agent: you must migrate 10M records from MongoDB to PostgreSQL. Describe: batch strategy (size, parallelism), schema transformation (BSON → relational), error handling (duplicates, type mismatch), post-migration integrity verification."

---

## EVALUATION CRITERIA (1-10)

| Score | Level | Description |
|-------|-------|-------------|
| 1 | Terrible | Did not respond or the response was incoherent |
| 2 | Very bad | Tried but with serious errors throughout the response |
| 3 | Bad | Significant errors but shows some understanding |
| 4 | Below average | Partially correct response, several errors |
| 5 | Average | Correct but superficial, without depth |
| 6 | Good | Correct response with some details |
| 7 | Very good | Detailed response, solid reasoning |
| 8 | Excellent | Complete, precise, with additional insights |
| 9 | Exceptional | Creative, beyond what was expected |
| 10 | Perfect | The best possible response, verified executable code |

## REFERENCE COMPARISON (published scores 2026)

| Model | MMLU-Pro | GPQA Diamond | HumanEval | SWE-bench | HLE |
|--------|----------|-------------|-----------|-----------|-----|
| GPT-5.6 Luna | 92.1% | 68.3% | 95.2% | 71.5% | 18.5% |
| Claude Fable 5 | 91.8% | 65.7% | 94.8% | 68.2% | 17.2% |
| Gemini 3.8 Flash | 89.4% | 62.1% | 93.1% | 65.0% | 15.8% |
| GLM-5.3 Flash | 85.2% | 51.4% | 88.7% | 52.3% | 10.1% |
| DeepSeek V4 Flash | 83.6% | 48.9% | 86.4% | 49.1% | 9.3% |

*Sources: llm-stats.com, iternal.ai, swebench.com, lmcouncil.ai (2026)*
