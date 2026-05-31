---
title: "Deep Residual Learning for Image Recognition (ResNet)"
authors: "Kaiming He, Xiangyu Zhang, Shaoqing Ren, Jian Sun"
year: 2015
area: Computer Vision, Deep Learning
link: https://arxiv.org/abs/1512.03385
---

## The degradation problem

Stacking more layers should not hurt a network. A 56-layer model should at minimum match a 20-layer model: the extra layers could simply learn identity mappings and leave the shallow solution intact. In practice, the 56-layer model has higher training error than the 20-layer model, and this is not overfitting. It is a pure optimization failure. The network cannot learn the identity function through a sequence of nonlinear transformations, even though the function is trivial to represent. This degradation problem was the central obstacle to training very deep networks before ResNet.

## Residual connections

ResNet's solution is to reformulate what a block is asked to learn. If H(x) is the desired output, define F(x) = H(x) - x and let the block learn F(x) instead. The final output is then F(x) + x, where x is added via a skip connection that bypasses the block entirely. If identity is the optimal mapping, the block just needs to push F(x) toward zero, which is far easier to optimize than learning identity through stacked nonlinearities. This reformulation is implemented as a single element-wise addition requiring no extra parameters when input and output dimensions match.

## Why this helps optimization

Skip connections give gradients a direct path backward through the network, bypassing weight matrices and preventing the vanishing gradient problem that cripples very deep networks. They also guarantee that adding layers cannot hurt: a block can always fall back to identity. For networks with 50 or more layers, ResNet uses bottleneck blocks where a 1x1 convolution first reduces channel count, a 3x3 convolution processes features, and a second 1x1 convolution restores channels. This is cheaper than two full 3x3 convolutions and makes 101-layer and 152-layer variants tractable. ResNet-152 at 11.3B FLOPs outperforms VGG-16 at 15.3B FLOPs, showing that depth with residual connections is more parameter-efficient than width alone.

## Results and impact

ResNet-152 achieved 3.57% top-5 error on ImageNet 2015, surpassing human-level performance on this benchmark. Residual connections subsequently appeared in every major architecture across deep learning. Transformers, language models, diffusion models, and vision backbones all rely on skip connections in the same form ResNet introduced. The insight that networks should learn residuals rather than direct functions is among the most consequential ideas in the field.
