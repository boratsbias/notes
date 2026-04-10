# Video Understanding

Video understanding extends image understanding to the temporal dimension. Models must reason about motion, actions, and temporal structure across frames.

## Video Representation

A video is a sequence of frames $\{I_t\}_{t=1}^T$, where each frame $I_t \in \mathbb{R}^{H \times W \times 3}$.

**Key challenges vs. images:**
- **Temporal redundancy:** adjacent frames are highly similar. Sampling strategies matter.
- **Motion:** objects and the camera move; temporal modeling must capture motion patterns.
- **Long range:** action recognition may require context over minutes.
- **Computational cost:** processing all frames is prohibitive; efficient sampling is essential.

## Optical Flow

Optical flow $\mathbf{u}(x, y) = (u, v)$ describes the apparent motion of each pixel between two consecutive frames.

**Lucas-Kanade:** assumes constant flow in a small neighborhood; solves a local least-squares system.

**Horn-Schunck:** global smoothness constraint; variational formulation.

**FlowNet / PWCNet / RAFT:** learned optical flow with CNNs. RAFT (2020) builds a 4D cost volume and iteratively updates the flow field; state of the art.

Optical flow is used as an explicit motion feature in two-stream action recognition models.

## Action Recognition

Classify the action performed in a video clip into one of $K$ categories.

**Benchmarks:** UCF-101 (101 classes, 13k clips), HMDB-51, Kinetics-400/600/700, Something-Something (temporal reasoning).

### Two-Stream Networks

Simonyan & Zisserman (2014). Two parallel CNNs:
- **Spatial stream:** single RGB frame. Captures appearance.
- **Temporal stream:** stacked optical flow frames (10 consecutive frames, 20 channels). Captures motion.

Late fusion of softmax scores. Complementary information; fusion outperforms either stream alone.

### 3D Convolutions (C3D, I3D)

Replace 2D convolutions with 3D convolutions $W \in \mathbb{R}^{t \times k \times k \times C_\text{in} \times C_\text{out}}$ that operate on space and time jointly.

**I3D (Two-Stream Inflated 3D ConvNet):** "inflate" a 2D ImageNet-pretrained model (Inception) to 3D by repeating 2D weights along the temporal axis. Initialize 3D filters from 2D pretrained weights.

**Limitation:** high memory and compute cost; short temporal windows (16-32 frames).

### Efficient 3D Models

**SlowFast:** two pathways at different temporal resolutions.
- **Slow pathway:** low frame rate (4 fps); captures spatial semantics; many channels.
- **Fast pathway:** high frame rate (32 fps); captures fine motion; few channels.
- Lateral connections fuse temporal information from fast to slow.

**X3D:** family of efficient 3D CNNs found via axis-wise neural architecture search. Progressive expansion of time, space, channels, and depth. Outperforms I3D with a fraction of the FLOPs.

### Video Transformers

**TimeSformer (2021):** apply standard ViT to video by factorizing attention.
- **Divided space-time attention:** first attend over spatial tokens at the same time step; then attend over temporal tokens at the same spatial location. Linear in $T \times H \times W$ instead of quadratic.

**Video Swin Transformer:** 3D shifted window attention on video tubes (temporal extension of Swin). State-of-the-art accuracy/efficiency tradeoff.

**VideoMAE:** mask 90% of video patches; reconstruct pixel values. High masking ratio is key because of temporal redundancy. Strong pretraining for action recognition.

## Temporal Action Detection and Segmentation

**Temporal action detection:** find the start and end times of actions in an untrimmed video.

**Temporal Action Proposal Networks:** generate proposals for action boundaries (analogous to RPN for spatial detection). ActionFormer refines proposals with a Transformer over temporal features.

**Temporal action segmentation:** label every frame with an action class. Used in procedure understanding, cooking videos, surgical workflow analysis.

**MS-TCN (Multi-Stage Temporal Convolutional Network):** 1D dilated convolutions over frame-level features; multiple refinement stages.

## Video Object Detection

Extend image detection to video, exploiting temporal consistency.

**Approaches:**
- **Frame-by-frame:** apply image detector per frame. Fast; inconsistent across frames.
- **Feature aggregation:** aggregate features from neighboring frames via attention or flow-warping. More stable; more compute.
- **Tracking-by-detection:** detect in key frames; propagate with a tracker.

## Video Generation

**VideoGAN / TGAN:** extend GAN to generate short video clips.

**VQVAE + Transformer:** tokenize video to discrete codes; train an autoregressive Transformer. VideoGPT.

**Video diffusion:** extend latent diffusion to video. Key challenges: temporal consistency, long-range coherence.

**Sora (OpenAI, 2024):** DiT-based video diffusion model. Trained on videos of variable duration and resolution. Generates high-quality 1-minute videos with coherent physics and camera motion.

**Stable Video Diffusion (SVD):** image-to-video diffusion model; generates short clips from a single reference image.

## Video Captioning and Retrieval

**Video captioning:** generate a natural language description of a video clip.

**Dense video captioning:** caption all events in a long video.

**Video-text retrieval:** given a text query, retrieve the most relevant video from a database (or vice versa).

**Models:** CLIP4Clip extends CLIP to video; VideoCLIP; InternVideo. Text and video are projected into a shared embedding space; cosine similarity for retrieval.

## Evaluation

| Task | Metric |
|------|--------|
| Action recognition | Top-1 / Top-5 accuracy |
| Temporal detection | mAP at various IoU thresholds |
| Video captioning | CIDER, METEOR, BLEU |
| Video retrieval | Recall@1/5/10 |
| Video generation | FVD (Fréchet Video Distance), human evaluation |
