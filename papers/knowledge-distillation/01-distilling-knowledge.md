# Distilling the Knowledge in a Neural Network (2015)

**Authors:** Geoffrey Hinton, Oriol Vinyals, Jeff Dean
**Area:** Deep Learning, Model Compression
**Link:** [arXiv](https://arxiv.org/abs/1503.02531)

## What the paper argues

Training a small model directly on one-hot labels discards information the large model has learned. A well-trained classifier's output distribution over wrong classes encodes structure: "cat" is more similar to "dog" than to "car". This is **dark knowledge**. The paper argues that training a small student model to match the soft probability outputs of a large teacher model transfers this structure and produces a better small model.

## Soft targets and temperature

Hard label:   [0, 0, 1, 0, 0, ...]   (no information about wrong classes)

Soft target:  [0.01, 0.10, 0.85, 0.03, 0.01, ...]   (encodes similarity structure)

To amplify the soft signal from low-probability classes, a **temperature T** is applied before the softmax:

```
p_i = exp(z_i / T) / Σ_j exp(z_j / T)
```

At T=1: standard softmax. At T>1: distribution is softer, rare class probabilities are more visible. Student is trained at temperature T to match the teacher's distribution also computed at T. After training, T is set back to 1 for inference.

## The training objective

```
L = α · L_CE(student_hard, true_labels)
  + (1-α) · T² · L_CE(student_soft, teacher_soft)
```

The T² factor compensates for the gradient magnitude being T² times smaller at high temperature. Typical α = 0.1 (emphasize soft targets).

## Results and impact

Distillation produced small models retaining most ensemble performance at a fraction of inference cost. The technique is used in training DistilBERT, TinyBERT, and most production model compression pipelines. The idea of soft targets as richer training signal than one-hot labels influenced training methodology broadly.
