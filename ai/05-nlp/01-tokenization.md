# Tokenization

Tokenization converts a raw string into a sequence of tokens that the model processes. The choice of tokenization algorithm determines the vocabulary size, the handling of rare and unseen words, and the sequence length for a given input.

## Word Tokenization

Split text on whitespace and punctuation boundaries.

**Simple split:** `"Hello, world!".split()` → `["Hello,", "world!"]`. Punctuation attached to words.

**Rule-based (Penn Treebank):** handles contractions ("don't" → "do", "n't"), possessives, punctuation. Standard for English NLP benchmarks.

**Problems:**
- Vocabulary explosion: millions of word types in large corpora.
- Out-of-vocabulary (OOV) words: unseen words at inference map to `<UNK>`.
- Morphologically rich languages (German, Finnish, Turkish) have enormous word-form spaces.

## Character Tokenization

Each character is a token. Vocabulary size $\approx$ 100-200 (ASCII/Unicode).

**Advantages:** no OOV; handles any word form; small vocabulary.

**Disadvantages:** sequences are very long (5-10$\times$ longer than word sequences); harder for models to learn word-level semantics; slow to process.

## Subword Tokenization

The modern standard. Splits words into frequently occurring subword units. Balances vocabulary size with sequence length; rare words are segmented into known subwords.

**Key insight:** frequent words remain as single tokens; rare words decompose into known subword units.

$$\text{"unhappiness"} \to [\text{"un"}, \text{"happiness"}]$$
$$\text{"tokenization"} \to [\text{"token"}, "\text{ization}"]$$

### Byte-Pair Encoding (BPE)

Start with a character-level vocabulary. Iteratively merge the most frequent adjacent pair of tokens until the target vocabulary size is reached.

**Algorithm:**
1. Initialize vocabulary with individual characters.
2. Count all adjacent token pairs in the corpus.
3. Merge the most frequent pair into a new token.
4. Repeat until vocabulary size $V$ is reached.

Vocabulary size typically 32k-64k for LLMs.

**Encoding a new string:** apply merges in the learned order (greedy).

**GPT-2 / GPT-4 tokenizer (tiktoken):** BPE over byte sequences. Every possible byte sequence is representable; no true OOV at the byte level.

### WordPiece

Similar to BPE but merges maximize the language model likelihood rather than raw frequency:

$$\text{score}(A, B) = \frac{\text{freq}(AB)}{\text{freq}(A) \times \text{freq}(B)}$$

Subword tokens after the first in a word are prefixed with `##` (e.g., "playing" → `["play", "##ing"]`).

**Used in:** BERT, DistilBERT, ELECTRA.

### SentencePiece

Language-agnostic; trains directly on raw text without pre-tokenization. Treats whitespace as a special character `▁`. Works for any language including those without spaces (Japanese, Chinese).

**Supports BPE and unigram language model** as underlying algorithms.

**Used in:** T5, XLNet, LLaMA, Mistral, mT5.

### Unigram Language Model

Maintains a large vocabulary, then prunes tokens by removing those that increase the total corpus log-likelihood least:

$$\mathcal{L} = \sum_{x \in \mathcal{D}} \log p(x) = \sum_{x \in \mathcal{D}} \log \sum_{\mathbf{s} \in S(x)} \prod_{t} p(s_t)$$

Viterbi algorithm finds the most likely segmentation. Allows multiple valid tokenizations (useful for regularization during training).

## Special Tokens

Modern tokenizers add special tokens for model conditioning:

| Token | Purpose |
|-------|---------|
| `[CLS]` | Classification token (BERT); prepended to input |
| `[SEP]` | Separator between sentences (BERT) |
| `[PAD]` | Padding to uniform sequence length |
| `[UNK]` | Unknown token (rare in BPE models) |
| `[MASK]` | Masked position for MLM training |
| `<s>`, `</s>` | Start/end of sequence (T5, LLaMA) |
| `<|endoftext|>` | End of document (GPT) |

## Vocabulary Size Tradeoffs

| Vocab size | Sequence length | Embedding size | OOV handling |
|-----------|----------------|----------------|-------------|
| Small (1k) | Very long | Small | Poor |
| Medium (32k) | Moderate | Medium | Good (subword) |
| Large (100k+) | Short | Large (more params) | Excellent |

Typical modern LLMs: 32k-200k vocabulary. LLaMA-3: 128k; GPT-4: ~100k.

## Tokenization Artifacts

- **Byte fallback:** byte-level BPE can represent any input but introduces rare byte tokens that models handle poorly.
- **Whitespace sensitivity:** "token" and " token" may be different tokens (leading space matters in BPE).
- **Number tokenization:** "100", "1", "0", "0" may be three tokens; arithmetic reasoning is harder.
- **Non-English languages:** English-centric tokenizers (GPT-2) over-segment non-Latin scripts, consuming many tokens per character.
