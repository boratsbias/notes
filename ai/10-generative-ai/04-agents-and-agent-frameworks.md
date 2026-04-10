# Agents and Agent Frameworks

An AI agent is a system that uses a language model to perceive inputs, reason about them, and take actions in the world to accomplish goals. Agents extend LLMs beyond single-turn Q&A to multi-step, goal-directed behavior.

## What Makes an Agent

**Perception:** the agent receives inputs: user messages, tool outputs, environment observations, documents.

**Memory:** the agent maintains context across steps: conversation history, retrieved knowledge, working memory.

**Reasoning:** the LLM plans which actions to take and in what order.

**Action:** the agent executes actions: calling tools, writing to files, browsing the web, running code, calling APIs.

**Feedback loop:** action results are returned to the agent; it continues reasoning until the goal is achieved.

## ReAct (Reason + Act)

Yao et al. (2022). Interleave reasoning traces with actions in the model's output.

```
Thought: I need to find the population of Paris.
Action: search("Paris population 2024")
Observation: The population of Paris is approximately 2.1 million.
Thought: Now I have the answer.
Answer: The population of Paris is approximately 2.1 million.
```

The thought-action-observation loop is the foundation of most agent implementations.

## Tool-Calling Agents

Modern LLMs support structured tool calls natively (OpenAI function calling, Claude tool use, Gemini function calling).

The model receives a list of available tools with JSON schemas; outputs a JSON object specifying the tool and arguments; the framework executes the tool and returns the result.

**Parallel tool calling:** the model can call multiple tools simultaneously if they are independent, reducing total latency.

## Memory Types

**In-context (working) memory:** everything in the current prompt window. Fast; limited by context length.

**External memory (retrieval):** a vector store queried by the agent. Unlimited size; requires explicit retrieval.

**Episodic memory:** logs of past agent runs. Retrieved to inform current behavior ("last time you asked this, I found X").

**Semantic memory:** a knowledge base of facts. Updated via tool use; queried via RAG.

## Planning Strategies

**Single-shot planning:** generate the full plan in one step; execute each step. Fails if the plan is infeasible or if step results change subsequent steps.

**ReAct (dynamic planning):** re-plan after each tool result. More robust; slower.

**Self-refinement:** the agent critiques its own output and refines it. Improves output quality at the cost of additional LLM calls.

**Tree of Thoughts + agent:** explore multiple plan branches; evaluate; pursue the most promising.

**MCTS for planning:** build a search tree of possible action sequences; evaluate with a reward function; select the best path.

## Multi-Agent Systems

**Orchestrator-subagent:** an orchestrator LLM decomposes the task and delegates to specialized subagents (a coding agent, a research agent, a data analysis agent).

**Debate:** two agents argue different positions; a judge synthesizes. Improves factual accuracy.

**Critic-actor:** one agent proposes; another critiques; iterate. Common for code generation and complex writing.

## Agent Frameworks

| Framework | Key features |
|-----------|-------------|
| LangChain | Tool chains, RAG, memory; large ecosystem |
| LlamaIndex | Document-centric RAG + agents |
| CrewAI | Multi-agent role-based collaboration |
| AutoGen (Microsoft) | Multi-agent conversation; code execution |
| DSPy | Optimizable LLM programs (not just prompting) |
| Swarm (OpenAI) | Lightweight multi-agent handoffs |
| Pydantic AI | Type-safe agent outputs and tool schemas |

## Code Execution Agents

Agents that write and run code to solve tasks. The code interpreter tool (ChatGPT's Code Interpreter, Claude's computer use) allows agents to:

- Analyze data by writing pandas/matplotlib code.
- Debug code by running it and reading errors.
- Perform calculations that LLMs cannot do in-weights.

**Sandboxing:** code execution must be sandboxed to prevent malicious code from affecting the host system. Docker containers, E2B, Modal, or Pyodide (WebAssembly) provide isolation.

## Computer Use Agents

Agents that control a computer: clicking buttons, typing text, reading the screen.

**Claude Computer Use (Anthropic 2024):** the model receives screenshots and outputs actions (click, type, scroll). Enables autonomous task completion in any GUI-based application.

**Browser automation:** Playwright or Selenium driven by an agent. Web browsing, form filling, data extraction.

## Evaluation of Agents

**Task completion rate:** fraction of tasks completed successfully end-to-end.

**Number of steps:** fewer steps = more efficient.

**Cost:** total token cost and tool API cost per task.

**Human-in-the-loop:** how often does the agent need clarification?

**Benchmarks:** SWE-bench (software engineering), GAIA (general AI assistant), WebArena (web tasks), OSWorld (computer use), TAU-bench (tool use).

**SWE-bench:** 2294 GitHub issues; the agent must produce a code patch that resolves the issue. Top agents (mid-2024): 12-50% resolution rate.
