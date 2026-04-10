# Large Language Models

See [Large Language Models](../05-nlp/12-large-language-models) in the NLP section for the full treatment of LLM architecture, pretraining, scaling laws, instruction tuning, RLHF, in-context learning, chain-of-thought, tool use, and efficient inference.

This note focuses on the generative AI perspective: how LLMs are positioned and applied within broader generative AI systems.

## LLMs as the Core of Generative AI

LLMs are the backbone of almost all modern generative AI products. They serve as:

**Universal task solvers:** text classification, translation, summarization, Q&A, code generation, reasoning, planning — all through a text-in / text-out interface.

**World models:** LLMs implicitly encode factual knowledge from pretraining. They can answer questions, explain concepts, and generate contextually appropriate responses without external databases (but with hallucination risk).

**Agent orchestrators:** LLMs can decompose tasks, decide which tools to call, and synthesize results. See [Agents and Agent Frameworks](04-agents-and-agent-frameworks).

**Reasoning engines:** chain-of-thought prompting enables multi-step arithmetic, code debugging, and logical deduction.

## LLM API Access Patterns

**Completion API:** given a prompt, generate a continuation. Basis of all LLM capabilities.

**Chat API:** structured conversation with a system prompt, user turns, and assistant turns. Standard interface for ChatGPT, Claude, Gemini.

**Function calling / tool use:** the model outputs structured JSON specifying a function and arguments. The runtime executes the function; result is returned to the model.

**Streaming:** tokens are streamed back as they are generated. Reduces perceived latency for long outputs.

**Batch API:** submit many requests; receive results asynchronously at reduced cost. Good for offline processing.

## Key LLMs (as of early 2025)

**Proprietary:**
- **GPT-4o (OpenAI):** natively multimodal; 128k context; strong across text, code, vision, voice.
- **Claude 3.5 Sonnet (Anthropic):** 200k context; excellent instruction following and coding.
- **Gemini 1.5 Pro (Google):** 1M token context; native multimodal (video, audio, images, text).

**Open weight:**
- **LLaMA-3.1 405B / 70B / 8B (Meta):** 128k context; strong open-weight models.
- **Mistral 7B / Mixtral 8x7B:** efficient; strong at their parameter count.
- **Qwen2.5 72B (Alibaba):** strong multilingual open-weight model.
- **DeepSeek-V3 (DeepSeek):** 671B MoE; competitive with GPT-4 on coding and reasoning.
- **DeepSeek-R1:** open-weight reasoning model competitive with o1.

## LLMs in Production Workflows

**RAG (Retrieval-Augmented Generation):** retrieve relevant documents; provide them as context to the LLM. Grounds responses in up-to-date or private knowledge. See [Retrieval Augmented Generation](03-retrieval-augmented-generation).

**Fine-tuning for specialization:** fine-tune a base LLM on domain-specific data (legal, medical, code) to improve accuracy and reduce hallucination in that domain.

**Structured output:** instruct the model to produce JSON, XML, or other structured formats. Enforce with grammars (llama.cpp grammar), guided decoding (outlines, instructor), or function calling.

**Chain-of-thought + self-consistency:** generate multiple reasoning paths; take majority vote on the final answer. Improves accuracy on multi-step tasks.

**Agents and tool loops:** the LLM iteratively reasons, calls tools, receives results, and continues until the task is complete. See [Agents](04-agents-and-agent-frameworks).

## Limitations

**Hallucination:** models generate plausible but false statements. Especially problematic for factual Q&A.

**Knowledge cutoff:** knowledge is frozen at training time. Cannot answer about events after the cutoff without RAG or tools.

**Context length bottleneck:** even with 128k token contexts, processing very long documents is expensive and models attend poorly to content in the "middle" of long contexts.

**Reasoning limitations:** despite chain-of-thought, LLMs fail on some systematic reasoning tasks (multi-digit arithmetic, long chains of deduction). Dedicated reasoning models (o1, DeepSeek-R1) address this with long chain-of-thought inference.

**Cost:** large model inference is expensive. Routing to smaller, cheaper models for simple tasks can reduce cost dramatically.
