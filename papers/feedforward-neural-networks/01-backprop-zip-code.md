# Backpropagation Applied to Handwritten Zip Code Recognition (1989)

**Authors:** Yann LeCun, B. Boser, J. S. Denker, D. Henderson, R. E. Howard, W. Hubbard, L. D. Jackel
**Area:** Computer Vision, Deep Learning
**Link:** [Neural Computation](https://direct.mit.edu/neco/article/1/4/541/5515)

## What the paper argues

Recognizing handwritten digits requires handling variability in size, position, and style. Prior systems used hand-crafted feature extractors followed by a classifier. This paper argues that a constrained neural network trained end-to-end with backpropagation can learn features directly from pixels, removing the need for manual feature design.

## Constrained architecture

The network applies three ideas together to reduce parameters and build in position invariance:

**Local receptive fields:** each unit sees only a small patch of the input, detecting local strokes and edges.

**Weight sharing:** the same filter is applied at every position, so the same detector works regardless of where a digit appears.

**Subsampling:** after each feature map, spatial resolution is reduced, giving robustness to small translations.

```
Input (16x16) -> conv (12 feature maps) -> subsample -> conv (24 maps) -> subsample -> FC -> 10 outputs
```

This is a direct predecessor to LeNet-5. The fully connected baseline on the same data had far worse generalization due to overfitting.

## End-to-end training

All layers are trained jointly with backpropagation through the entire network. This was non-trivial to trust in 1989. The paper demonstrated it converged reliably and that gradient signal propagated meaningfully through the constrained architecture.

## Results and impact

1% error on a test set of handwritten zip code digits. It was one of the first real-world deployments of a deep trained network and directly led to LeNet-5 and modern CNNs.
