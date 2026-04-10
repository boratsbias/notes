# Object Detection

Object detection localizes and classifies all object instances in an image. The output is a set of bounding boxes with associated class labels and confidence scores.

## Problem Formulation

Given an image $x$, predict a set of detections $\{(b_i, c_i, s_i)\}$ where:
- $b_i = (x, y, w, h)$: bounding box (center coordinates + width/height).
- $c_i \in \{1, \ldots, K\}$: class label.
- $s_i \in [0, 1]$: confidence score.

The number of detections is variable.

## Evaluation: Mean Average Precision (mAP)

**IoU (Intersection over Union):**

$$\text{IoU}(b, b^*) = \frac{|b \cap b^*|}{|b \cup b^*|}$$

A detection is a true positive if $\text{IoU} \geq \theta$ (typically 0.5) and the class is correct.

**Precision-Recall curve:** rank predictions by confidence; compute precision and recall at each threshold.

**Average Precision (AP):** area under the precision-recall curve for a single class.

**mAP:** mean AP over all classes. COCO mAP averages over IoU thresholds from 0.50 to 0.95 in steps of 0.05.

## Anchor-Based Two-Stage Detectors

### R-CNN (2014)

1. **Region proposals:** ~2000 category-agnostic proposals from Selective Search.
2. **Feature extraction:** warp each proposal to a fixed size; forward through CNN independently.
3. **Classification:** SVM per class; bounding box regressor.

Slow: separate CNN forward for each proposal.

### Fast R-CNN (2015)

1. Forward the entire image through a CNN backbone once to produce a feature map.
2. **RoI Pooling:** extract a fixed-size feature vector for each proposal from the shared feature map. Bilinear interpolation.
3. **Classification + regression heads** on each RoI feature.

Faster: one backbone forward per image.

### Faster R-CNN (2015)

Replaces Selective Search with a **Region Proposal Network (RPN)** that runs on the shared feature map.

**RPN:** slides a small network over the feature map. At each location, predicts $K$ anchor objectness scores + $K$ bounding box offsets.

**Anchors:** predefined boxes at multiple scales ($128^2, 256^2, 512^2$) and aspect ratios ($1:1, 1:2, 2:1$).

**Training:** multi-task loss = RPN objectness + RPN regression + classification + box regression.

**FPN (Feature Pyramid Network):** build a top-down feature pyramid over backbone stages; assign proposals to appropriate pyramid levels by scale. Dramatically improves detection of small objects.

## Single-Stage Detectors

Remove the explicit proposal stage; predict class and box directly from the feature map grid.

### YOLO (You Only Look Once)

**YOLOv1 (2016):** divide the image into a $S \times S$ grid. Each cell predicts $B$ boxes (confidence + offsets) and $C$ class scores. Single forward pass; very fast.

**YOLOv3:** multi-scale predictions at 3 FPN levels; Darknet-53 backbone; 9 anchors.

**YOLOv5 / YOLOv8:** improved architectures with CSP blocks, PANet neck; strong accuracy/speed tradeoff. YOLOv8 is the current practical standard.

### SSD (Single Shot MultiBox Detector)

Predict at multiple feature map scales from a VGG backbone; no FPN upsampling. Multiple aspect ratio anchors per location.

### RetinaNet

Addresses class imbalance (far more background than foreground anchors).

**Focal loss:**

$$\text{FL}(p_t) = -\alpha_t (1 - p_t)^\gamma \log(p_t)$$

Down-weights easy negatives (high $p_t$) via the $(1-p_t)^\gamma$ factor. $\gamma = 2$ standard. Allows training on all anchors without hard negative mining.

**Architecture:** ResNet-FPN backbone + two parallel heads (classification, box regression) per FPN level.

## Anchor-Free Detectors

Avoid the complexity of anchor design and matching.

### FCOS

Predicts at each pixel location: class + $(l, t, r, b)$ distances to the four box edges + a centerness score (penalizes predictions far from the box center).

No anchors; no IoU-based assignment.

### CenterNet

Represents each object by its center point. Predict a heatmap of center points; regress width and height at the center.

$$p_k(x, y) = \text{keypoint heatmap for class } k$$

Offset correction for quantization error. Elegant; extends naturally to keypoint estimation and 3D detection.

### DETR (Detection Transformer)

Carion et al. (2020). Reformulate detection as a set prediction problem. No anchors, no NMS.

1. CNN backbone extracts features.
2. Transformer encoder processes the flattened feature map.
3. $N$ learned object queries attend to encoder output via cross-attention.
4. Each query predicts one (class, box) or "no object".
5. **Bipartite matching loss:** use the Hungarian algorithm to match predictions to ground truth; optimize matched pairs.

**Deformable DETR:** attention attends to a small set of sampled key points per query, not the full feature map. Faster convergence; handles multi-scale.

## Non-Maximum Suppression (NMS)

After generating many overlapping detections, keep only the best one per object.

1. Sort detections by score.
2. Keep the highest-score detection.
3. Remove all detections with $\text{IoU} > \theta$ (typically 0.5) with the kept detection.
4. Repeat.

**Soft NMS:** instead of removing overlapping boxes, decay their score: $s_i \leftarrow s_i \cdot e^{-\text{IoU}(b_i, b_\text{keep})^2 / \sigma}$. Helps when objects are densely packed.

## State of the Art

| Model | mAP (COCO) | Speed | Notes |
|-------|-----------|-------|-------|
| YOLOv8-x | 53.9 | Fast | Practical deployment |
| DINO (DETR) | 63.3 | Slow | Strongest anchor-free |
| Co-DETR | 66.0 | Slow | Best single-model |
| Grounding DINO | varies | Moderate | Open-vocabulary detection |

**Open-vocabulary detection:** detect objects not seen during training by conditioning on text descriptions. CLIP-based; enables zero-shot detection.
