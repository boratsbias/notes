# Machine Translation

Machine translation (MT) is the task of automatically translating text from a source language to a target language. It is one of the oldest and most studied NLP tasks, and was a primary driver of the development of seq2seq models and Transformers.

## Problem Formulation

Given a source sentence $x = (x_1, \ldots, x_m)$, find the target sentence $y = (y_1, \ldots, y_n)$ that maximizes:

$$\hat{y} = \arg\max_y p(y | x)$$

By Bayes' rule (noisy channel model, historical):

$$p(y | x) \propto p(x | y) \cdot p(y)$$

Modern neural MT directly models $p(y | x)$ with an encoder-decoder network.

## Evaluation: BLEU Score

**BLEU (Bilingual Evaluation Understudy):** measures $n$-gram precision between the hypothesis and one or more reference translations.

**Modified $n$-gram precision:**

$$p_n = \frac{\sum_{\text{ngram} \in \hat{y}} \min(\text{count}(\text{ngram}, \hat{y}), \max_r \text{count}(\text{ngram}, r))}{\sum_{\text{ngram} \in \hat{y}} \text{count}(\text{ngram}, \hat{y})}$$

Clips counts to the maximum count in any reference.

**Brevity penalty:** penalizes translations shorter than the reference:

$$BP = \begin{cases} 1 & \text{if } c > r \\ \exp(1 - r/c) & \text{if } c \leq r \end{cases}$$

**BLEU:**

$$\text{BLEU} = BP \cdot \exp\!\left(\sum_{n=1}^N w_n \log p_n\right)$$

Typically $N = 4$, $w_n = 1/4$.

**Limitations of BLEU:** only measures surface overlap; does not account for paraphrases or meaning; low correlation with human judgments for high-quality systems.

**Alternative metrics:**

| Metric | Description |
|--------|-------------|
| METEOR | Includes stemming, synonyms, recall |
| TER | Translation edit rate; edit operations to match reference |
| chrF | Character n-gram F-score; better for morphologically rich languages |
| COMET | Neural metric; trained on human judgments; higher correlation |
| BLEURT | BERT-based learned metric |

## Statistical Machine Translation (SMT)

Pre-neural approach. Decomposes translation into:

**Phrase-based SMT:**
- **Translation model:** $p(x | y)$ learned from parallel corpora via phrase tables.
- **Language model:** $p(y)$ trained on monolingual target data.
- **Decoding:** beam search over the lattice of possible phrase translations.

Moses was the standard SMT toolkit. SMT was superseded by neural MT around 2016 due to significantly higher BLEU scores.

## Neural Machine Translation (NMT)

**Seq2seq with attention (2015-2017):** BiLSTM encoder + LSTM decoder + Bahdanau attention. First neural systems to match or exceed SMT.

**Transformer NMT (2017-present):** encoder-decoder Transformer. Replaced LSTM-based NMT within a year of publication. Standard architecture for all major MT systems.

## Training

**Parallel corpus:** sentence-aligned pairs $(x^{(i)}, y^{(i)})$ from bilingual sources: news, UN documents, Europarl, web-crawled data (CCAligned, OPUS).

**Objective:** maximize log-likelihood:

$$\mathcal{L} = \sum_{(x,y)} \sum_{t=1}^{|y|} \log p(y_t | y_{<t}, x)$$

**Teacher forcing:** during training, feed the reference target tokens as decoder input (rather than model predictions). Faster convergence but exposes the discrepancy between train and inference (exposure bias).

**Label smoothing:** instead of one-hot targets, use $(1-\epsilon)$ for the correct token and $\epsilon / (|V|-1)$ for others. Prevents overconfident predictions; improves BLEU.

## Decoding

**Greedy:** select $\arg\max p(y_t | y_{<t}, x)$ at each step. Fast; suboptimal.

**Beam search:** maintain top-$k$ hypotheses at each step. Standard for MT; $k = 4$-$8$ typical. Longer output tends to score lower (length bias); compensate with length penalty $(|y|)^\alpha$, $\alpha \approx 0.6$-$1.0$.

**Minimum Bayes Risk (MBR) decoding:** instead of maximizing probability, select the hypothesis that minimizes expected loss under the model distribution. Produces higher quality translations at the cost of generating multiple candidates.

## Low-Resource and Multilingual MT

**Transfer learning:** fine-tune a large pretrained multilingual model (mBART, NLLB, M2M-100) on low-resource language pairs.

**Back-translation:** translate monolingual target-side data into the source language (using an existing translation model) to create synthetic parallel data. Highly effective for improving NMT.

$$\text{real:} (x, y) \quad \text{synthetic:} (\hat{x}, y) \text{ where } \hat{x} = \text{MT}^{-1}(y)$$

**Multilingual NMT:** train a single model on many language pairs. A language token prefix signals the target language. Zero-shot translation between unseen pairs emerges from shared representations.

**NLLB-200 (No Language Left Behind, Meta 2022):** 200-language model; state-of-the-art for low-resource languages. Trained with a massive multilingual parallel corpus.

## Challenges

**Morphologically rich languages:** languages like Finnish or Turkish have highly inflected word forms. Subword tokenization partially addresses this.

**Document-level context:** standard NMT translates sentence by sentence. Cross-sentence coreference, discourse structure, and formality are not captured.

**Code-switching:** mixing languages within a sentence. Common in multilingual speech and social media.

**Rare words and named entities:** unknown names and technical terms may be copied unchanged (transliteration) or incorrectly translated. Copy mechanism and terminology constraints help.

**Hallucination:** NMT models sometimes generate fluent-sounding but unfaithful translations. Monitored with quality estimation models.
