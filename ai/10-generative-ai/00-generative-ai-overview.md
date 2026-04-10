# Generative AI Overview

## Core Idea

Generative AI focuses on systems that can produce new content such as text, code, images, audio, and video from learned patterns in large datasets.

## Foundation Models

A foundation model is a large pretrained model that can be adapted to many downstream tasks.

Examples:

- large language models
- text-to-image diffusion models
- multimodal models that combine text, images, audio, or video

## Why Generative AI Scaled Quickly

Several ideas came together:

- transformer architectures
- self supervised pretraining
- large compute budgets
- large web-scale datasets
- transfer learning through prompting and fine-tuning

## Large Language Models

Large language models usually learn by predicting the next token:

$$P(x_1, x_2, \ldots, x_T) = \prod_{t=1}^T P(x_t \mid x_{<t})$$

This simple objective produces strong general-purpose representations for many language tasks.

## Common Capabilities

| Capability | Example |
|------------|---------|
| Generation | Write text, code, or captions |
| Transformation | Summarize, translate, rewrite |
| Retrieval-assisted reasoning | Answer using external documents |
| Tool use | Call APIs, search, run code |
| Multimodal understanding | Interpret text and images together |

## Prompting

Prompts define the task, context, constraints, and examples for the model.

Prompt quality affects:

- relevance
- format adherence
- reasoning behavior
- factual grounding

## Retrieval-Augmented Generation

RAG combines retrieval with generation:

1. retrieve relevant documents
2. place them into the model context
3. generate an answer grounded in those documents

This helps reduce hallucination and keeps outputs tied to external knowledge.

## Alignment and Post-Training

Modern generative systems often use:

- supervised fine-tuning
- preference optimization
- reinforcement learning from human feedback
- safety filtering and policy constraints

## Key Risks

- hallucination
- prompt injection
- training data memorization
- bias and harmful outputs
- insecure tool use
- evaluation mismatch between demos and real workloads

## Evaluation

Generative AI evaluation often combines:

- automatic metrics
- benchmark tasks
- human preference judgments
- task success in real workflows

## Why Generative AI Matters

Generative AI changes how software systems are built because the model can act as a flexible interface for reasoning, language, synthesis, and interaction rather than only a narrow predictor.
