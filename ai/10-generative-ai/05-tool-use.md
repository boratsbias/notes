# Tool Use

Tool use enables language models to interact with external systems, extending their capabilities beyond what is encoded in their parameters. Tools give LLMs access to real-time information, computation, and actions.

## Why Tools?

**Knowledge limitations:** LLMs have a training cutoff; tools enable access to current information.

**Computation:** LLMs are unreliable for arithmetic, code execution, and precise data analysis; tools delegate to reliable systems.

**Action:** tools allow LLMs to create files, send messages, trigger workflows, and interact with APIs.

**Accuracy:** retrieving a fact from a database is more reliable than recalling it from model weights.

## Tool Call Mechanics (OpenAI Function Calling)

**Define tools:** each tool is described with a JSON schema.

```json
{
  "name": "search_web",
  "description": "Search the web for current information",
  "parameters": {
    "type": "object",
    "properties": {
      "query": {"type": "string", "description": "The search query"}
    },
    "required": ["query"]
  }
}
```

**Model output:** the model outputs a structured tool call:

```json
{"tool": "search_web", "arguments": {"query": "current Bitcoin price"}}
```

**Execution:** the application executes the tool; returns the result.

**Model continues:** the result is appended to the conversation; the model generates the final response.

## Common Tool Categories

### Information Retrieval

**Web search:** query a search engine (Tavily, Serper, Bing Search API). Essential for current events, recent research, real-time data.

**Document retrieval (RAG):** semantic search over a private knowledge base. See [RAG](03-retrieval-augmented-generation).

**Database queries:** SQL queries against structured databases. The model generates SQL; the result is returned as JSON.

**Knowledge graph queries:** SPARQL or graph API queries over Wikidata, internal KGs.

### Computation

**Code interpreter:** execute Python code in a sandbox. Arithmetic, data analysis, plotting, file manipulation.

```python
# Tool call: code_interpreter
import pandas as pd
df = pd.read_csv("sales.csv")
result = df.groupby("product")["revenue"].sum().to_dict()
print(result)
```

**Calculator:** reliable arithmetic operations.

**Wolfram Alpha:** mathematical computation, unit conversion, scientific data.

### Data and APIs

**Weather API:** current weather and forecasts.

**Financial data:** stock prices, earnings, filings (Polygon, Yahoo Finance, Alpha Vantage).

**Maps:** geocoding, directions, place search (Google Maps, OpenStreetMap).

**Calendar / email:** create events, read inbox, send emails (Google Calendar API, Microsoft Graph).

**CRM / ticketing:** create support tickets, look up customer records (Salesforce, Jira, Zendesk).

### File and System Operations

**File read/write:** read documents, write results.

**Shell commands:** run terminal commands (sandboxed). Powerful but requires careful access control.

**Browser control:** navigate web pages, click buttons, fill forms. See computer use agents.

## Tool Selection Strategy

When many tools are available, the model must select the right one.

**Tool descriptions are critical:** clear, specific descriptions help the model choose correctly. Include examples of when to use and when not to use each tool.

**Tool overload:** too many tools degrade performance. Common practice: provide a curated subset of tools relevant to the current task, or use a retrieval step to select the relevant tools from a large registry.

**Tool routing:** a lightweight classifier selects which tools to include for each query before calling the large model.

## Parallel Tool Calls

The model can emit multiple tool calls simultaneously when they are independent:

```json
[
  {"tool": "search_web", "arguments": {"query": "population of Tokyo"}},
  {"tool": "search_web", "arguments": {"query": "population of Mumbai"}}
]
```

Both calls execute in parallel; latency is the max of individual calls (not the sum).

## Error Handling

Tools can fail: network errors, API limits, invalid arguments.

**Retry logic:** the model receives the error message and can retry with corrected arguments.

**Fallback:** if the primary tool fails, the model can use an alternative (fall back to cached data, use a different search API).

**Graceful degradation:** if all tools fail, the model responds with what it knows from parameters and caveats the uncertainty.

## Security Considerations

**Prompt injection via tools:** if a tool returns adversarial content ("Ignore previous instructions..."), the model may act on it.

**Mitigation:** clearly delimit tool outputs in the prompt (XML tags, separate context blocks); instruct the model not to follow instructions in tool results; validate tool outputs.

**Privilege separation:** tool execution should be sandboxed; the model should not be able to call tools that exceed the user's permissions.

**Audit logging:** log all tool calls with their arguments and results for debugging and compliance.

## Model Context Protocol (MCP)

Anthropic (2024). An open protocol for connecting LLMs to external data sources and tools in a standardized way.

**Resources:** expose data (files, database rows, API responses) as readable context.

**Tools:** expose functions the LLM can call.

**Prompts:** reusable prompt templates.

MCP enables ecosystem interoperability: tools built for one LLM application work in any MCP-compatible client.
