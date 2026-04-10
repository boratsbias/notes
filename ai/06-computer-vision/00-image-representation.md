# Image Representation

An image is a discrete 2D signal. How it is represented in memory and how features are computed from it form the foundation of all computer vision algorithms.

## Pixel Representation

A grayscale image is a 2D array $I \in \mathbb{R}^{H \times W}$, where each element $I(y, x)$ is the intensity at row $y$, column $x$.

A color image (RGB) is a 3D tensor $I \in \mathbb{R}^{H \times W \times 3}$, where the three channels are red, green, and blue intensities.

**Bit depth:**
- 8-bit: pixel values in $[0, 255]$. Standard for most images.
- 16-bit: $[0, 65535]$. Medical imaging, HDR.
- Float32: $[0.0, 1.0]$. Neural network inputs after normalization.

**Channel conventions:**
- RGB: standard (Pillow, torchvision).
- BGR: OpenCV default. Swap channels when mixing libraries.
- NCHW: (batch, channels, height, width). PyTorch convention.
- NHWC: (batch, height, width, channels). TensorFlow convention.

## Color Spaces

**RGB:** additive color model. Intuitive but channels are highly correlated.

**HSV (Hue, Saturation, Value):** separates color (hue) from intensity (value). More robust for color-based segmentation; hue is invariant to lighting changes.

**LAB (CIELAB):** perceptually uniform. L = lightness, A = green-red, B = blue-yellow. Euclidean distance in LAB correlates with perceived color difference. Used for color normalization in histopathology.

**YCbCr:** separates luma (Y) from chroma (Cb, Cr). Used in JPEG compression; separates lighting from color.

**Grayscale conversion:**

$$I_\text{gray} = 0.299 R + 0.587 G + 0.114 B$$

Coefficients reflect human perception (higher sensitivity to green).

## Image Normalization

Before feeding into a neural network, normalize pixel values:

**Scale to [0, 1]:** divide by 255.

**Standardize (ImageNet statistics):**

$$x_\text{norm} = \frac{x - \mu}{\sigma}$$

where $\mu = [0.485, 0.456, 0.406]$ and $\sigma = [0.229, 0.224, 0.225]$ for RGB channels (computed on ImageNet). Standard for pretrained models.

## Image Transforms and Augmentation

**Geometric transforms:**
- Resize: bilinear or bicubic interpolation to a target resolution.
- Crop: random crop during training; center crop at inference.
- Flip: horizontal flip (label-preserving for most tasks).
- Rotation: rotate by $[-\theta, \theta]$ degrees.
- Affine: combined scale, shear, translate.
- Perspective warp: simulate viewpoint change.

**Photometric transforms:**
- Brightness / contrast / saturation / hue jitter (ColorJitter).
- Gaussian blur, sharpen.
- Random grayscale.
- Gaussian noise.
- Random erasing (Cutout): mask out rectangular patches.

**Advanced augmentation:**
- **Mixup:** blend two images and their labels: $\tilde{x} = \lambda x_i + (1-\lambda) x_j$, $\tilde{y} = \lambda y_i + (1-\lambda) y_j$.
- **CutMix:** paste a rectangular patch from one image into another; blend labels proportionally to the patch area.
- **RandAugment:** automatically select from a large set of augmentation policies.
- **AugMix:** mix multiple augmented versions to improve consistency.

## Spatial Pyramid and Multi-Scale Representation

Many vision features are scale-dependent. Multi-scale representations capture structure at different resolutions.

**Image pyramid:** compute the image at multiple scales by repeated downsampling.

$$I_0 = I, \quad I_{k+1} = \text{downsample}(I_k)$$

**Gaussian pyramid:** smooth before downsampling to prevent aliasing (anti-aliased).

**Laplacian pyramid:** difference of Gaussian pyramid levels; captures bandpass features at each scale. Used in image blending and compression.

**Feature pyramid (FPN):** compute feature maps at multiple CNN stages and combine top-down pathways with lateral connections to produce multi-scale feature maps. Foundational for multi-scale object detection.

## Frequency Domain Representation

**Discrete Fourier Transform (DFT):** decomposes the image into sinusoidal frequency components.

$$F(u, v) = \sum_{y=0}^{H-1} \sum_{x=0}^{W-1} I(y, x) \, e^{-2\pi i (uy/H + vx/W)}$$

Low frequencies (center of spectrum): global structure. High frequencies (periphery): edges, fine detail.

**DCT (Discrete Cosine Transform):** real-valued frequency decomposition. Basis of JPEG compression: transform 8×8 blocks, quantize high-frequency coefficients.

**High-frequency components carry edge information.** Low-pass filtering blurs; high-pass filtering sharpens / detects edges.

## Classical Feature Descriptors (Pre-Deep Learning)

Before neural networks, features were hand-engineered.

**SIFT (Scale-Invariant Feature Transform):** detect keypoints at multiple scales via difference-of-Gaussians; describe each with a 128-dim histogram of gradient orientations. Invariant to scale and rotation.

**HOG (Histogram of Oriented Gradients):** compute gradient orientation histograms in local cells; normalize over blocks. Standard feature for pedestrian detection (DPM, SVM+HOG).

**LBP (Local Binary Pattern):** encode the relationship of each pixel to its neighbors as a binary pattern. Efficient; used in face recognition.

These descriptors are largely replaced by CNN features, but remain useful for interpretability, lightweight deployment, and understanding what neurons learn.

## Depth and Range Images

**Depth image:** each pixel stores the distance from the camera to the scene point. $D \in \mathbb{R}^{H \times W}$.

**Sources:** structured light (Intel RealSense), time-of-flight (Azure Kinect), stereo disparity, LiDAR.

**RGBD:** RGB image paired with a depth map. Used for 3D scene understanding, robotics, AR.

**Point cloud:** unordered set of 3D points $\{(x_i, y_i, z_i)\}$ from LiDAR or depth image unprojection. See [3D Vision](09-3d-vision).
