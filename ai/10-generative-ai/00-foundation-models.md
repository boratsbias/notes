# Foundation Models

A foundation model is a large model trained on broad data at scale that can be adapted to a wide range of downstream tasks. The term was coined by Bommasani et al. (2021) in the Stanford CRFM report.

## What Makes a Foundation Model?

**Scale:** trained on massive datasets (hundreds of billions to trillions of tokens) with billions to trillions of parameters.

**Self-supervised pretraining:** no task-specific labels required. The model learns from raw data via objectives like next-token prediction, masked token prediction, or contrastive image-text alignment.

**Emergent capabilities:** properties not present in smaller models emerge at scale: in-context learning, chain-of-thought reasoning, code generation, instruction following.

**Transfer:** a single pretrained model serves as the starting point for many downstream tasks via fine-tuning, prompting, or retrieval augmentation. Fewer task-specific parameters required.

## Paradigm Shift

**Before foundation models (pre-2018):** each task required a separate model trained from scratch or with limited transfer. Feature engineering was important.

**After (2018-present):** pretrain one large model; adapt to any task. "Pretrain then fine-tune" paradigm, then "pretrain then prompt" paradigm.

## Examples by Modality

| Modality | Foundation Model | Organization |
|---------|-----------------|-------------|
| Text | GPT-4, Claude 3, LLaMA-3, Gemini | OpenAI, Anthropic, Meta, Google |
| Code | Codex, DeepSeek-Coder, StarCoder | OpenAI, DeepSeek, HuggingFace |
| Image | CLIP, DINO, SAM | OpenAI, Meta |
| Image generation | Stable Diffusion, DALL-E 3, Flux | Stability AI, OpenAI, Black Forest |
| Vision-Language | LLaVA, GPT-4V, Gemini 1.5 | Academia, OpenAI, Google |
| Audio | Whisper, AudioPaLM, MusicGen | OpenAI, Google, Meta |
| Video | Sora, Stable Video Diffusion | OpenAI, Stability AI |
| Multimodal | GPT-4o, Gemini 1.5 Pro, Claude 3 | OpenAI, Google, Anthropic |
| Science (bio) | AlphaFold, ESMFold, Geneformer | DeepMind, Meta, Broad |
| Science (chem) | ChemBERTa, MolBERT | Various |

## Pretraining Objectives

**Causal language modeling (CLM):** predict the next token. Autoregressive; enables generation. GPT family.

**Masked language modeling (MLM):** predict masked tokens. Bidirectional context; strong representations. BERT family.

**Contrastive image-text:** align image and text embeddings. CLIP, SigLIP.

**Masked image modeling:** predict pixels or discrete visual tokens for masked patches. MAE, BEiT.

**Denoising:** reconstruct corrupted text spans or image regions. T5, BART.

## Emergent Abilities

Abilities that appear at a certain scale threshold but are absent in smaller models.

| Ability | Approx. scale threshold |
|---------|------------------------|
| In-context learning | ~1B parameters |
| Chain-of-thought reasoning | ~100B parameters |
| Instruction following (zero-shot) | ~10B+ with RLHF |
| Multi-step arithmetic | ~100B parameters |
| Code synthesis | ~10B+ |

**Debate:** some "emergent" abilities may be artifacts of evaluation metrics (sharp transitions appear smooth under alternative metrics). But qualitative jumps in capability are widely observed.

## Foundation Model Risks

**Homogenization:** if everyone builds on the same few foundation models, failures and biases in those models propagate everywhere.

**Opacity:** large foundation models are poorly understood. It is hard to predict what they will do in novel situations.

**Misuse:** capable models can be used to generate misinformation, phishing content, or cyberattacks.

**Data issues:** training data contains copyrighted content, personal data, and harmful content. Legal and ethical challenges.

**Concentration of power:** training frontier models requires billions of dollars; only a few organizations can do it.

These risks are the motivation for AI safety research, alignment techniques, and regulatory frameworks.
