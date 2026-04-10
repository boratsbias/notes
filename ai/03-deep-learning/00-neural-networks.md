# Neural Networks

## Core Idea

Neural networks are parameterized functions made of stacked linear transformations and nonlinear activations. They learn hierarchical representations directly from data.

## Single Neuron

A basic neuron computes:

$$z = \mathbf{w}^T \mathbf{x} + b$$

$$a = \phi(z)$$

where:

- $\mathbf{x}$ is the input
- $\mathbf{w}$ is the weight vector
- $b$ is the bias
- $\phi$ is the activation function

## Layered Structure

A feedforward network applies repeated transformations:

$$\mathbf{h}^{(1)} = \phi(W^{(1)}\mathbf{x} + \mathbf{b}^{(1)})$$

$$\mathbf{h}^{(2)} = \phi(W^{(2)}\mathbf{h}^{(1)} + \mathbf{b}^{(2)})$$

$$\hat{\mathbf{y}} = f_\theta(\mathbf{x})$$

Each layer maps features into a more useful representation for the task.

## Why Depth Helps

Deep networks can reuse intermediate features.

- early layers learn simple patterns
- middle layers compose them into more complex features
- later layers map high-level features to outputs

## Activation Functions

| Activation | Formula | Notes |
|------------|---------|-------|
| Sigmoid | $\sigma(x) = \frac{1}{1+e^{-x}}$ | Used for probabilities, can saturate |
| Tanh | $\tanh(x)$ | Zero-centered, still saturates |
| ReLU | $\max(0, x)$ | Simple and widely used |
| GELU | $x\Phi(x)$ | Common in transformers |

Without nonlinear activations, stacked linear layers collapse into a single linear map.

## Training Objective

Parameters are learned by minimizing a loss:

$$\theta^* = \arg\min_\theta \frac{1}{n}\sum_{i=1}^n \mathcal{L}(f_\theta(\mathbf{x}_i), y_i)$$

Typical losses:

- mean squared error for regression
- cross-entropy for classification

## Backpropagation

Backpropagation computes gradients of the loss with respect to all parameters using the chain rule.

For parameter $\theta$:

$$\theta \leftarrow \theta - \eta \frac{\partial \mathcal{L}}{\partial \theta}$$

This makes large networks trainable despite having millions or billions of parameters.

## Representation Learning

A major advantage of deep learning is that feature extraction is learned jointly with prediction.

- images: edges to textures to objects
- language: tokens to phrases to semantic relations
- audio: local frequencies to phonemes to words

## Regularization

Common methods:

- weight decay
- dropout
- early stopping
- data augmentation
- normalization layers

## Optimization Challenges

- vanishing gradients
- exploding gradients
- poor initialization
- overfitting
- unstable training dynamics

Modern architectures and optimizers are designed to reduce these issues.

## Common Architectures

| Architecture | Best Known For |
|--------------|----------------|
| MLP | Tabular data, simple baselines |
| CNN | Images and spatial data |
| RNN / LSTM | Sequential modeling |
| Transformer | Language, multimodal modeling |
| GNN | Graph-structured data |

## Why Deep Learning Became Dominant

Deep learning became effective at scale because of:

- large datasets
- GPU and TPU acceleration
- better initialization and optimization
- architectures suited to vision, language, and sequence data
- transfer learning from pretrained models
