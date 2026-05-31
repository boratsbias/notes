---
title: "Improving Language Understanding by Generative Pre-Training"
authors: "Alec Radford, Karthik Narasimhan, Tim Salimans, Ilya Sutskever"
year: 2018
area: "Natural Language Processing, Language Modeling"
link: "https://openai.com/research/language-unsupervised"
---

## Pre-training on language modeling

GPT introduced the pre-train then fine-tune paradigm that became the dominant approach in NLP. The model is trained on BooksCorpus, a dataset of 7,000 unpublished books totaling around 800M words. BooksCorpus was chosen deliberately: books contain long, coherent passages with rich sentence structure and complex dependencies that span many sentences, which forces the model to learn deeper language representations than short web snippets would.

Pre-training uses a standard left-to-right language modeling objective: predict the next token given all previous tokens. This is unsupervised and requires no human annotation, making it trivially scalable.

## Architecture and fine-tuning

GPT uses a decoder-only transformer with 12 layers, 768-dimensional embeddings, and 12 attention heads, totaling 117M parameters. The decoder-only design is a direct consequence of the left-to-right language modeling objective: causal masking prevents any token from attending to future positions.

Fine-tuning adapts the pre-trained model to each downstream task. Rather than designing task-specific architectures, GPT reformats every task as a token sequence with delimiter tokens. For classification, a linear classifier is placed on top of the final token's representation. Crucially, the pre-trained weights are updated during fine-tuning rather than frozen. Freezing would discard the rich contextual representations the model learned. Updating them allows the pre-trained knowledge to be reshaped toward the task while retaining general language understanding.

## GPT versus BERT

GPT's unidirectional design is its key structural difference from BERT, which followed a year later. GPT attends only left-to-right, making it natural for generation. BERT uses a bidirectional encoder that attends to both directions, making it stronger for classification and extraction tasks. Both follow GPT's pre-train then fine-tune template, validating the paradigm.

## Results and impact

GPT achieved state of the art on 9 of 12 NLP benchmarks at the time of publication, including natural language inference, question answering, and semantic similarity tasks. The more lasting contribution was the paradigm itself. Every major subsequent model, including BERT, RoBERTa, GPT-2, GPT-3, and T5, adopted the same pre-train on unlabeled text, then fine-tune on labeled data structure. GPT demonstrated that a single pre-trained model could transfer across radically different tasks simply by reformatting the input, eliminating years of task-specific architecture engineering.
