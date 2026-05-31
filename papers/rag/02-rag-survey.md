# Retrieval-Augmented Generation for Large Language Models: A Survey (2024)

**Authors:** Yunfan Gao et al.
**Area:** Natural Language Processing, Survey
**Link:** [arXiv](https://arxiv.org/abs/2312.10997)

## Three generations of RAG

Naive RAG is the simplest pipeline: chunk documents into fixed-size windows, embed them with a dense encoder, store them in a vector index, retrieve the top-k chunks at query time, and pass them to the generator. This works for simple factoid questions but breaks down when retrieval quality is poor or the question requires reasoning across multiple passages. Advanced RAG adds query rewriting before retrieval, re-ranking of retrieved chunks with a cross-encoder, hybrid retrieval that combines sparse BM25 scores with dense embedding scores, and smarter chunking strategies such as semantic chunking and hierarchical chunking with summary nodes. Modular RAG treats retrieval as one step in a larger pipeline that may include iterative retrieval, self-reflection loops where the model critiques its own answer and retrieves again, tool use, and query routing across multiple specialized indexes.

## Core failure modes

Retrieval failures occur when the wrong chunks are returned (low precision), when key information is missed entirely (low recall), or when relevant information straddles a chunk boundary and neither chunk contains enough context to be useful. Generation failures occur when the model ignores retrieved context, a well-documented phenomenon called "lost in the middle" where information in the middle of a long context receives less attention than information at the edges. The model may also hallucinate facts not present in any retrieved passage, or fail to synthesize conflicting information across multiple passages. Index failures include stale indexes, poor choice of embedding model for the domain, and lack of metadata filtering to narrow retrieval.

## Evaluation with RAGAS

RAGAS provides component-level metrics that decouple retrieval quality from generation quality. Faithfulness measures whether every claim in the generated answer is supported by the retrieved context. Answer relevance measures whether the answer actually addresses the question. Context precision measures the fraction of retrieved chunks that are relevant to the query. Context recall measures whether the retrieved context contains enough information to answer the question fully. Evaluating each component independently makes it possible to pinpoint whether a failing pipeline is broken at retrieval, at generation, or at both stages.

## Results and impact

The taxonomy of naive, advanced, and modular RAG is now standard vocabulary in the research literature and in engineering practice. The survey's classification of failure modes and evaluation metrics is the primary reference for practitioners designing RAG pipelines, choosing chunking strategies, and benchmarking retrieval and generation components independently.
