# Retrieval Augmented Generation

Retrieval Augmented Generation (RAG) enhances language model responses by retrieving relevant documents from an external knowledge base and providing them as context. It grounds the model's output in specific, up-to-date, or private information.

## Why RAG?

**LLM limitations RAG addresses:**
- Knowledge cutoff: LLMs don't know events after their training data.
- Hallucination: grounding in retrieved text reduces fabrication.
- Private data: company documents, customer records are not in pretraining data.
- Source attribution: retrieved passages can be cited.
- Cost: cheaper to update a knowledge base than to retrain or fine-tune a model.

## Basic RAG Pipeline

```
User query
  → Query encoder (embed query)
  → Retrieve top-k documents from vector store
  → Augment prompt: [system] + [retrieved docs] + [user query]
  → LLM generates answer
  → Return answer (optionally with source citations)
```

## Indexing Phase (Offline)

**Document collection:** gather all knowledge base documents (PDFs, web pages, internal wikis, databases).

**Chunking:** split documents into chunks of 200-1000 tokens. Chunk size tradeoff: larger chunks provide more context but are less precise; smaller chunks are more targeted but may miss context.

**Chunk strategies:**
- Fixed token size with overlap.
- Sentence boundary splitting.
- Semantic chunking: split at topic shift boundaries.
- Hierarchical: store both sentence-level and paragraph-level chunks.

**Encoding:** embed each chunk with a text embedding model.

**Vector store:** index embeddings for approximate nearest neighbor (ANN) search. FAISS, Pinecone, Weaviate, Qdrant, PGVector.

## Retrieval Phase

**Dense retrieval:** embed the query; find top-$k$ chunks by cosine similarity.

**Sparse retrieval (BM25):** keyword-based TF-IDF scoring. Fast; no embeddings needed. Good for exact keyword matches.

**Hybrid retrieval:** combine dense and sparse scores (RRF: Reciprocal Rank Fusion is the standard combination method).

$$\text{RRF}(d) = \sum_{r \in R} \frac{1}{k + r(d)}$$

where $r(d)$ is the rank of document $d$ in ranker $r$, and $k = 60$ typically.

**Reranking:** after retrieving top-$k$ (e.g., $k=20$), re-rank with a cross-encoder (which sees the query and document jointly). Returns top-$m$ ($m < k$) for the LLM context. Cross-encoders are much more accurate but too slow for full corpus retrieval.

## Embedding Models

| Model | Dimension | Notes |
|-------|-----------|-------|
| OpenAI text-embedding-3-large | 3072 | Strong; proprietary |
| Cohere embed-v3 | 1024 | Multilingual; strong |
| BGE-large-en | 1024 | Strong open-source |
| E5-mistral-7b | 4096 | LLM-based embedding; state of the art |
| Nomic-embed-text | 768 | Open; context-length flexible |

**Matryoshka Representation Learning (MRL):** train embeddings so that the first $d'$ dimensions are also useful for $d' < d$. Allows dynamic dimensionality reduction without quality loss. Used in OpenAI text-embedding-3 models.

## Advanced RAG Patterns

### Query Transformation

**HyDE (Hypothetical Document Embeddings):** generate a hypothetical answer to the query; embed it; retrieve documents similar to the hypothetical answer. Often improves recall because the hypothetical answer is closer to actual document content than the raw question.

**Multi-query:** generate $n$ paraphrases of the query; retrieve for each; union the results. Improves recall at the cost of extra LLM calls.

**Step-back prompting:** reformulate a specific question into a more general one; retrieve high-level background context; then answer the original question with the context.

### Contextual Retrieval (Anthropic 2024)

Prepend a context summary to each chunk before embedding:

```
Context: This chunk is from a Q3 2024 earnings report for Acme Corp, describing operating margins.

[Original chunk text...]
```

Dramatically improves retrieval quality for chunks that are ambiguous out of context.

### Self-RAG

The model decides when to retrieve (generates a retrieval token), critiques retrieved documents (relevance token), and critiques its own response (support and utility tokens). More accurate but requires a specially fine-tuned model.

### RAPTOR (Recursive Abstractive Processing for Tree-Organized Retrieval)

Build a tree of summaries. Cluster leaf chunks; summarize each cluster; cluster the summaries; repeat. At retrieval, query both leaf and summary levels. Captures both local detail and global structure.

## RAG Evaluation

**Retrieval metrics:** context precision (fraction of retrieved chunks that are relevant), context recall (fraction of relevant chunks retrieved).

**Generation metrics:** faithfulness (does the answer follow from the context?), answer relevance (does the answer address the question?).

**RAGAS:** framework that computes faithfulness, answer relevance, context precision, and context recall using an LLM as a judge.

## RAG vs. Fine-tuning

| Aspect | RAG | Fine-tuning |
|--------|-----|-------------|
| Knowledge update | Instant (update the index) | Requires retraining |
| Factual accuracy | Higher (grounded) | Can hallucinate |
| Private data | Natural fit | Training data privacy concerns |
| Reasoning style | Unchanged | Can be adapted |
| Cost | Retrieval + inference | Training + inference |
| Latency | Higher (retrieval adds delay) | Lower |

In practice: use RAG for dynamic, factual, or private knowledge; use fine-tuning for consistent output style, specialized vocabulary, or task-specific behavior.
