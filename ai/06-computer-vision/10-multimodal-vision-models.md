# Multimodal Vision Models

Multimodal vision models connect vision and language (or other modalities), enabling image-text understanding, visual question answering, image captioning, and open-vocabulary visual tasks.

## Vision-Language Contrastive Learning: CLIP

Radford et al. (2021). Train a visual encoder and a text encoder jointly to align image-text pairs from 400M noisy web pairs.

**Architecture:**
- **Image encoder:** ViT-L/14 or ResNet-based.
- **Text encoder:** Transformer (GPT-2 style), max 77 tokens.

**Training objective:** contrastive loss over a batch of $N$ image-text pairs. Each image should be similar to its paired text and dissimilar to all $N-1$ other texts:

$$\mathcal{L}_\text{CLIP} = -\frac{1}{2N}\left(\sum_{i=1}^N \log \frac{\exp(\text{sim}(v_i, t_i)/\tau)}{\sum_j \exp(\text{sim}(v_i, t_j)/\tau)} + \sum_{i=1}^N \log \frac{\exp(\text{sim}(t_i, v_i)/\tau)}{\sum_j \exp(\text{sim}(t_i, v_j)/\tau)}\right)$$

**Zero-shot classification:** encode each class name as a text prompt ("a photo of a {class}"); classify by nearest-neighbor in the joint embedding space.

**Impact:** CLIP embeddings are highly transferable. Used as the backbone for:
- Zero-shot classification
- Image retrieval
- Open-vocabulary detection/segmentation
- Diffusion model conditioning (Stable Diffusion)
- Visual question answering via language model integration

### CLIP Variants

**OpenCLIP:** open-source CLIP trained on LAION-2B. Comparable or superior to original CLIP.

**SigLIP:** sigmoid loss instead of softmax contrastive. Each pair is positive or negative independently; no normalization over the batch. More stable; better with large batches.

**DFN (Data Filtering Networks, Apple):** learn to filter web data for quality before CLIP training. Strong data curation improves final model quality significantly.

## Image Captioning

Generate a natural language description of an image.

**BLIP (Bootstrapping Language-Image Pretraining):** unified model for captioning, retrieval, and VQA. Introduces CapFilt: a captioner generates synthetic captions for web images; a filter removes noisy captions. Uses a shared image-text encoder + text decoder.

**BLIP-2:** efficient architecture that bridges a frozen image encoder (ViT) and a frozen LLM via a lightweight Q-Former (cross-attention + self-attention layers that attend to a small set of learned query tokens). Achieves strong performance with minimal trainable parameters.

**Flamingo (DeepMind):** few-shot image-text model. Interleave image features into a pretrained language model via cross-attention layers added at regular intervals. Supports interleaved image-text sequences; strong few-shot learner.

## Visual Question Answering (VQA)

Given an image and a natural language question, produce an answer.

**VQA v2 benchmark:** 204k images, 1.1M questions, balanced to reduce language bias.

**Early fusion approaches:** concatenate visual features with question encoding; classify over answer vocabulary.

**MCAN (Deep Modular Co-Attention Networks):** stacked self-attention over questions + cross-attention between question and image features.

**Modern approach (LLM + visual encoder):** project image tokens into the LLM token space; auto-regressively generate the answer.

**Metrics:** accuracy over the most common answer (open-ended); BLEU/CIDER for generated answers.

## Large Vision-Language Models (LVLMs)

Combine a powerful visual encoder with an instruction-following LLM.

### LLaVA

Liu et al. (2023). Connect CLIP ViT encoder to LLaMA via a simple linear projection. Fine-tune on GPT-4-generated visual instruction data.

**LLaVA-1.5:** replace linear projection with MLP; use CLIP ViT-L/336px. Strong VQA and OCR.

**LLaVA-Next:** dynamic high-resolution input; split high-res images into tiles for better detail.

### InstructBLIP

Extend BLIP-2 with instruction tuning. Q-Former attends to image features; outputs are fed to a frozen LLM. Strong zero-shot performance.

### GPT-4V / GPT-4o

OpenAI multimodal models. Accept interleaved image-text inputs; produce rich, detailed descriptions, reasoning, and code. Support multiple images per prompt; strong at OCR, chart reading, spatial reasoning.

### Gemini

Google multimodal architecture. Gemini 1.5 Pro: 1M token context with native video, audio, image, and text understanding. Trained natively multimodal from the start (not a retrofit).

## Open-Vocabulary Detection and Segmentation

Extend detection and segmentation to arbitrary categories described in text, not just a fixed training set.

**Grounding DINO:** DETR-based detector conditioned on text. Detect any category described in natural language. Trained on grounding datasets (COCO, Flickr30k) + detection datasets.

**OWL-ViT:** CLIP ViT backbone; fine-tune with detection heads conditioned on text embeddings. Zero-shot open-vocabulary detection.

**GLIP:** unify grounding and detection as phrase grounding. Align phrase tokens and region features contrastively.

**SAM (Segment Anything):** prompt-based segmentation (point, box, mask). Open-vocabulary segmentation when combined with a text-grounded detector.

**SEEM / ODISE:** unified open-vocabulary detection + segmentation with text and visual prompts.

## Image-Text Retrieval

Retrieve the most relevant image for a text query (or vice versa).

**CLIP-based retrieval:** encode query and database; rank by cosine similarity. Zero-shot but limited by contrastive pretraining.

**FAISS index:** build an ANN index over encoded image embeddings for fast retrieval from millions of images.

**MS-COCO retrieval:** standard benchmark. R@1/5/10 measures recall at rank 1, 5, 10.

## Evaluation of Multimodal Models

| Benchmark | What it tests |
|-----------|--------------|
| VQAv2 | Visual question answering |
| GQA | Compositional spatial reasoning |
| TextVQA | OCR + reasoning |
| MMBench | Broad multimodal capabilities |
| MMMU | Multi-discipline expert knowledge |
| SeedBench | 12 evaluation dimensions |
| HallusionBench | Hallucination robustness |
| LLaVA-Bench | Detailed visual descriptions |

**Hallucination in LVLMs:** models generate descriptions of objects not present in the image. Evaluated with POPE (polling-based object probing) and corrected via RLHF-style preference tuning (LLaVA-RLHF, RLAIF-V).
