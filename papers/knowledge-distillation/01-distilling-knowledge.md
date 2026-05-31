# Distilling the Knowledge in a Neural Network (2015)

**Authors:** Geoffrey Hinton, Oriol Vinyals, Jeff Dean
**Area:** Deep Learning, Model Compression
**Link:** [arXiv](https://arxiv.org/abs/1503.02531)

## The problem with training small models directly

Large ensemble models achieve the best accuracy but are too expensive to deploy. The obvious solution is to train a smaller model directly on the same data. The problem is that the training labels are one-hot vectors: they assign probability 1 to the correct class and 0 to everything else. A one-hot label tells the student model nothing about which wrong answers are similar to the right answer. A well-trained large model's output distribution over all classes contains that structure: it assigns a small but meaningful probability to "dog" when the true answer is "cat," and a much smaller probability to "car." This information about inter-class similarity is what Hinton calls dark knowledge, and it is discarded entirely when training from hard labels alone.

## Temperature scaling and soft targets

The mechanism for transferring dark knowledge is temperature scaling applied before the softmax:

$$ p_i = \frac{\exp(z_i / T)}{\sum_j \exp(z_j / T)} $$

At T = 1 this is the standard softmax. At T > 1 the distribution becomes softer, amplifying the small probabilities assigned to wrong classes and making the similarity structure more visible to the student. The student is trained at high temperature to match the teacher's high-temperature output distribution. At inference time, T returns to 1. The combined training loss mixes a soft target term (KL divergence between student and teacher at high T) with a hard label term (cross-entropy against ground truth). The soft target loss is scaled by T² to compensate for the reduction in gradient magnitude caused by the softened distribution.

## Specialist models

For large-scale classification with many classes, Hinton et al. also introduce specialist models: small networks trained specifically on subsets of classes that the general ensemble confuses most. At inference time, specialists handle the examples that fall in their confusion cluster, while the general model handles the rest. This allows a collection of small models to collectively match ensemble performance.

## Results and impact

Distillation consistently produces small models that substantially outperform the same architectures trained from scratch on hard labels. The technique became the standard approach to model compression and is used in DistilBERT, TinyBERT, and most production model compression pipelines deployed today.
