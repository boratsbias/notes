# Feature Extraction

Feature extraction maps raw images to compact, informative representations that capture semantic and structural content. These features are the basis for retrieval, similarity search, transfer learning, and downstream tasks.

## CNN Feature Hierarchies

In a deep CNN, different layers encode different levels of abstraction.

| Layer depth | What it encodes | Example features |
|------------|----------------|-----------------|
| Early (conv1-conv2) | Low-level patterns | Edges, corners, colors, textures |
| Mid (conv3-conv4) | Mid-level parts | Eyes, wheels, textures |
| Late (conv5+) | High-level semantics | Object categories, scene context |
| Final FC | Task-specific | Class logits |

**Global Average Pooling (GAP)** of the last conv layer (before FC) is the most common general-purpose feature vector. Dimension is the number of output channels ($e.g.$ 2048 for ResNet-50).

## Pretrained Feature Extractors

Pretrained CNN or ViT backbones are standard feature extractors for downstream tasks without task-specific retraining.

**Steps:**
1. Load a pretrained model (ImageNet).
2. Remove the final classification head.
3. Forward an image; take the output of GAP or the `[CLS]` token (ViT) as the feature vector.
4. Use features for retrieval, KNN classification, SVM, linear probe, etc.

**Linear probe:** train a logistic regression classifier on top of frozen features. Measures the quality of the representation without fine-tuning.

## Classical Feature Descriptors

### SIFT (Scale-Invariant Feature Transform)

Lowe (2004). Detects repeatable keypoints and computes descriptors invariant to scale, rotation, and lighting changes.

**Keypoint detection:**
1. Build a Gaussian scale space: $L(x, y, \sigma) = G(x, y, \sigma) * I(x, y)$.
2. Compute Difference of Gaussians (DoG): $D = L(x, y, k\sigma) - L(x, y, \sigma)$.
3. Local extrema in scale and space are keypoint candidates.
4. Remove low-contrast points and edge responses.

**Descriptor:**
1. Assign dominant orientation from local gradient histogram.
2. Compute $4 \times 4$ spatial histogram of gradient orientations (8 bins each) in a $16 \times 16$ neighborhood aligned to the dominant orientation.
3. Concatenate into a 128-dim vector; L2-normalize.

**Invariances:** scale (detected at multiple scales), rotation (orientation assigned), illumination (L2 normalization), some affine.

### HOG (Histogram of Oriented Gradients)

Dalal & Triggs (2005). Dense descriptor for object detection.

1. Compute gradient magnitude and orientation at each pixel.
2. Divide the image into $8 \times 8$ pixel cells.
3. Build a 9-bin histogram of gradient orientations per cell.
4. Group cells into $2 \times 2$ blocks; L2-normalize each block.
5. Concatenate all block descriptors.

**Properties:** captures local edge structure; invariant to small geometric and photometric changes; the standard pedestrian detector feature.

### ORB (Oriented FAST and Rotated BRIEF)

Combines FAST keypoint detector + BRIEF binary descriptor with rotation invariance. 100$\times$ faster than SIFT; suitable for real-time applications.

**Binary descriptor:** each bit is the result of an intensity comparison between two pixels. Hamming distance matching is very fast.

## Image Retrieval

Find images in a database that are similar to a query image.

**Pipeline:**
1. Extract feature vectors for all database images (offline).
2. For a query image, extract its feature vector.
3. Search for nearest neighbors by cosine similarity or L2 distance.
4. Re-rank top results using geometric verification (RANSAC).

**Approximate Nearest Neighbor (ANN):** exact search in $\mathbb{R}^d$ is $O(nd)$ per query. ANN methods (FAISS, HNSW, ScaNN) trade exact results for speed.

**Compact representations:**
- **PCA whitening:** reduce dimensionality; remove correlation.
- **Product quantization:** compress a 2048-dim float vector to ~64 bytes with small accuracy loss. Used in FAISS for billion-scale retrieval.
- **Hashing:** locality-sensitive hashing (LSH) maps similar vectors to the same hash bucket.

## Metric Learning

Train a model to produce embeddings where semantically similar images are close and dissimilar images are far, without a fixed class label.

**Contrastive loss (Chopra et al. 2005):**

$$\mathcal{L} = y \cdot D^2 + (1-y) \cdot \max(0, m - D)^2$$

where $y=1$ if the pair is similar, $D$ is the embedding distance, and $m$ is the margin.

**Triplet loss (FaceNet, 2015):**

$$\mathcal{L} = \sum \max(0, \|f(a) - f(p)\|^2 - \|f(a) - f(n)\|^2 + \alpha)$$

anchor-positive distance should be smaller than anchor-negative distance by margin $\alpha$.

**Hard negative mining:** randomly sampled negatives are too easy. Mine the hardest negatives (most similar negatives in the batch) for faster convergence.

**ArcFace:** widely used for face recognition. Adds an additive angular margin $m$ in the softmax:

$$\mathcal{L} = -\log \frac{e^{s \cos(\theta_{y_i} + m)}}{e^{s \cos(\theta_{y_i}+m)} + \sum_{j \neq y_i} e^{s \cos \theta_j}}$$

## Bag of Visual Words (BoVW)

Classical image representation for retrieval and classification.

1. Extract SIFT descriptors from all training images.
2. **Cluster** with k-means into $K$ visual words (the "codebook" or "vocabulary").
3. Quantize each descriptor to its nearest visual word.
4. Represent each image as a $K$-dim histogram of visual word counts.
5. Optionally: TF-IDF weighting; spatial pyramid matching (SPM) for spatial layout.

**VLAD (Vector of Locally Aggregated Descriptors):** instead of counting, accumulate residuals within each cluster. Produces a $K \cdot d$-dim descriptor. Better than BoVW.

**Fisher Vector:** soft assignment to a GMM; concatenate first and second-order statistics per component. Strong performance; used in the pre-deep learning era for large-scale retrieval.

## Self-Supervised Feature Learning

See [Image Classification](02-image-classification) for SimCLR, MoCo, BYOL, MAE, and DINOv2, which produce state-of-the-art general-purpose visual features without any human labels.
