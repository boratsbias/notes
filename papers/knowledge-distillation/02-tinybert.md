# TinyBERT: Distilling BERT for Natural Language Understanding (2019)

**Authors:** Xiaoqi Jiao et al.
**Area:** Natural Language Processing, Model Compression
**Link:** [arXiv](https://arxiv.org/abs/1909.10351)

## Why output-only distillation is insufficient for BERT

The standard Hinton distillation approach trains the student to match the teacher's final output distribution. For BERT, this means only the softmax over vocabulary at masked positions or over classes at the [CLS] token. This ignores the rich intermediate representations that BERT builds up across 12 transformer layers: the attention patterns encoding syntactic structure, the hidden states encoding semantic features, and the embedding representations at the input. Matching only the output is like trying to learn a craft by looking only at the finished product. TinyBERT argues for layer-wise distillation that forces the student to internalize how the teacher processes language, not just what it ultimately predicts.

## Three layer-wise distillation losses

TinyBERT distills three types of information at each layer. Attention matrix distillation computes mean squared error between the student's attention weight matrices and the corresponding teacher attention matrices at mapped layers; this transfers syntactic and structural patterns encoded in where each head attends. Hidden state distillation computes MSE between the student's hidden state vectors and the teacher's, after projecting the student's smaller-dimensional states up to the teacher's dimension with a learned linear layer. Embedding distillation applies MSE at the input embedding layer. Since the student has fewer layers than the teacher, a fixed mapping assigns each student layer to a teacher layer; BERT-base has 12 layers at 768 dimensions, while TinyBERT typically uses 4 layers at 312 dimensions.

## Two-stage training

TinyBERT trains in two stages. General distillation runs on a large unlabeled text corpus, transferring BERT's general language representations before any task-specific fine-tuning. Task-specific distillation then fine-tunes the teacher on the downstream task, uses data augmentation to expand the labeled set (replacing words with BERT's top-k predictions for each masked position to generate new training examples), and distills the fine-tuned teacher into the student on the augmented task data.

## Results and impact

TinyBERT achieves 96.8% of BERT-base performance on the GLUE benchmark at 7.5 times faster inference and with 9 times fewer parameters. It demonstrated that intermediate-layer distillation is far more effective than output-only distillation for transformer models and set the direction for subsequent compression work on large language models.
