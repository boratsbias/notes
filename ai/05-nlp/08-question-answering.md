# Question Answering

Question answering (QA) is the task of automatically producing an answer to a natural language question. It encompasses a range of subtasks depending on the knowledge source, answer format, and reasoning required.

## QA Variants

| Type | Description | Example |
|------|-------------|---------|
| Extractive QA | Answer is a span from a given passage | SQuAD |
| Abstractive QA | Answer is generated, not extracted | ELI5, NarrativeQA |
| Open-domain QA | Retrieve relevant documents, then answer | TriviaQA, Natural Questions |
| Closed-book QA | Answer from model's parameters alone | no retrieval |
| Knowledge base QA | Answer by querying a structured KB | KGQA over Freebase |
| Visual QA (VQA) | Answer about an image | VQA v2 |
| Multi-hop QA | Requires reasoning across multiple facts | HotpotQA, 2WikiMultihopQA |

## Extractive QA

Given a passage (context) $p$ and a question $q$, find the answer span $(s, e)$ such that $p[s:e]$ is the answer.

**BERT-based approach (default baseline):**

1. Concatenate `[CLS] question [SEP] context [SEP]`.
2. Run through BERT; get token representations $H \in \mathbb{R}^{n \times d}$.
3. Predict start and end positions:

$$P_s = \text{softmax}(H \cdot w_s), \quad P_e = \text{softmax}(H \cdot w_e)$$

4. Extract span $p[\hat{s}:\hat{e}]$ where $\hat{s} = \arg\max P_s$, $\hat{e} = \arg\max P_e$.

**SQuAD 1.1:** 100k questions over Wikipedia; every question has an answer span. EM (exact match) and F1 (token overlap) are standard metrics.

**SQuAD 2.0:** adds 50k unanswerable questions. Model must also predict whether the question is answerable.

**Current state of the art:** fine-tuned DeBERTa-v3 exceeds human performance on SQuAD 1.1.

## Open-Domain QA

No passage is provided. The model must retrieve relevant evidence from a large corpus (Wikipedia, the web) before answering.

**Two-stage pipeline (Retrieve then Read):**

1. **Retriever:** given question $q$, retrieve top-$k$ passages from the corpus.
2. **Reader:** given $q$ and retrieved passages, extract or generate the answer.

### Retrieval Methods

**TF-IDF / BM25:** sparse retrieval. Fast; strong baseline for factoid questions.

**Dense Passage Retrieval (DPR):** bi-encoder architecture. Encode questions and passages independently with separate BERT encoders; retrieve by maximum inner product search (MIPS).

$$\text{sim}(q, p) = E_Q(q)^T E_P(p)$$

Trained with in-batch negatives: one positive passage and all other passages in the batch as negatives.

**Approximate nearest neighbor (ANN):** FAISS index over millions of passage embeddings enables sub-millisecond retrieval.

**Hybrid retrieval:** combine sparse (BM25) and dense (DPR) scores. Often outperforms either alone.

### Retrieval-Augmented Generation (RAG)

Lewis et al. (2020). Integrate retrieval into a generative model.

$$p(y | x) = \sum_{z \in \text{top-}k} p(z | x) \cdot p(y | x, z)$$

The retriever and reader are trained end-to-end (or the retriever is fixed). The generator (BART, T5, or an LLM) produces abstractive answers conditioned on the retrieved passages.

RAG is the standard architecture for knowledge-intensive generation tasks and enterprise chat systems.

## Closed-Book QA

The language model answers from its parametric knowledge alone, without access to external documents.

**GPT-3 few-shot:** given a few (question, answer) examples, generates the answer in a forward pass. Surprisingly effective for world-knowledge questions.

**T5 closed-book (Roberts et al. 2020):** fine-tune T5 on QA pairs without providing any context. Shows that LLMs store substantial factual knowledge.

**Limitations:** knowledge is frozen at training time; cannot be updated without retraining. LLMs hallucinate when queried beyond their training data.

## Multi-Hop Reasoning

Requires chaining multiple pieces of evidence.

**Example (HotpotQA):** "What year was the director of *Film A* born?" requires finding the director of Film A, then finding their birth year.

**Approaches:**
- **Iterative retrieval:** retrieve, read, reformulate question, retrieve again.
- **Chain-of-thought prompting:** instruct the LLM to reason step by step before answering.
- **Graph-based:** build an entity graph over retrieved passages; apply graph neural networks.

## Knowledge Base QA

Answer questions by querying a structured knowledge graph (Freebase, Wikidata, DBpedia).

**Semantic parsing:** convert natural language to a formal query (SPARQL, S-expression).

**Entity linking:** identify entities in the question and link to KB nodes.

**Embedding-based:** embed entities and relations; answer by nearest-neighbor search over the graph.

## Evaluation

**Exact Match (EM):** 1 if the predicted answer string matches any reference answer exactly (after normalization: lowercase, strip articles/punctuation).

**Token-level F1:** harmonic mean of precision and recall over the word overlap between prediction and reference.

**ROUGE-L:** longest common subsequence for abstractive QA.

**Human evaluation:** for open-ended or multi-sentence answers where automated metrics correlate poorly.

## Challenges

**Unanswerable questions:** model must abstain rather than hallucinate an answer.

**Multi-document reasoning:** answer may require synthesizing information from multiple retrieved documents.

**Temporal knowledge:** facts change over time; models trained on old data give stale answers.

**Numerical and arithmetic reasoning:** questions like "How many more X than Y?" require counting or arithmetic over extracted values.

**Long-form answers:** many real questions require multi-paragraph answers, not a single span.
