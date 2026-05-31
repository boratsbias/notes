# DistilBERT: A Distilled Version of BERT (2019)

**Authors:** Victor Sanh, Lysandre Debut, Julien Chaumond, Thomas Wolf
**Area:** Natural Language Processing, Model Compression
**Link:** [arXiv](https://arxiv.org/abs/1910.01108)

## The general distillation approach

TinyBERT distills a task-specific fine-tuned teacher into a student for each downstream task individually. DistilBERT takes a different position: distill once at the pre-training stage on the full language modeling corpus, producing a general-purpose compressed model that can then be fine-tuned on any downstream task exactly like BERT. This is simpler to apply in practice because there is no per-task distillation step and no need for data augmentation. The resulting model is a drop-in replacement for BERT-base in any fine-tuning pipeline.

## Architecture and initialization

DistilBERT uses 6 transformer layers instead of BERT-base's 12, while keeping the same hidden dimension of 768 and the same 12 attention heads per layer. Halving the depth reduces parameter count by 40%. The token-type embeddings are removed since they are rarely used. Critically, the student is initialized by copying every other layer of the pre-trained BERT teacher rather than starting from random weights. This warm start avoids the instability of training a transformer from scratch and significantly accelerates convergence.

## Three combined training losses

Pre-training combines three losses. The masked language model loss is cross-entropy on masked token predictions, identical to standard BERT pre-training, which ensures the student learns from the raw data signal. Soft label distillation is KL divergence between the student and teacher output probability distributions at high temperature, transferring the dark knowledge about which tokens are plausible alternatives. Cosine embedding loss encourages the student's hidden state vectors to be directionally aligned with the teacher's at each layer, ensuring the geometric structure of the representation space is preserved. TinyBERT uses MSE to match magnitude; DistilBERT uses cosine similarity to match direction. Both constraints push the student's internal representations to structurally mirror the teacher's, but the cosine formulation is more robust to differences in scale.

## Results and impact

DistilBERT retains 97% of BERT-base's performance on GLUE while running 60% faster and using 40% fewer parameters. It became the standard lightweight BERT for production NLP and is among the most downloaded models in the Hugging Face ecosystem, used widely in search, classification, and extraction pipelines where latency and cost matter.
