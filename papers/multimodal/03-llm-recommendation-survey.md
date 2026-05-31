---
title: "A Survey on Large Language Models for Recommendation"
year: 2023
authors: Likang Wu et al.
area: Natural Language Processing, Recommendation Systems
link: https://arxiv.org/abs/2305.19860
---

## Why traditional recommenders fall short

Collaborative filtering and matrix factorization excel at behavioral pattern matching when dense interaction data is available. They fail in cold-start scenarios where a new user or item has little or no interaction history, and they cannot reason about why a recommendation fits a user's current context. They also operate on opaque ID-based item representations that contain no semantic information. LLMs bring world knowledge, reasoning capability, and language understanding that behavioral models fundamentally lack. The survey's central argument is that LLMs and collaborative filtering are complementary rather than competing paradigms, and combining them requires a principled framework.

## Two integration paradigms

The survey organizes the literature around two distinct roles an LLM can play. In the first, the LLM acts as a feature extractor: item descriptions, reviews, and user profiles are passed through the LLM to produce dense semantic embeddings, which feed into a traditional CF ranking model. The LLM improves item representation quality without replacing the behavioral ranking logic. In the second, the LLM acts as the recommender directly: user interaction history is formatted as a natural language prompt, and the LLM outputs a ranked list of items as text. This approach loses behavioral signal but gains reasoning capability, natural language explanation, and cross-domain generalization through the LLM's world knowledge. The extractor approach suits settings with dense interaction data and low-latency requirements. The recommender approach suits cold-start scenarios, explainability requirements, and cross-domain recommendations where world knowledge bridges the gap.

## Core challenges of LLM-as-recommender

Using an LLM to generate recommendations directly introduces several practical problems that purely behavioral systems avoid. Context length limits how much interaction history can be encoded, cutting off long-term user preferences. Output parsing is unreliable because the LLM generates item names as free text, which may not match catalog entries exactly and causes lookup failures. Hallucination leads the LLM to recommend items that do not exist. Knowledge staleness means new items released after the LLM's training cutoff are invisible to the model. Inference latency and cost are orders of magnitude higher than a vector retrieval query. Evaluation is also harder because standard ranking metrics like NDCG apply awkwardly to open-ended text output, and LLM-generated rankings exhibit systematic position biases that differ from those of traditional ranking models.

## Results and impact

The survey provides the first comprehensive taxonomy organizing LLM-based recommendation research into clear categories with explicit trade-off analysis. It identified the cold-start and explainability cases as the natural first deployment targets for LLM-as-recommender, while recommending the extractor paradigm for production systems where latency and scale matter. It has become the primary reference for researchers building hybrid recommendation pipelines that combine language model representations with behavioral ranking.
