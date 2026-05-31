# TinyBERT: Distilling BERT for Natural Language Understanding (2019)

**Authors:** Xiaoqi Jiao et al.
**Area:** Natural Language Processing, Model Compression
**Link:** [arXiv](https://arxiv.org/abs/1909.10351)

## What the paper argues

Standard output-only distillation for BERT ignores the rich information in attention maps and hidden states at every layer. TinyBERT argues that distilling at each transformer layer, matching attention patterns and hidden representations, produces a much smaller model that retains far more of BERT's capability than distilling only from the final output.

## Layer-wise distillation

A mapping M maps each student layer m to a teacher layer M(m). Three loss terms are applied at each mapped layer:

```
Attention loss:    MSE(A_student, A_teacher)            ← match attention weight matrices
Hidden loss:       MSE(H_student W_h, H_teacher)        ← match hidden states (with projection)
Embedding loss:    MSE(E_student W_e, E_teacher)        ← match token embeddings
```

W_h and W_e are learned projection matrices that handle the size mismatch between student and teacher dimensions. A standard output cross-entropy loss is also included.

## Two-stage training

```
Stage 1 (General distillation):
  - Distill on large unlabeled corpus (same as BERT pre-training data)
  - Teaches general language representations

Stage 2 (Task-specific distillation):
  - Fine-tune teacher on task data
  - Distill the fine-tuned teacher into student on the same task data
  - Also applies data augmentation: replace words with BERT's top-k predictions
```

## Results and impact

TinyBERT (4 layers, 14.5M parameters) achieves 96.8% of BERT-base's GLUE performance at 7.5x faster inference and 9x smaller model size. It demonstrated that intermediate-layer distillation is substantially more effective than output-only distillation for transformers.
