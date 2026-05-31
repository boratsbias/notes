# Understanding the Difficulty of Training Deep Feedforward Neural Networks (2010)

**Authors:** Xavier Glorot, Yoshua Bengio
**Area:** Deep Learning, Optimization
**Link:** [AISTATS](https://proceedings.mlr.press/v9/glorot10a.html)

## What the paper argues

Deep networks were known to be hard to train but the reason was not well understood. This paper traces the problem to poor weight initialization combined with saturating activations. It shows empirically that gradients vanish in early layers with standard initialization and derives a principled fix.

## Why gradients vanish

During backpropagation, gradients are multiplied by weight matrices and activation derivatives at every layer. With sigmoid activations, the derivative is at most 0.25. With n layers and weights initialized naively:

```
gradient magnitude ∝ (W · σ'(z))ⁿ  →  shrinks exponentially with depth
```

By the time the gradient reaches the first layer it is essentially zero. That layer learns nothing.

## Xavier initialization

The paper derives a condition on weight variance that keeps gradient magnitude approximately constant across layers. For a layer with n_in inputs and n_out outputs:

```
Var(W) = 2 / (n_in + n_out)
```

This is now called Xavier (or Glorot) initialization. It is the default in most frameworks today for layers with tanh or sigmoid activations. For ReLU layers, He initialization uses `2 / n_in` instead.

## Sigmoid vs tanh

Sigmoid outputs are in (0, 1), so they are not zero-centered. This means gradients flowing through a sigmoid layer are always the same sign, causing zig-zagging updates. Tanh outputs are in (-1, 1) and are zero-centered, which avoids this. The paper recommends tanh over sigmoid for deep networks and was a step toward the adoption of ReLU, which avoids saturation entirely.

## Results and impact

Xavier initialization became standard across deep learning and is built into PyTorch, TensorFlow, and Keras as the default. The analysis of activation saturation directly motivated the design of ReLU and its variants.
