# How Transferable Are Features in Deep Neural Networks? (2014)

**Authors:** Jason Yosinski, Jeff Clune, Yoshua Bengio, Hod Lipson
**Area:** Deep Learning, Transfer Learning
**Link:** [arXiv](https://arxiv.org/abs/1411.1792)

## What the paper argues

It was known that ImageNet-trained CNN features transfer well, but nobody had systematically studied why, which layers transfer better, and what happens when layers are frozen vs fine-tuned. This paper provides that analysis through controlled experiments: networks are split at different layers, some layers are frozen and others are re-trained, and the resulting performance is measured on related and unrelated tasks.

## General vs specific features

Features are not equally transferable across layers:

```
Layer 1-2:   General  (Gabor filters, color blobs, edges)
              → identical across tasks, always safe to transfer

Layer 3-4:   Transitional  (moving toward task-specific patterns)
              → transfer degrades with task dissimilarity

Layer 5-7:   Specific  (semantic concepts tied to training task)
              → poor transfer to unrelated tasks
```

This general-to-specific gradient is a fundamental property of deep networks and motivates freezing early layers and fine-tuning later ones.

## Two causes of transfer failure

The paper identifies two independent factors that hurt frozen transferred features:

1. **Task specificity:** later layers contain features specialized for the source task that are not useful for the target task.

2. **Co-adaptation disruption:** neurons in the same layer co-adapt during training. When some layers are frozen and others are trained from scratch, this co-adaptation is broken. Fine-tuning all layers (rather than re-training some from scratch) restores it.

## Fine-tuning beats frozen features

Even when transferring to a very similar task, fine-tuning the transferred layers always outperforms freezing them:

```
Transfer + frozen:       some degradation from co-adaptation disruption
Transfer + fine-tuned:   matches or exceeds training from scratch
```

## Results and impact

Provided quantitative grounding for transfer learning intuitions and directly justified the standard practice: initialize from ImageNet weights, freeze early layers, fine-tune later layers. Remains the standard reference for understanding layer transferability.
