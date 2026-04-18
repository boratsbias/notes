# Word Embeddings

Word embeddings map discrete tokens to dense vectors in $\mathbb{R}^d$ such that semantically similar words are close in the embedding space. They replace sparse one-hot representations ($\mathbb{R}^{\lvert V \rvert}$) with compact, information-rich vectors.

## Why Dense Embeddings?

**One-hot vectors:** $\lvert V \rvert$-dimensional, all zeros except one. No notion of similarity; "cat" and "dog" are orthogonal. Dot product of any two distinct words is zero.

**Dense embeddings:** similar words have high cosine similarity. Enable generalization across semantically related words. Pretrained embeddings transfer knowledge across tasks.

## Word2Vec

Mikolov et al. (2013). Trains a shallow neural network on a self-supervised task to produce word vectors. Two architectures:

### Skip-gram

Predict surrounding context words from the center word. For center word $w_t$ and context window $c$:

$$\max_\theta \sum_{t=1}^T \sum_{-c \leq j \leq c, j \neq 0} \log p(w_{t+j} | w_t)$$

$$p(w_O | w_I) = \frac{\exp(v_{w_O}'^T v_{w_I})}{\sum_{w=1}^V \exp(v_w'^T v_{w_I})}$$

Separate input embeddings $v_w$ and output embeddings $v_w'$.

**Negative sampling:** replaces the full softmax. For each positive pair $(w_I, w_O)$, sample $k$ random negative words $w_i^-$:

$$\mathcal{L} = \log \sigma(v_{w_O}'^T v_{w_I}) + \sum_{i=1}^k \mathbb{E}_{w_i^- \sim P_n}[\log \sigma(-v_{w_i^-}'^T v_{w_I})]$$

$P_n(w) \propto \text{freq}(w)^{3/4}$ upweights rare words.

### CBOW (Continuous Bag of Words)

Predict center word from averaged context embeddings. Faster to train; slightly lower quality than skip-gram.

### Word2Vec Properties

**Linear analogies:** $v(\text{king}) - v(\text{man}) + v(\text{woman}) \approx v(\text{queen})$

This emerges from the distributional structure of co-occurrence without any explicit supervision.

**Subsampling:** frequent words (the, is, a) are downsampled during training with probability $P(\text{discard}) = 1 - \sqrt{t/f}$.

## GloVe (Global Vectors)

Penington et al. (2014). Learns embeddings from the global word-word co-occurrence matrix $X$ directly.

**Objective:** for co-occurrence count $X_{ij}$ of words $i$ and $j$:

$$\mathcal{L} = \sum_{i,j=1}^V f(X_{ij})(w_i^T \tilde{w}_j + b_i + \tilde{b}_j - \log X_{ij})^2$$

Weighting function: $f(x) = (x/x_\text{max})^\alpha$ for $x < x_\text{max}$, else 1. Reduces weight of very frequent pairs ($\alpha = 3/4$, $x_\text{max} = 100$).

GloVe and Word2Vec produce similar quality embeddings. GloVe is easier to train in parallel.

## fastText

Bojanowski et al. (2017). Extends Word2Vec by representing each word as a bag of character n-grams.

$$v(w) = \sum_{g \in G(w)} z_g$$

For "where": character 3-grams = `{<wh, whe, her, ere, re>}` plus the full token `<where>`.

**Advantages:**
- Handles OOV words: unseen words are represented via their subword components.
- Better for morphologically rich languages.
- Improves representations for rare words.

## Contextualized Embeddings

Word2Vec/GloVe produce a single static vector per word. "Bank" gets one vector regardless of context (riverbank vs. financial bank).

**Contextualized embeddings** produce a different vector for each occurrence based on surrounding context. These emerge from the hidden states of language models.

### ELMo (Embeddings from Language Models)

Bidirectional LSTM language model. The embedding for a token is a learned weighted sum of all LSTM layer representations:

$$\text{ELMo}_k = \gamma \sum_{j=0}^L s_j h_{k,j}$$

where $s_j$ are softmax-normalized task-specific scalars and $\gamma$ is a scaling factor. The first layer captures syntax; higher layers capture semantics.

### BERT Hidden States

Each token's hidden state from BERT is a contextualized embedding. Common strategies:
- Use the `[CLS]` token representation for sentence-level tasks.
- Average last 4 layers for word-level tasks.
- Fine-tune end-to-end for maximum performance.

### Sentence Embeddings

Fixed-size vector for an entire sentence or document.

**Sentence-BERT (SBERT):** fine-tunes BERT with a siamese network on sentence pairs using cosine similarity loss. Produces semantically meaningful sentence embeddings in $O(1)$ (no cross-attention at inference).

**SimCSE:** contrastive learning with dropout-based augmentation. Two forward passes of the same sentence with different dropout masks form a positive pair.

## Embedding Evaluation

**Intrinsic:**
- **Word similarity:** compare cosine similarity of word pairs against human judgments (SimLex-999, WordSim-353). Pearson/Spearman correlation.
- **Analogy tasks:** $a : b :: c : ?$ (Google analogy dataset). Accuracy of $v(a) - v(b) + v(c)$ nearest neighbor.

**Extrinsic:** downstream task performance (NER, text classification, QA).

## Embedding Dimensionality

Typical $d$: 100-300 for Word2Vec/GloVe; 768-4096 for Transformer hidden states.

There is a tradeoff: higher $d$ captures more information but requires more parameters and training data.

**Dimension reduction for visualization:** t-SNE or UMAP on embeddings reveals semantic clusters.

## Bias in Embeddings

Embeddings trained on biased corpora encode social biases. Classic example:

$$v(\text{man}) - v(\text{woman}) \approx v(\text{programmer}) - v(\text{homemaker})$$

**Debiasing:** Hard debiasing (Bolukbasi et al.): project out the gender direction from gender-neutral words. Soft debiasing: regularize during training. Ongoing research area.
