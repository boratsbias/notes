# Self Supervised Learning

## Core Idea

Self supervised learning creates supervision from the data itself.

Instead of relying on human labels, the model is trained to solve a pretext task whose targets are derived automatically from the input.

## Why It Matters

Large datasets often have very few manual labels, but they contain rich structure. Self supervised learning uses that structure to learn useful representations.

## Common Objectives

### Autoregressive Prediction

Predict future tokens or elements from previous ones:

$$P(x_1, x_2, \ldots, x_T) = \prod_{t=1}^T P(x_t \mid x_{<t})$$

This is the basis of many language models.

### Masked Prediction

Hide part of the input and predict the missing content.

Examples:

- masked language modeling
- masked image patches

### Contrastive Learning

Learn representations that bring similar views together and push different examples apart.

If $\mathbf{z}$ and $\mathbf{z}^+$ are positive pairs, the model tries to score them above negatives.

### Reconstruction

Encode the input into a representation and reconstruct it.

This appears in autoencoders and related models.

## Representation Learning

After pretraining, the model can be:

- fine-tuned on a labeled task
- used as a frozen feature extractor
- adapted with prompting or lightweight updates

## Benefits

- reduces dependence on labels
- scales well with large datasets
- often improves transfer learning

## Challenges

- pretext task may not align with the downstream task
- representation quality is harder to measure directly
- training can require large compute and data

## Examples

- BERT style masked language modeling
- contrastive image learning
- next-token prediction in large language models
- masked autoencoders for vision
