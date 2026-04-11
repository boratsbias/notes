# Gradient-Based Learning Applied to Document Recognition (1998)

**Authors:** Yann LeCun, Leon Bottou, Yoshua Bengio, Patrick Haffner
**Area:** Computer Vision, Deep Learning, OCR
**Link:** [IEEE Paper](https://ieeexplore.ieee.org/document/726791)

## What the paper argues

Traditional pattern recognition separated a handcrafted feature extractor from a trainable classifier. This required expert knowledge, was hard to generalize, and bottlenecked performance on the quality of the manual features. The paper argues for replacing the entire pipeline with end-to-end learning: neural networks trained with gradient descent and backpropagation can learn both feature representations and decision boundaries directly from raw pixels.

## Why fully connected networks fail for images

Fully connected layers ignore spatial structure, scale poorly with image size, and cannot generalize across translations. CNNs fix this with three principles applied together:

**Local receptive fields:** each neuron connects to a small spatial region, allowing detection of local features (edges, corners, strokes).

**Weight sharing:** the same filter is convolved across the entire image, which dramatically reduces parameters and allows pattern detection regardless of position.

**Subsampling (pooling):** reduces spatial resolution after each convolution, giving translation invariance, robustness to noise, and lower computation cost.

## LeNet-5

The paper's concrete architecture for handwritten digit recognition on 32x32 grayscale input:

```
Input -> C1 (conv) -> S2 (pool) -> C3 (conv) -> S4 (pool) -> C5 (conv) -> F6 (FC) -> Output
```

Each stage builds a more abstract representation: edges at C1, strokes at C3, digit parts at C5. This hierarchical composition of features from raw pixels is the central architectural idea.

## Graph Transformer Networks (GTN)

Real document systems are pipelines of modules: segmentor, character recognizer, language model, grammar. Trained independently, each module is optimized locally and errors compound. GTNs allow the entire pipeline to be trained jointly end-to-end with gradient descent, propagating the loss signal back through all modules simultaneously.

## Results and impact

LeNet-5 achieved state-of-the-art on the NIST handwritten digit benchmark, outperforming k-NN, SVMs, and hand-engineered systems. The system was deployed in production for reading handwritten bank checks at scale.

The paper established the ideas that became the foundation of modern computer vision: convolutional layers, weight sharing, pooling, hierarchical features, and end-to-end gradient learning. These same principles power every major vision model today.
