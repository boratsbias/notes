# Computer Vision Foundations

## Core Idea

Computer vision studies algorithms that extract meaning from images and videos.

The goal is to map pixel arrays to useful outputs such as labels, boxes, masks, 3D structure, or generated images.

## Digital Images

An image is a tensor of intensity values.

- grayscale image: $H \times W$
- color image: $H \times W \times C$
- batch of images: $B \times H \times W \times C$ or $B \times C \times H \times W$

Each pixel has local meaning, but visual understanding depends strongly on spatial structure.

## Why Vision Is Hard

- objects vary in scale, pose, and lighting
- backgrounds introduce clutter
- the same object can appear very differently across images
- images are high-dimensional

## Core Tasks

| Task | Output |
|------|--------|
| Image classification | One or more labels |
| Object detection | Bounding boxes and classes |
| Semantic segmentation | Class per pixel |
| Instance segmentation | Separate mask per object |
| Keypoint estimation | Landmark coordinates |
| Image generation | New synthetic images |

## Feature Hierarchies

Vision models often learn progressively richer features:

- edges and corners
- textures and motifs
- parts and shapes
- whole objects
- scene-level concepts

## Convolution

Convolutional networks apply small filters across the image.

If $X$ is an input image and $K$ is a kernel:

$$Y(i, j) = \sum_{u,v} X(i+u, j+v)K(u, v)$$

This gives:

- local connectivity
- parameter sharing
- translation-sensitive pattern detection

## Pooling and Downsampling

Pooling reduces spatial resolution.

- lowers computation
- increases receptive field
- provides some invariance to local changes

## Modern Architectures

| Architecture | Main Idea |
|--------------|-----------|
| CNN | Local convolutions build spatial features |
| ResNet | Residual connections enable deep training |
| U-Net | Encoder-decoder for dense prediction |
| ViT | Treat image patches as tokens for attention |

## Data and Augmentation

Vision models rely heavily on data augmentation:

- random crop
- flip
- color jitter
- blur or noise
- mixup or cutmix

These help models generalize beyond the exact training images.

## Evaluation

Common metrics:

- accuracy for classification
- mAP for detection
- IoU and Dice score for segmentation
- PSNR or SSIM for reconstruction tasks

## Important Trends

Computer vision has moved from hand-crafted features such as SIFT and HOG to learned representations from CNNs, transformers, and multimodal pretraining.
