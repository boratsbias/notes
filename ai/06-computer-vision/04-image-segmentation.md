# Image Segmentation

Image segmentation assigns a label to every pixel in an image. It is a denser output task than classification or detection.

## Segmentation Types

| Task | Output | Example |
|------|--------|---------|
| Semantic segmentation | Class label per pixel (no instances) | All cars = "car", no distinction |
| Instance segmentation | Per-instance binary mask + class | Each car gets its own mask |
| Panoptic segmentation | Semantic for stuff + instance for things | Unified output over all categories |
| Medical image segmentation | Organ or lesion boundaries | CT, MRI scans |

**"Things":** countable objects (people, cars, chairs).

**"Stuff":** amorphous regions (sky, road, grass).

## Semantic Segmentation

### Fully Convolutional Network (FCN)

Long et al. (2015). Replace FC layers with $1 \times 1$ convolutions; produce a spatial output map at a coarse resolution; upsample with transposed convolutions (deconvolution). First end-to-end trainable semantic segmentation model.

### Encoder-Decoder: U-Net

Ronneberger et al. (2015). Designed for biomedical image segmentation.

**Encoder (contracting path):** repeated 3×3 conv, ReLU, 2×2 max pool. Doubles channels at each stage.

**Decoder (expanding path):** 2×2 transposed conv upsampling; concatenate skip connection from the corresponding encoder stage; 3×3 conv.

Skip connections preserve fine spatial detail lost during downsampling. U-Net is standard for medical image segmentation and many dense prediction tasks.

### Dilated Convolutions: DeepLab Family

Chen et al. Use atrous (dilated) convolutions to maintain high-resolution feature maps without downsampling.

**Atrous Spatial Pyramid Pooling (ASPP):** apply dilated convolutions with multiple dilation rates ($d = 6, 12, 18$) in parallel; concatenate their outputs. Captures context at multiple scales.

**DeepLabv3+:** combines ASPP encoder with a lightweight U-Net-style decoder to recover sharp boundaries.

### Evaluation: Mean Intersection over Union (mIoU)

For class $k$:

$$\text{IoU}_k = \frac{TP_k}{TP_k + FP_k + FN_k}$$

mIoU = mean over all classes. Standard benchmark metric.

**Pixel accuracy:** fraction of correctly labeled pixels. Biased toward large classes.

## Instance Segmentation

### Mask R-CNN

He et al. (2017). Extends Faster R-CNN with a mask head.

**Pipeline:**
1. FPN backbone extracts multi-scale features.
2. RPN generates region proposals.
3. **RoIAlign:** extracts fixed-size features per proposal. Uses bilinear interpolation (vs. RoI Pooling which uses quantization); preserves spatial precision.
4. Box head: class + bounding box.
5. **Mask head:** $28 \times 28$ binary mask per class, independent per class. Only the ground-truth class mask is used during training.

Mask head and box head run in parallel; mask does not depend on the predicted class to avoid feedback loops.

### YOLACT (Real-Time Instance Segmentation)

Generates $k$ global prototype masks; predicts per-instance linear combination coefficients. Assembles instance masks as:

$$M_\text{inst} = \sigma(PC^T)$$

where $P \in \mathbb{R}^{H \times W \times k}$ are prototypes and $C \in \mathbb{R}^{k}$ are predicted coefficients.

Real-time inference on GPUs.

### CondInst / SOLOv2

Dynamically generate per-instance convolutional kernels conditioned on instance-level features. Apply the generated kernel to a feature map to produce the mask.

## Panoptic Segmentation

Unifies semantic and instance segmentation into a single task.

**Output:** each pixel is assigned either a (class, instance\_id) pair for "things" or a class label for "stuff".

**Panoptic Quality (PQ):**

$$PQ = \underbrace{\frac{\sum_{(p,g) \in TP} \text{IoU}(p, g)}{|TP|}}_{\text{segmentation quality}} \times \underbrace{\frac{|TP|}{|TP| + \frac{1}{2}|FP| + \frac{1}{2}|FN|}}_{\text{recognition quality}}$$

### Panoptic FPN

Adds a semantic segmentation head alongside the instance segmentation head on top of FPN features. Merges outputs with heuristic rules (things override stuff within detected boxes).

### Mask2Former

Cheng et al. (2021). Universal architecture for all three tasks. A Transformer decoder with $N$ learned queries; each query attends to multi-scale features and predicts (class, binary mask).

**Masked attention:** restricts each query's attention to the predicted foreground region of the previous layer, not the full feature map. Improves training convergence and prediction quality.

**State of the art** for panoptic, instance, and semantic segmentation on COCO and ADE20k.

## Medical Image Segmentation

**Challenges:** limited labeled data; fine-grained boundaries; 3D volumes (CT/MRI); class imbalance.

**3D U-Net:** 3D convolutions for volumetric segmentation.

**nnU-Net:** automated, self-configuring U-Net pipeline. Automatically sets architecture, preprocessing, and training for any medical dataset. Strong empirical baseline; winner of many medical segmentation challenges.

**SAM (Segment Anything Model):** large-scale pretraining for prompt-based segmentation (point, box, or mask prompt). Zero-shot generalization to arbitrary segmentation tasks.
