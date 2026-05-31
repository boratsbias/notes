# Universal Adversarial Perturbations (2016)

**Authors:** Seyed-Mohsen Moosavi-Dezfooli, Alhussein Fawzi, Omar Fawzi, Pascal Frossard
**Area:** Deep Learning, Adversarial Robustness
**Link:** [arXiv](https://arxiv.org/abs/1610.08401)

## What the paper argues

Standard adversarial examples are input-specific: a perturbation crafted to fool the network on one image typically fails on another. This paper demonstrates the surprising existence of **universal perturbations**: a single image-agnostic vector δ that, when added to almost any image, causes a deep classifier to misclassify it. This suggests a systematic geometric weakness in deep network decision boundaries.

## Computing the universal perturbation

The algorithm iterates over the training set and builds up δ:

```
δ ← 0
for each image x_i:
    if f(x_i + δ) == true_label:          ← model still correct on this image
        Δv = smallest perturbation that pushes x_i + δ past a decision boundary
        δ ← δ + Δv
        δ ← project δ onto L_p ball of radius ξ   ← enforce small magnitude
```

After one pass through the dataset, δ fools ~80% of images. The perturbation looks like structured noise and is mostly imperceptible to humans.

## Cross-architecture transferability

Universal perturbations computed on one network transfer to other networks:

```
Perturbation computed on VGG-16  →  also fools GoogLeNet, ResNet, etc.
```

This transferability is stronger than for instance-specific adversarial examples, suggesting the vulnerability is in the geometry of the task rather than the specific network.

## Geometric explanation

Decision boundaries in high-dimensional input space share similar local orientations across different regions. A universal perturbation exploits this: it finds a direction in pixel space that crosses decision boundaries for most images, because the boundaries are nearly parallel in the relevant region.

## Results and impact

Revealed that adversarial vulnerability is a systematic property of trained classifiers, not just a per-sample artifact. Motivated adversarial training, certified defenses, and fundamental questions about what neural networks are actually learning. Remains one of the most striking demonstrations of how fragile deep classifiers are to structured input manipulations.
