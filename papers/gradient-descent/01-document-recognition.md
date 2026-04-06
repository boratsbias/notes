# Gradient-Based Learning Applied to Document Recognition (1998)

**Authors:** Yann LeCun, Leon Bottou, Yoshua Bengio, Patrick Haffner  
**Area:** Computer Vision, Deep Learning, OCR  
**Link:** [IEEE Paper](https://ieeexplore.ieee.org/document/726791)

## Overview

This paper introduced **Convolutional Neural Networks (CNNs)** and showed that neural networks trained with **gradient-based learning** can outperform traditional handcrafted pattern recognition systems.

The central idea is to **learn features directly from raw images** instead of manually designing feature extractors.

## Problem

Traditional pattern recognition systems were built with two separate components:

1. Feature extractor (handcrafted)
2. Trainable classifier

![Figure 1](../../images/papers/gradient-descent/fig-1-1.png)

*Source: Figure adapted from LeCun et al., "Gradient-Based Learning Applied to Document Recognition", Proceedings of the IEEE, 1998.*

The feature extractor converted images into engineered representations before classification.

Limitations of this approach:

- required expert feature engineering
- difficult to generalize across tasks
- performance depended heavily on manually designed features

The paper proposes replacing this pipeline with **end-to-end learning using neural networks**.

## Core Idea

Neural networks trained using **gradient descent and backpropagation** can learn both:

- feature representations
- classification boundaries

directly from raw pixel data.

This allows systems to automatically discover useful patterns without manual feature design.

## Convolutional Neural Networks

Fully connected neural networks are inefficient for image data because:

- images contain large numbers of pixels
- spatial relationships between pixels are ignored
- translation variations are difficult to learn

CNNs solve these issues using three architectural principles.

### Local Receptive Fields

Neurons connect only to a small region of the input.

This allows the network to detect local features such as:

- edges
- corners
- strokes

### Weight Sharing

The same filter is applied across the entire image.

Benefits:

- greatly reduces the number of parameters
- enables detection of patterns anywhere in the image

### Subsampling (Pooling)

Pooling layers reduce spatial resolution.

Advantages:

- translation invariance
- noise robustness
- lower computation

## LeNet-5 Architecture

![Figure 2](../../images/papers/gradient-descent/fig-1-2.png)

*Source: Figure adapted from LeCun et al., "Gradient-Based Learning Applied to Document Recognition", Proceedings of the IEEE, 1998.*

The paper presents **LeNet-5**, one of the earliest successful CNN architectures for handwritten digit recognition.

Input size: **32 × 32 grayscale image**

Architecture:

Input  
→ Convolution layer (C1)  
→ Subsampling layer (S2)  
→ Convolution layer (C3)  
→ Subsampling layer (S4)  
→ Convolution layer (C5)  
→ Fully connected layer (F6)  
→ Output layer

The network learns hierarchical representations:

edges → strokes → shapes → digits

## Graph Transformer Networks (GTN)

![Figure 3](../../images/papers/gradient-descent/fig-1-3.png)

*Source: Figure adapted from LeCun et al., "Gradient-Based Learning Applied to Document Recognition", Proceedings of the IEEE, 1998.*

Real document recognition systems consist of multiple modules such as:

- segmentation
- character recognition
- language models
- grammar constraints

Traditionally these modules were trained independently.

Graph Transformer Networks allow **global training of the entire system using gradient descent**, enabling optimization of the full recognition pipeline.

## Experiments

CNNs were evaluated on handwritten digit recognition tasks using the **NIST handwritten digit dataset**.

The models achieved **state-of-the-art performance**, outperforming traditional approaches such as:

- k-nearest neighbors
- support vector machines
- manually engineered feature systems

## Real-World Deployment and Impact 

The methods in this paper were deployed in a bank check recognition system that processed millions of checks daily, proving neural networks could work at real-world scale. The work introduced key ideas such as Convolutional Neural Networks, weight sharing, pooling, and end-to-end learning, which later became the foundation for modern computer vision, OCR systems, and deep learning vision models.