# ImageNet Classification with Deep Convolutional Neural Networks (2012)

**Authors:** Alex Krizhevsky, Ilya Sutskever, Geoffrey Hinton
**Area:** Computer Vision, Deep Learning
**Link:** [NeurIPS](https://proceedings.neurips.cc/paper_files/paper/2012/hash/c399862d3b9d6b76c8436e924a68c45b-Abstract.html)

## What the paper argues

The best 2011 image classifiers used hand-engineered features (SIFT, HOG). AlexNet argues that a deep convolutional network trained on a large labeled dataset with GPUs can learn better features automatically, and that several practical techniques make this tractable at scale.

## Architecture

```
Input (224×224×3)
  ↓
Conv1 (96 filters, 11×11, stride 4)  →  ReLU  →  MaxPool
  ↓
Conv2 (256 filters, 5×5)             →  ReLU  →  MaxPool
  ↓
Conv3 (384 filters, 3×3)             →  ReLU
  ↓
Conv4 (384 filters, 3×3)             →  ReLU
  ↓
Conv5 (256 filters, 3×3)             →  ReLU  →  MaxPool
  ↓
FC6 (4096)  →  Dropout(0.5)
FC7 (4096)  →  Dropout(0.5)
FC8 (1000)  →  Softmax
```

60 million parameters. Split across two GPUs during training.

## Key techniques

**ReLU:** replaces tanh with max(0, x). Does not saturate for positive inputs. Trains several times faster in practice. First major demonstration that ReLU works for large deep networks.

**Dropout (p=0.5):** randomly zeros half the FC layer neurons per forward pass. Prevents co-adaptation. Equivalent to averaging an ensemble of 2^n networks. Dramatically reduces overfitting.

**Data augmentation:** random 224×224 crops from 256×256 images, horizontal flips, PCA-based color jitter. Multiplies effective dataset size.

## Results and impact

15.3% top-5 error on ImageNet 2012, vs 26.2% for second place. The gap was large enough to end the hand-engineered feature era. ReLU and dropout became standard in virtually all subsequent deep learning architectures.
