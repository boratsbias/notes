---
title: "ImageNet Classification with Deep Convolutional Neural Networks"
authors: "Alex Krizhevsky, Ilya Sutskever, Geoffrey Hinton"
year: 2012
area: Computer Vision, Deep Learning
link: https://proceedings.neurips.cc/paper_files/paper/2012/hash/c399862d3b9d6b76c8436e924a68c45b-Abstract.html
---

## The problem with hand-engineered features

Before AlexNet, computer vision pipelines depended on hand-crafted feature extractors such as SIFT and HOG. These descriptors captured gradient orientations and texture statistics that researchers had spent years designing to be invariant to scale, rotation, and illumination. They worked, but they had hit a ceiling. The features encoded what engineers understood about images, not what the data itself could reveal. AlexNet's central argument is that these engineered representations are unnecessary: given enough labeled data, a deep convolutional network can learn better features directly from pixels.

## Architecture and training

AlexNet stacks five convolutional layers followed by three fully connected layers, totaling roughly 60 million parameters. Because no single GPU in 2012 could hold this many parameters, the network was split across two GPUs with cross-GPU connections introduced at specific layers. Training on 1.2 million ImageNet images took about a week. Local response normalization was applied after certain ReLU activations, though this technique was later shown to be unnecessary and has since been dropped from practice.

## ReLU, dropout, and data augmentation

Three technical choices made the scale feasible. First, ReLU replaces the tanh activation with max(0, x). Unlike tanh, ReLU does not saturate for positive inputs, so gradients remain large and training converges several times faster. This was the first large-scale demonstration that ReLU works for deep networks. Second, dropout randomly zeros 50% of FC-layer neurons on each forward pass. This prevents neurons from co-adapting and is equivalent at test time to averaging over an exponentially large ensemble of networks. Without dropout, the 60M-parameter model severely overfits. Third, data augmentation extracts random 224x224 crops from 256x256 images, applies horizontal flips, and adds PCA-based color jitter, effectively multiplying dataset size and further reducing overfitting.

## Results and impact

AlexNet achieved 15.3% top-5 error on ImageNet 2012, compared to 26.2% for the second-place entry. A gap this large, on a benchmark this competitive, was decisive. It ended the hand-engineered feature era almost overnight. ReLU and dropout became standard components of every subsequent deep network. The AlexNet architecture is the direct ancestor of VGG, GoogLeNet, ResNet, and every major vision model that followed, and it triggered the broader deep learning revolution across computer vision and beyond.
