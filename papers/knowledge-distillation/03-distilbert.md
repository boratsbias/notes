# DistilBERT: A Distilled Version of BERT (2019)

**Authors:** Victor Sanh, Lysandre Debut, Julien Chaumond, Thomas Wolf
**Area:** Natural Language Processing, Model Compression
**Link:** [arXiv](https://arxiv.org/abs/1910.01108)

## What the paper argues

BERT is expensive to serve at scale. DistilBERT shows that a 40% smaller BERT can be trained via knowledge distillation during pre-training to retain 97% of BERT's capability while being 60% faster at inference. Critically, distillation happens at the general pre-training stage, not per task, so the result is a general-purpose smaller model that can be fine-tuned on any task.

## Architecture

DistilBERT keeps the same architecture as BERT but removes half the layers:

```
BERT-base:    12 layers, 768 hidden, 12 heads  →  110M params
DistilBERT:    6 layers, 768 hidden, 12 heads  →   66M params
```

Student is initialized by copying every other layer from the teacher. This warm start speeds up convergence significantly.

## Triple loss

Three losses are combined during pre-training:

```
L_mlm:    cross-entropy on masked token prediction  (same as BERT)
L_soft:   KL divergence between student and teacher output distributions
L_cos:    cosine embedding loss between student and teacher hidden states
```

L_soft transfers the teacher's probability distributions (dark knowledge). L_cos aligns the hidden state geometry between student and teacher. The combination is more effective than any single loss alone.

## Results and impact

DistilBERT retains 97% of BERT performance on GLUE, runs 60% faster, and uses 40% fewer parameters. It became one of the most widely deployed transformer models due to its practical size-quality trade-off. The Hugging Face release alongside the transformers library made it the default lightweight BERT for production NLP.
