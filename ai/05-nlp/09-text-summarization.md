# Text Summarization

Text summarization condenses a document (or set of documents) into a shorter text that preserves the most important information.

## Summarization Types

**Extractive summarization:** select and concatenate sentences or phrases directly from the source document. The output is always a subset of the input text. Preserves fluency of the original; may lack coherence when stitched together.

**Abstractive summarization:** generate a new text that may contain words and phrases not in the source. More flexible and fluent; harder to train and more prone to hallucination.

**Single-document vs. multi-document:** summarize one document or multiple related documents into a single summary.

**Query-focused summarization:** the summary is conditioned on a specific question or topic, rather than summarizing the whole document.

**Aspect-based summarization:** produce summaries for specific aspects (e.g., "pros and cons" from product reviews).

## Evaluation: ROUGE

**ROUGE (Recall-Oriented Understudy for Gisting Evaluation):**

$$\text{ROUGE-N} = \frac{\sum_{\text{ref}} \sum_{\text{ngram} \in \text{ref}} \text{Count}_\text{match}(\text{ngram})}{\sum_{\text{ref}} \sum_{\text{ngram} \in \text{ref}} \text{Count}(\text{ngram})}$$

**ROUGE-1:** unigram recall.

**ROUGE-2:** bigram recall.

**ROUGE-L:** longest common subsequence (LCS); captures sentence-level structure without requiring consecutive matches.

$$\text{ROUGE-L} = \frac{\text{LCS}(r, c)}{|r|} \quad \text{(recall component)}$$

ROUGE correlates reasonably with human judgments for extractive summaries; less so for abstractive summaries.

**BERTScore:** computes semantic similarity using contextual BERT embeddings. More robust to paraphrases than ROUGE.

**G-Eval:** LLM-based evaluation rubric; strong correlation with human judgments.

## Extractive Methods

**Lead-3 baseline:** take the first 3 sentences. Strong for news articles where critical information leads.

**TextRank:** graph-based algorithm. Build a sentence similarity graph; run PageRank to find the most central sentences. Unsupervised; no training required.

**Neural extractive (SummaRuNNer, BertSum):** score each sentence independently for inclusion. Trained with binary labels (include/exclude) derived from ROUGE-greedy oracle selection.

**Oracle selection:** given $k$ sentences to select, find the subset maximizing ROUGE against the reference. Used to generate training labels; upper bounds extractive system performance.

## Abstractive Methods

### Sequence-to-Sequence with Attention

Encoder reads the document; decoder generates the summary token by token with attention over encoder states.

**Copy mechanism (pointer-network):** at each step, the decoder can either generate from the vocabulary or copy a token from the source. Critical for handling rare words (names, numbers, technical terms).

$$p(w) = p_\text{gen} \cdot p_\text{vocab}(w) + (1 - p_\text{gen}) \sum_{i: x_i = w} \alpha_i$$

where $p_\text{gen} \in [0,1]$ is a learned switch and $\alpha_i$ are attention weights over source tokens.

**Coverage mechanism:** penalizes attending to the same source tokens repeatedly to reduce repetition in the output.

### Pretrained Seq2Seq Models

**BART (Lewis et al. 2020):** denoising autoencoder pretraining. Encoder is bidirectional; decoder is causal. Pretrained objectives include token masking, deletion, text infilling, sentence permutation, document rotation. Strong out-of-the-box for summarization.

**T5:** text-to-text format. Fine-tune with input `"summarize: <document>"` and output as the reference summary.

**Pegasus (Zhang et al. 2020):** pretraining task specifically designed for summarization: Gap Sentence Generation (GSG). Randomly select and mask important sentences; the model learns to regenerate them. Achieves strong ROUGE on multiple summarization benchmarks.

**Long-document models:** standard Transformers are limited by context length.

- **Longformer:** sliding window + global attention; handles up to 16k tokens.
- **LED (Longformer Encoder-Decoder):** seq2seq version.
- **BigBird:** sparse attention for long inputs.
- **LLM-based:** GPT-4 or Claude with 100k+ context can summarize full books.

## Training Data

**CNN/DailyMail:** ~300k news articles with human-written highlights. Most studied benchmark.

**XSum (Extreme Summarization):** single-sentence summaries from BBC articles. Requires more abstraction.

**PubMed / ArXiv:** scientific papers with abstracts as reference summaries. Long documents; domain-specific vocabulary.

**SAMSum:** dialogues with manually written summaries. Tests meeting or conversation summarization.

## Challenges

**Hallucination:** the model generates facts not supported by the source. Critical issue in summarization; measured with FactCC, QAFactEval, or NLI-based faithfulness classifiers.

**Faithfulness vs. ROUGE:** a model can improve ROUGE by copying source sentences but fail to be faithful to the source's meaning. ROUGE is a poor proxy for faithfulness.

**Long document summarization:** attending to a full book or lengthy report exceeds most models' context windows. Hierarchical approaches (summarize chapters, then the chapter-level summaries) are a workaround.

**Multi-document summarization:** merging information from multiple sources while resolving redundancy and contradiction.

**Domain adaptation:** biomedical, legal, and financial texts require specialized vocabulary and writing styles different from news.
