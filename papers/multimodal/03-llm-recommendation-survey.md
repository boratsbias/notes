# A Survey on Large Language Models for Recommendation (2023)

**Authors:** Likang Wu et al.
**Area:** Natural Language Processing, Recommendation Systems
**Link:** [arXiv](https://arxiv.org/abs/2305.19860)

## What the paper argues

Traditional recommender systems (collaborative filtering, matrix factorization) excel at behavioral pattern matching but fail at cold-start, novel items, and reasoning about why a recommendation fits. LLMs bring world knowledge, reasoning, and language understanding. This survey argues that LLMs and traditional recommendation systems are complementary, and organizes the research landscape for combining them.

## Two integration paradigms

```
LLM as feature extractor:
  item description  →  LLM encoder  →  item embedding  →  fed into CF model
  (LLM improves item representation, not the ranking logic)

LLM as recommender:
  user history + task description  →  LLM  →  ranked item list (as text)
  (LLM does the full recommendation in a prompt)
```

The first approach keeps the collaborative filtering core and improves item representations. The second replaces CF entirely but loses behavioral signal.

## Core challenges of LLM-as-recommender

```
Context length:   long interaction histories don't fit in the context window
Output parsing:   LLM generates item names, which may not match catalog exactly
Hallucination:    LLM recommends items that don't exist in the catalog
Staleness:        LLM knowledge is frozen; new items are unknown
Latency/cost:     LLM inference is far more expensive than a vector lookup
```

## When LLMs help most

LLMs perform best relative to CF on:
- **Cold-start:** new users or items with no interaction history (LLM uses content signals)
- **Explainability:** generating natural language explanations for recommendations
- **Cross-domain:** items that benefit from world knowledge (e.g. books, movies, travel)

CF outperforms LLMs on dense interaction data where behavioral patterns dominate.

## Results and impact

The survey provided the first comprehensive taxonomy of LLM-based recommendation research and the standard framework for thinking about when and how to integrate LLMs into recommender systems. It is the primary reference for researchers building hybrid recommendation pipelines.
