# 3D Vision

3D vision covers the perception, representation, and understanding of 3D scenes and objects from 2D images, depth sensors, or LiDAR point clouds.

## Camera Models and Projection

### Pinhole Camera Model

Maps a 3D world point $\mathbf{P} = (X, Y, Z)^\top$ to a 2D image point $\mathbf{p} = (u, v)^\top$.

**Projection:**

$$\begin{pmatrix} u \\ v \\ 1 \end{pmatrix} \sim K \begin{pmatrix} R | t \end{pmatrix} \begin{pmatrix} X \\ Y \\ Z \\ 1 \end{pmatrix}$$

**Intrinsic matrix $K$:**

$$K = \begin{pmatrix} f_x & 0 & c_x \\ 0 & f_y & c_y \\ 0 & 0 & 1 \end{pmatrix}$$

where $f_x, f_y$ are focal lengths in pixels and $(c_x, c_y)$ is the principal point.

**Extrinsic matrix $[R|t]$:** rotation and translation from world to camera coordinates.

**Homogeneous coordinates:** use $\sim$ to denote equality up to scale.

## Stereo Vision

Two cameras observe the same scene; triangulate 3D points from correspondences.

**Epipolar geometry:** the relationship between two views. A point in one image lies on a line (the epipolar line) in the other image.

**Fundamental matrix $F$:** encodes epipolar geometry without knowing $K$.

$$\mathbf{p}^{\prime\top} F \mathbf{p} = 0$$

**Essential matrix $E = K^{\prime\top} F K$:** encodes relative rotation and translation.

**Disparity:** horizontal pixel difference between matched points.

$$Z = \frac{f \cdot b}{d}$$

where $f$ is focal length, $b$ is the baseline (camera separation), $d$ is the disparity.

**Stereo matching:** find corresponding points between left and right images. Block matching, SGM (Semi-Global Matching), or learned cost volumes (PSMNet, RAFT-Stereo).

## Depth Estimation

### Monocular Depth Estimation

Predict a depth map from a single RGB image. Inherently ambiguous; solved with learned priors.

**DPT (Dense Prediction Transformer):** ViT backbone + dense prediction head. Produces high-quality relative depth maps.

**Depth Anything (2024):** large-scale training on 62M images (labeled + unlabeled); strong zero-shot monocular depth. Depth Anything v2 uses synthetic data for improved detail.

**Metric depth:** predict absolute depth in meters. Requires scale calibration. ZoeDepth, Depth Pro.

### Self-Supervised Depth

Train using photometric consistency between frames of a monocular video (no depth labels).

Reproject frame $t$ to frame $t'$ using the predicted depth and estimated camera pose; minimize the photometric error.

**Monodepth2 (2019):** competitive self-supervised depth; handles moving objects with a masking scheme.

## 3D Object Representations

| Representation | Description | Memory | Notes |
|---------------|-------------|--------|-------|
| Voxel grid | 3D occupancy or feature grid | $O(N^3)$ | Simple; poor scaling |
| Point cloud | Unordered set of 3D points | $O(N)$ | Irregular; from LiDAR/depth |
| Mesh | Vertices + faces | $O(N)$ | Standard for rendering |
| Implicit function | $f(x,y,z) \in \mathbb{R}$ (SDF, occupancy) | Continuous | Flexible topology |
| NeRF | Volume radiance field | Continuous | Photorealistic novel views |
| 3D Gaussian Splatting | Set of 3D Gaussians | $O(N)$ | Fast rendering |

## Point Cloud Processing

### PointNet

Qi et al. (2017). Process each point independently with shared MLP; aggregate with global max pooling.

$$f(\{p_1, \ldots, p_n\}) = g(h(p_1), \ldots, h(p_n))$$

where $h$ is a per-point MLP and $g$ is max pooling. Permutation invariant; handles variable-size sets.

**T-Net:** predict an alignment matrix to canonicalize point clouds before processing.

**Limitation:** no local structure; each point processed independently.

### PointNet++

Hierarchical local grouping: recursively apply PointNet to local neighborhoods (via ball query or kNN) to capture local-to-global structure. Analogous to a CNN receptive field.

### Point Transformers

Apply self-attention on local neighborhoods of points. Position encoding via 3D coordinate offsets. State of the art for 3D classification and segmentation.

### VoxelNet / PointPillars (LiDAR Detection)

**VoxelNet:** voxelize the point cloud; apply PointNet per voxel; apply 3D convolutions.

**PointPillars:** voxelize to vertical pillars (2D grid); apply PointNet per pillar; flatten to pseudo-image; apply 2D convolutions. Fast; standard in autonomous driving.

## Neural Radiance Fields (NeRF)

Mildenhall et al. (2020). Represent a 3D scene as a continuous volumetric function modeled by an MLP.

**Input:** $(x, y, z, \theta, \phi)$ (3D position + viewing direction).

**Output:** $(r, g, b, \sigma)$ (color + volume density).

**Volume rendering:** integrate color along a ray $r(t) = o + td$:

$$C(r) = \int_{t_n}^{t_f} T(t) \sigma(r(t)) c(r(t), d) \, dt$$

$$T(t) = \exp\!\left(-\int_{t_n}^t \sigma(r(s)) ds\right)$$

In practice, approximate with stratified + hierarchical sampling.

**Training:** minimize photometric error over training views (no 3D supervision needed).

**Limitations:** slow training (hours) and rendering (seconds per frame). Position encoding via sinusoidal features is critical for capturing high-frequency detail.

### NeRF Improvements

**Instant-NGP (2022):** replace MLP with a multi-resolution hash encoding + small MLP. Trains in seconds; renders in real time.

**Zip-NeRF / 3D Gaussian Splatting:** real-time rendering at high quality.

## 3D Gaussian Splatting

Kerbl et al. (2023). Represent the scene as a set of 3D Gaussians $\{(\mu_i, \Sigma_i, c_i, \alpha_i)\}$ (center, covariance, color, opacity).

**Rendering:** project Gaussians to 2D; sort by depth; alpha-composite front to back. Fully differentiable; train in minutes; render at 100+ fps.

**Optimization:** initialize from SfM point cloud; optimize Gaussian parameters by minimizing photometric error with densification and pruning.

## Structure from Motion (SfM) and SLAM

**SfM:** reconstruct 3D structure and camera poses from a collection of unordered images.

1. Detect and match keypoints (SIFT, SuperPoint).
2. Estimate pairwise poses (essential matrix, RANSAC).
3. Incremental or global bundle adjustment to jointly optimize all cameras and points.

**COLMAP:** standard SfM software; used to initialize NeRF training.

**SLAM (Simultaneous Localization and Mapping):** real-time SfM from a moving camera. Classic: filter-based (EKF) or factor graph (g2o). Neural: NeRF-SLAM, MonoGS with Gaussian Splatting.

## 3D Object Detection (LiDAR)

Detect 3D bounding boxes (center, size, orientation) from LiDAR point clouds.

**VoxelNet / Second / PointPillars:** standard backbone approaches.

**CenterPoint:** heatmap-based 3D detection analogous to CenterNet. Predict center point heatmap + box attributes. State of the art on Waymo Open Dataset and nuScenes.

**Range images:** project LiDAR to a 2D range image (row = elevation, col = azimuth); apply 2D CNNs. Fast; some distortion.
