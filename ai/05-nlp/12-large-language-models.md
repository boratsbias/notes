# Large Language Models

Large language models (LLMs) are Transformer-based language models trained on massive text corpora at scales where qualitatively new capabilities emerge: in-context learning, chain-of-thought reasoning, instruction following, and tool use.

## What Makes a Model "Large"?

Scale in three axes:

| Axis | Range (modern LLMs) |
|------|-------------------|
| Parameters $N$ | 7B to 1T+ |
| Training tokens $D$ | 1T to 15T tokens |
| Compute $C$ | $10^{23}$ to $10^{25}$ FLOPs |

The combination of scale and transformer architecture produces capabilities absent in smaller models: step-by-step reasoning, code generation, complex instruction following.

## Pretraining

Autoregressive language modeling on a curated mix of web text, books, code, and scientific articles.

**Data sources:** Common Crawl (filtered), books, Wikipedia, GitHub, arXiv, StackExchange.

**Data quality filtering:** deduplication (MinHash), quality filters (perplexity-based, heuristic), PII removal.

**Tokenizer:** BPE or SentencePiece; vocabulary 32k-128k.

**Architecture:** decoder-only Transformer with pre-RMSNorm, SwiGLU FFN, RoPE positional encoding, grouped query attention.

**Optimization:** AdamW with cosine learning rate schedule and warmup. Mixed precision (bf16). Gradient checkpointing. ZeRO sharding / tensor parallelism / pipeline parallelism across thousands of GPUs.

## Scaling Laws

**Kaplan et al. (2020):** loss follows a power law in $N$, $D$, and $C$:

$$L(N) \propto N^{-\alpha_N}, \quad L(D) \propto D^{-\alpha_D}, \quad L(C) \propto C^{-\alpha_C}$$

Optimal compute allocation: spend roughly equally on model size and data.

**Chinchilla (Hoffmann et al. 2022):** revised analysis; optimal ratio is $D \approx 20N$. A 70B model needs ~1.4T tokens for optimal training. Earlier large models (Gopher, GPT-3) were significantly undertrained.

## Instruction Tuning

Pretrained LLMs generate plausible text continuations, not helpful responses to questions. Instruction tuning aligns the model to follow instructions.

**Supervised Fine-Tuning (SFT):** train on a curated dataset of (instruction, ideal response) pairs covering diverse tasks: summarization, coding, math, Q&A, roleplay.

**RLHF (Reinforcement Learning from Human Feedback):**

1. Collect human preference comparisons between pairs of model outputs.
2. Train a reward model $r(x, y)$ to predict the preferred response.
3. Fine-tune the LLM with PPO to maximize $r(x, y)$ subject to a KL penalty.

$$\mathcal{L} = \mathbb{E}[r(x, y) - \beta \log \frac{\pi_\theta(y|x)}{\pi_\text{SFT}(y|x)}]$$

**DPO (Direct Preference Optimization):** analytically eliminates the reward model; directly optimizes the LLM on preference pairs:

$$\mathcal{L}_\text{DPO}(\pi_\theta) = -\mathbb{E}\left[\log \sigma\!\left(\beta \log \frac{\pi_\theta(y_w|x)}{\pi_\text{ref}(y_w|x)} - \beta \log \frac{\pi_\theta(y_l|x)}{\pi_\text{ref}(y_l|x)}\right)\right]$$

Simpler and more stable than RLHF in practice.

## In-Context Learning

The ability to perform a new task by conditioning on a few examples in the prompt, without any gradient updates.

**Zero-shot:** describe the task in natural language. No examples.

**Few-shot:** provide $k$ (input, output) examples before the test input. GPT-3 demonstrated strong few-shot capabilities at 175B parameters.

**Mechanism:** the Transformer forward pass "simulates" gradient descent over the in-context examples via attention. The model has implicitly learned to learn from demonstrations during pretraining.

## Chain-of-Thought Prompting

Wei et al. (2022). Including step-by-step reasoning in the examples (or prompting the model to "think step by step") dramatically improves performance on multi-step reasoning tasks.

**Standard prompting:** Q → A directly.

**Chain-of-thought:** Q → reasoning steps → A.

**Zero-shot CoT:** append "Let's think step by step." to the prompt. Effective even without demonstrations.

**Self-consistency:** sample multiple reasoning paths; take the majority vote answer. Reduces variance from random sampling.

## Tool Use and Agents

LLMs can use external tools by generating structured calls that are executed and whose results are returned to the model.

**Tool types:** web search, code interpreter, calculator, calendar, database queries, API calls.

**ReAct (Reason + Act):** interleave reasoning traces with tool call actions. The model reasons about what tool to use, generates a call, observes the result, and continues reasoning.

**Function calling (OpenAI API):** the model outputs a JSON object specifying the function name and arguments. The runtime executes the function and returns the result.

**Multi-step agents:** complex tasks are decomposed into sequences of reasoning and tool use steps. Examples: code debugging agents, research assistants, data analysis agents.

## Efficient Inference

LLM inference is memory-bound (loading weights and KV cache).

**KV cache:** store key and value tensors for all past tokens to avoid recomputation. Memory: $O(n \cdot d \cdot L)$ for $n$ tokens, $d$ hidden size, $L$ layers.

**Quantization:** reduce precision from FP16 to INT8 or INT4. GPTQ (post-training), QLoRA (fine-tuning). 4-bit quantization reduces memory by $4\times$ with minor quality loss.

**Speculative decoding:** a small draft model generates $k$ candidate tokens; the large model verifies them in a single forward pass. Speeds up generation by 2-3$\times$ with no quality loss.

**Continuous batching (vLLM):** dynamically batch requests at the token level rather than the sequence level. Dramatically improves GPU utilization for serving.

## Parameter-Efficient Fine-Tuning (PEFT)

Full fine-tuning of a 70B model requires ~140GB GPU memory. PEFT methods update only a small fraction of parameters.

**LoRA (Low-Rank Adaptation):** add low-rank matrices $A \in \mathbb{R}^{d \times r}$, $B \in \mathbb{R}^{r \times d}$ to weight matrices; only $A$ and $B$ are trained.

$$W' = W + \Delta W = W + BA, \quad r \ll d$$

Merges into the original weights at inference: no added latency.

**QLoRA:** quantize the base model to 4-bit; train LoRA adapters in 16-bit. Enables fine-tuning a 70B model on a single 48GB GPU.

**Prompt tuning / prefix tuning:** prepend a small number of learned tokens to the input. Only the prefix parameters are trained.

## Prominent LLMs (as of early 2025)

| Model | Org | Params | Context | Open weights |
|-------|-----|--------|---------|-------------|
| GPT-4o | OpenAI | Unknown | 128k | No |
| Claude 3.5 Sonnet | Anthropic | Unknown | 200k | No |
| Gemini 1.5 Pro | Google | Unknown | 1M | No |
| LLaMA-3.1 405B | Meta | 405B | 128k | Yes |
| Mistral Large 2 | Mistral | 123B | 128k | No |
| Qwen2.5 72B | Alibaba | 72B | 128k | Yes |
| DeepSeek-V3 | DeepSeek | 671B (MoE) | 128k | Yes |

## Alignment and Safety

**Hallucination:** LLMs generate plausible-sounding but false statements. Especially problematic for low-frequency facts. Mitigated by retrieval augmentation, citation, and fine-tuning on factual datasets.

**Jailbreaking:** adversarial prompts that bypass safety guardrails. Active area of red-teaming research.

**Constitutional AI (Anthropic):** uses a set of principles to critique and revise model outputs; reduces reliance on human labelers for safety feedback.

**Bias:** LLMs reflect biases in pretraining data (gender, racial, cultural). Evaluated with bias benchmarks (WinoBias, BBQ) and mitigated with balanced training data and RLHF.
