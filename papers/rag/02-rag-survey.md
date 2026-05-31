# Retrieval-Augmented Generation for Large Language Models: A Survey (2024)

**Authors:** Yunfan Gao et al.
**Area:** Natural Language Processing, Survey
**Link:** [arXiv](https://arxiv.org/abs/2312.10997)

## What the paper argues

RAG has evolved rapidly since the original 2020 paper. This survey organizes the research into three generations and provides a taxonomy of components, failure modes, and evaluation approaches for practitioners building RAG systems.

## Three generations of RAG

```
Naive RAG       →   chunk docs  →  embed  →  retrieve top-k  →  generate
                    (simple but suffers from low retrieval precision)

Advanced RAG    →   + query rewriting, re-ranking, hybrid retrieval, better chunking
                    (fixes retrieval quality problems)

Modular RAG     →   + iterative retrieval, self-reflection, tool use, query routing
                    (treats retrieval as one step in a flexible agentic pipeline)
```

## Core failure modes

**Retrieval failures:** wrong chunks retrieved (low precision), key information missed (low recall), information split across chunk boundaries (chunking artifacts).

**Generation failures:** model ignores retrieved content ("lost in the middle"), hallucinates facts not in the retrieved passages, fails to synthesize across multiple passages.

**Index failures:** stale index, poor embedding model, no metadata filtering.

## Evaluation framework

The survey reviews RAGAS metrics which evaluate RAG components independently:

```
Faithfulness:         is the answer supported by the retrieved context?
Answer relevance:     does the answer actually address the question?
Context precision:    are the retrieved chunks relevant?
Context recall:       does the context contain the answer?
```

## Results and impact

The taxonomy of naive, advanced, and modular RAG is now standard terminology. The survey is the primary reference for researchers and engineers designing RAG pipelines and choosing between retrieval strategies.
