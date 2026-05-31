# BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding (2018)

**Authors:** Jacob Devlin, Ming-Wei Chang, Kenton Lee, Kristina Toutanova
**Area:** Natural Language Processing, Pre-training
**Link:** [arXiv](https://arxiv.org/abs/1810.04805)

## The directionality problem

The two dominant pre-training approaches before BERT shared a fundamental flaw: neither could look at both sides of a word simultaneously when building its representation. GPT processed text strictly left-to-right, so each token's representation incorporated only its left context. ELMo trained a forward and a backward LSTM independently, then concatenated their outputs. Concatenation is not joint conditioning: the forward model never attends to the right context during its own training, and the backward model never attends to the left. BERT argues that **true bidirectional attention**, where every token attends to every other token at every layer simultaneously, produces substantially richer representations. Understanding "bank" in "I deposited money at the bank on the river bank" requires seeing both sides at once.

## Masked Language Modeling

The obstacle to bidirectional pre-training is that a standard language model objective becomes trivial if a token can attend to itself: the model simply copies the input. BERT solves this with **Masked Language Modeling (MLM)**: randomly select 15% of input tokens and train the model to predict their identities from the surrounding context. Because masked tokens cannot attend to their own ground-truth values, the model must reason bidirectionally. The selected 15% are not all replaced with a [MASK] symbol. The **80/10/10 strategy** replaces 80% with [MASK], substitutes 10% with a random vocabulary word, and leaves 10% unchanged. This prevents the model from learning that only [MASK] tokens require reasoning about, keeping all token representations informative at fine-tuning time when no masking occurs.

## Next Sentence Prediction and model sizes

Many downstream tasks require understanding relationships between pairs of sentences. BERT adds a **Next Sentence Prediction (NSP)** auxiliary task: given two sentences, predict whether the second actually follows the first in the source document. This pushes the model to learn inter-sentence coherence during pre-training, which helps tasks like question answering and natural language inference. BERT was released in two sizes: **BERT-base** with 12 transformer layers and 110 million parameters, and **BERT-large** with 24 layers and 340 million parameters. Both were trained on BooksCorpus and English Wikipedia.

## Fine-tuning paradigm

BERT's adaptation to downstream tasks is deliberately minimal. A special [CLS] token is prepended to every input. For classification tasks, a single linear layer over the [CLS] representation is added and the entire model is fine-tuned end-to-end. For span extraction tasks like SQuAD, start and end classifiers are added over the token representations. The same pretrained weights serve as the initialization for every downstream task.

## Results and impact

BERT achieved state of the art on 11 NLP benchmarks simultaneously at release, including the full GLUE suite, SQuAD 1.1 and 2.0, and named entity recognition tasks. The margins over prior work were large enough to shift the entire field toward bidirectional pre-training. It became the direct ancestor of RoBERTa, which demonstrated that more data and longer training with MLM alone outperforms NSP, ALBERT, which factorized the embedding matrix to reduce parameters, DistilBERT, which distilled BERT into a smaller model, and T5, which reframed all NLP tasks as text-to-text generation on top of a pretrained encoder-decoder.
