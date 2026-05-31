---
title: "How Transferable Are Features in Deep Neural Networks?"
year: 2014
authors: Jason Yosinski, Jeff Clune, Yoshua Bengio, Hod Lipson
area: Deep Learning, Transfer Learning
link: https://arxiv.org/abs/1411.1792
---

## The unmeasured assumption

By 2014, initializing from ImageNet-pretrained weights and fine-tuning on a target task was standard practice in computer vision. The assumption was that early CNN layers learn broadly useful features that transfer well across tasks, while later layers become task-specific. This paper provides the first systematic empirical measurement of exactly how transferable each layer is, how quickly the transition from general to specific happens, and how task similarity modulates both.

## The general-to-specific gradient

Early convolutional layers consistently learn Gabor filters, color blobs, and edge detectors that are nearly identical regardless of what network was trained on what data. These features match what neuroscientists observe in the early visual cortex and are useful for virtually any image recognition task. Middle layers contain features that are less interpretable and begin to specialize. Later layers hold features tightly coupled to the source task's specific classes and are less useful when the target task differs substantially. The paper measures this transition by training networks on two disjoint halves of ImageNet classes, providing a controlled similar-task setup, and on unrelated tasks, quantifying degradation at each layer boundary.

## Two sources of transfer failure

The paper carefully disentangles two distinct reasons why transfer degrades in later layers. The first is specificity: later layer features encode class-specific patterns that are not useful for a different target distribution. The second is co-adaptation disruption. Neurons in the same layer develop co-adapted relationships during training, jointly solving subproblems in ways that depend on their neighbors. When some layers are frozen and the remainder are initialized randomly and trained from scratch, this co-adaptation is destroyed. The frozen layers produce representations that the new layers were never jointly trained with, degrading performance even for closely related tasks.

## The fine-tuning prescription

The key experimental finding is that fine-tuning transferred layers, rather than freezing them and training the rest from scratch, restores co-adaptation and yields better performance even on closely related tasks. Freezing should be limited to the earliest layers where features are most general and fine-tuning adds the least value. The more the target task differs from the source, the fewer layers should be frozen.

## Results and impact

The paper directly justified the transfer learning practice that defines modern computer vision and NLP. Its quantification of the general-to-specific gradient remains the standard reference for understanding where in a network transfer is beneficial, how many layers to freeze, and why fine-tuning outperforms feature extraction for most target tasks.
