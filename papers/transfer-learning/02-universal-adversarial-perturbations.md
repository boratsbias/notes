---
title: "Universal Adversarial Perturbations"
year: 2016
authors: Seyed-Mohsen Moosavi-Dezfooli, Alhussein Fawzi, Omar Fawzi, Pascal Frossard
area: Deep Learning, Adversarial Robustness
link: https://arxiv.org/abs/1610.08401
---

## The finding

Prior adversarial example research produced perturbations that were input-specific: a noise pattern crafted to fool a model on one image fails on a different image. This paper demonstrates that a single image-agnostic perturbation vector δ exists that, when added to any image, causes a classifier to misclassify roughly 80% of the time. The perturbation is small in L_p norm and mostly imperceptible to humans.

## How the universal perturbation is computed

The algorithm iterates over training images and accumulates perturbations. For each image x_i, it checks whether the current δ already causes misclassification. If not, it computes the minimal additional perturbation that pushes x_i + δ across the nearest decision boundary, using DeepFool to find this minimal step. That per-image correction is added to δ, which is then projected back onto an L_p ball of radius ξ to keep the total magnitude bounded. The loop repeats over the dataset until δ fools the target fraction of training examples. The resulting δ is fixed and applied identically to any test image.

## The geometric explanation

Why does a single vector work across such diverse inputs? Decision boundaries in high-dimensional pixel space are locally approximately planar, and those planes share similar orientations across different input regions of the space. A universal perturbation exploits this by finding a direction in pixel space that is nearly perpendicular to the decision boundaries of most images simultaneously. Moving in that direction crosses many boundaries at once. The paper shows that the boundaries cluster geometrically in ways that the model's training objective never explicitly discouraged.

## Cross-architecture transferability

Universal perturbations computed against one architecture transfer to other architectures with meaningful success rates. A δ crafted against VGG-16 also fools GoogLeNet, ResNet, and CaffeNet. This cross-model transferability is stronger than for standard input-specific adversarial examples, suggesting the vulnerability is rooted in the geometry of the image classification task itself, not in idiosyncratic properties of any particular model's weights.

## Results and impact

The paper demonstrated that classifiers have systematic, exploitable geometric weaknesses that a single fixed perturbation can activate. This moved adversarial robustness from a per-sample curiosity to a structural concern. It motivated adversarial training approaches that explicitly inject universal perturbations, certified defense methods that provide provable robustness guarantees, and ongoing investigation into what structural properties of training data and objectives produce these clustered decision boundaries.
