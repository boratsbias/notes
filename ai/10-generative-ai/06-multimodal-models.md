# Multimodal Models

Multimodal models process and generate content across multiple modalities: text, images, audio, video, and structured data. They enable richer human-computer interaction and understanding of the real world.

## Modality Combinations

| Input | Output | Example models |
|-------|--------|---------------|
| Text | Text | GPT-4, Claude, LLaMA |
| Image + Text | Text | GPT-4V, Claude 3, LLaVA |
| Text | Image | DALL-E 3, Midjourney, Stable Diffusion |
| Image + Text | Image | InstructPix2Pix, SDXL |
| Audio | Text | Whisper, Gemini |
| Text | Audio | TTS models, AudioPaLM |
| Video + Text | Text | Gemini 1.5, GPT-4o |
| Text | Video | Sora, Runway Gen-3 |
| Any | Any | GPT-4o, Gemini 1.5, Claude 3.5 |

## Vision-Language Models

The most developed multimodal category. See [Multimodal Vision Models](../06-computer-vision/10-multimodal-vision-models) for technical details.

**Key architectures:**
- **CLIP:** contrastive image-text pretraining. Produces aligned image/text embeddings.
- **BLIP-2 / InstructBLIP:** frozen visual encoder + Q-Former + frozen LLM.
- **LLaVA:** visual encoder + linear/MLP projection + instruction-tuned LLM.
- **GPT-4V / Gemini:** natively multimodal from pretraining.

**Capabilities:**
- Image description and captioning.
- Visual question answering.
- Document understanding (OCR, chart reading, table extraction).
- Spatial reasoning (object locations, relative positions).
- Diagram and code screenshot interpretation.

## Audio Understanding and Generation

**ASR (Automatic Speech Recognition):** transcribe spoken audio to text.

**Whisper (OpenAI 2022):** encoder-decoder Transformer trained on 680k hours of labeled speech. State-of-the-art open-source ASR. Supports 99 languages. Zero-shot translation to English.

**Speaker diarization:** who spoke when in a multi-speaker recording.

**TTS (Text-to-Speech):** generate natural speech from text. Neural TTS (ElevenLabs, OpenAI TTS) produces human-like voices.

**AudioPaLM:** integrates speech into PaLM via audio tokens. Handles speech translation and spoken Q&A.

**MusicGen (Meta):** generate music from text descriptions.

## Video Models

**Video understanding:** temporal reasoning over sequences of frames. See [Video Understanding](../06-computer-vision/08-video-understanding).

**Gemini 1.5 Pro:** processes video natively as a sequence of frames + audio. 1M token context allows understanding full-length videos.

**Video generation:**
- **Sora (OpenAI 2024):** text-to-video up to 1 minute; spatially and temporally coherent. DiT-based diffusion.
- **Runway Gen-3 Alpha:** high-quality video generation; cinematic quality.
- **Stable Video Diffusion:** image-to-video.
- **CogVideoX:** open-source video generation model.

## Document Understanding

Multimodal models that process documents as images (preserving layout, tables, charts):

**Nougat (Meta):** parse academic PDFs to structured Markdown including LaTeX equations.

**GPT-4V / Claude 3:** can read tables, extract data from charts, and understand infographics directly from image input.

**Document question answering:** extract specific fields from invoices, contracts, or forms.

## Interleaved Multimodal Inputs

Modern models like Gemini 1.5 and GPT-4o accept arbitrarily interleaved sequences of text, images, and other modalities in a single context:

```
User: [image1] What's the difference between these two charts? [image2]
```

This enables: comparing multiple images, analyzing video frames with commentary, referencing figures in a document.

## Native Multimodality vs. Retrofit

**Retrofit (most VLMs):** start with a pretrained LLM; attach a pretrained vision encoder; train the connection layer (projection MLP, Q-Former). Fast; leverages existing LLM capability.

**Native multimodal:** train from scratch on mixed text+image (+ audio/video) data. Deeper integration; better at tasks requiring tight cross-modal reasoning. Gemini, GPT-4o.

**Emergent cross-modal reasoning:** natively multimodal models can reason about sound from a video scene, infer 3D structure from 2D images, and relate text descriptions to specific image regions in ways that retrofit models struggle with.

## Evaluation

**VQAv2, GQA, TextVQA:** visual question answering benchmarks.

**MMBench, MMMU:** broad multimodal capabilities.

**OCRBench:** OCR and document understanding.

**Video-MME:** video understanding evaluation.

**Human evaluation:** for open-ended tasks (describe this image; compare these videos), automated metrics are weak. Human side-by-side evaluation or LLM-as-judge are common.
