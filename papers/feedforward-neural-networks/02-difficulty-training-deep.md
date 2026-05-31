# Understanding the Difficulty of Training Deep Feedforward Neural Networks (2010)

**Authors:** Xavier Glorot, Yoshua Bengio
**Area:** Deep Learning, Optimization
**Link:** [AISTATS](https://proceedings.mlr.press/v9/glorot10a.html)

## The root cause of training failure

Deep networks were known to be hard to train but the mechanism was not well understood. This paper traces the problem experimentally and analytically to the combination of poor weight initialization and saturating activation functions. It shows that with standard initialization, gradient magnitudes shrink exponentially as they propagate back through layers, leaving early layers with essentially no learning signal.

## Why gradients vanish

Backpropagation multiplies gradients by the weight matrix and the activation derivative at every layer. The sigmoid derivative peaks at 0.25, so with n layers of sigmoid activations and naive initialization, the gradient magnitude shrinks by at least a factor of 0.25 at each step backward through the network. After ten layers, the gradient reaching the earliest weights is negligible. The paper demonstrates this empirically by measuring activation variance and gradient variance layer by layer during training, showing the signal collapses in early layers almost immediately.

## Xavier initialization

The paper derives a condition on weight variance that keeps activation variance approximately constant as signals flow forward and backward through the network. For a layer with n_in inputs and n_out outputs:

```
Var(W) = 2 / (n_in + n_out)
```

This averages the constraint from the forward pass (which depends on n_in) and the backward pass (which depends on n_out). Weights are drawn from a uniform or normal distribution scaled to this variance. The goal is to prevent both explosion and vanishing at any layer depth.

## Sigmoid vs tanh

Sigmoid outputs lie in (0, 1) and are not zero-centered. Gradients flowing through a sigmoid layer always carry the same sign, forcing all weight updates in a layer to simultaneously be either all positive or all negative. This zig-zagging pattern slows learning. Tanh outputs lie in (−1, 1) and are zero-centered, allowing updates in both directions within a single step. The paper recommends tanh over sigmoid for deep networks and the saturation analysis directly motivated the adoption of ReLU, which has no saturation region for positive inputs.

## Results and impact

Xavier initialization became the default in PyTorch, TensorFlow, and Keras for layers with tanh or sigmoid activations. The analysis of how saturation compounds with depth directly motivated He initialization for ReLU layers, which uses Var(W) = 2/n_in to account for the half-rectified output distribution.
