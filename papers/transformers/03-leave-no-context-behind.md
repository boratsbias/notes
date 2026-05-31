---
title: "Leave No Context Behind: Efficient Infinite Context Transformers with Infini-attention"
authors: "Tsendsuren Munkhdalai, Manaal Faruqui, Siddharth Gopal"
year: 2024
area: "Natural Language Processing, Long Context"
link: "https://arxiv.org/abs/2404.07143"
---

## The fixed context window problem

Standard transformers cannot attend to tokens outside their context window. When processing documents longer than the window, the only options are truncation, which discards information, or sliding window approaches, which process segments independently and lose global context. The attention computation itself scales quadratically with sequence length, making simply extending the window prohibitively expensive. The long-context problem is active: retrieval-augmented generation, legal and scientific document analysis, and multi-turn agents all require models that can reason over arbitrarily long inputs without forgetting earlier content.

## Infini-attention: compressive memory alongside local attention

Infini-attention augments standard scaled dot-product attention with a compressive memory module. The transformer is divided into segments and processes them sequentially. Within each segment, standard dot-product attention operates over local tokens exactly as in a conventional transformer. Simultaneously, each attention head maintains a fixed-size memory matrix that accumulates information from all previous segments.

Memory retrieval works by using the current segment's queries against the memory matrix to produce a retrieved context vector. Memory writing uses an associative update: the memory matrix is updated by adding the outer product of the current keys and values. Older information is not erased entirely but is overwritten proportionally, creating a compressed, lossy summary of past context. The retrieved memory output and the local attention output are combined via a learned per-head scalar gating parameter, allowing each head to balance how much it draws from distant vs. recent context.

## Constant memory footprint

The critical property of this design is that the memory matrix size is fixed regardless of how many tokens have been processed. A model can read a document of 1 million tokens or 10 million tokens with the same memory footprint for the compressive store. The local attention window size and the memory matrix size are both hyperparameters set before training, and total memory cost does not grow with document length.

## Results and impact

The paper demonstrates successful passkey retrieval in sequences exceeding 1 million tokens, a task that requires attending to a specific token injected far earlier in the input. The approach is plug-in compatible with existing transformers because the local attention layers are unchanged; Infini-attention adds memory read and write operations alongside them without restructuring the model. It represents one practical approach to the long-context problem alongside alternatives including sparse attention patterns, linear attention approximations, and state-space models such as Mamba.
