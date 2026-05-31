# BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding (2018)

**Authors:** Jacob Devlin, Ming-Wei Chang, Kenton Lee, Kristina Toutanova
**Area:** Natural Language Processing, Pre-training
**Link:** [arXiv](https://arxiv.org/abs/1810.04805)

## What the paper argues

GPT reads left-to-right. ELMo concatenates two independent one-directional LSTMs. Both miss the key insight: understanding a word requires seeing both sides of its context at every layer simultaneously. BERT pre-trains a transformer encoder that attends to all surrounding tokens jointly, producing better representations for understanding tasks.

## Masked language modeling (MLM)

You cannot use standard left-to-right prediction with a bidirectional model because the model can trivially peek at the target. BERT instead randomly masks 15% of input tokens and trains the model to predict them:

```
Input:   "The cat [MASK] on the mat"
Target:   predict "sat" using all surrounding tokens
```

Of the 15% selected tokens: 80% are replaced with [MASK], 10% with a random word, 10% left unchanged. The mixed strategy prevents the model from assuming every [MASK] token is truly masked at fine-tuning time.

## Next sentence prediction (NSP)

BERT also trains a binary classifier on whether two segments appear consecutively in the original document. This teaches inter-sentence relationships needed for QA and NLI tasks.

## Fine-tuning

After pre-training, a single linear layer is added on top of the [CLS] token (for classification) or individual token representations (for NER, QA). The entire model is then fine-tuned end-to-end on the downstream task:

```
Pre-train on MLM + NSP  →  add task head  →  fine-tune on labeled data
```

## Results and impact

BERT achieved state of the art on 11 NLP benchmarks simultaneously. It established bidirectional pre-training as the dominant paradigm and is the direct ancestor of RoBERTa, ALBERT, DistilBERT, and the encoder half of T5.
