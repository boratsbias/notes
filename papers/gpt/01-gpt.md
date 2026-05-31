# Improving Language Understanding by Generative Pre-Training (2018)

**Authors:** Alec Radford, Karthik Narasimhan, Tim Salimans, Ilya Sutskever
**Area:** Natural Language Processing, Language Modeling
**Link:** [OpenAI](https://openai.com/research/language-unsupervised)

## What the paper argues

Labeled data for NLP is scarce. Raw text is abundant. GPT argues that a transformer language model pre-trained on large text corpora learns general language representations that can be fine-tuned on many downstream tasks with minimal labeled data and no architectural changes beyond a task-specific output head.

## Architecture

GPT uses a decoder-only transformer: 12 layers, 768-dimensional embeddings, 12 attention heads. It is trained on BooksCorpus (7,000 unpublished books) with a standard left-to-right language modeling objective:

```
L = Σ_t  log P(w_t | w_{t-k}, ..., w_{t-1})
```

No masking of future tokens via bidirectional attention. Each token attends only to previous tokens (causal masking).

## Task input formatting

Rather than adding task-specific layers, GPT reformats each task's inputs as a token sequence with delimiter tokens, then adds a single linear classifier on top:

```
Classification:  [Start]  sentence  [Extract]         →  linear → label
Entailment:      [Start]  premise  [Delim]  hypo  [Extract]  →  linear → label
QA / MCQ:        [Start]  context  [Delim]  choice_i  [Extract]  per choice
```

The pre-trained weights are updated (not frozen) during fine-tuning, which is key to the approach working.

## Results and impact

State of the art on 9 of 12 NLP benchmarks. Established the pre-train then fine-tune paradigm and the decoder-only transformer architecture that GPT-2, GPT-3, and all subsequent GPT models use.
