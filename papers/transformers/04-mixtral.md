# Mixtral of Experts (2024)

**Authors:** Mistral AI
**Area:** Large Language Models, Mixture of Experts
**Link:** [arXiv](https://arxiv.org/abs/2401.04088)

## What the paper argues

Scaling a dense language model increases inference cost proportionally. Mixtral shows that replacing each feed-forward layer with a sparse mixture of 8 experts, where each token only activates 2, gives a 46.7B parameter model that uses only 12.9B parameters per forward pass. More capacity, same compute.

## Sparse expert routing

In each transformer block, the feed-forward sublayer is replaced by 8 expert FFN networks. A gating network selects top-2 experts per token:

```
Token hidden state  →  gating network  →  softmax scores over 8 experts
                                                    ↓
                                   select top-2 experts by score
                                                    ↓
         output = score_1 · Expert_1(x) + score_2 · Expert_2(x)
```

The 6 unselected experts do no computation for that token. Across a batch, different tokens route to different experts. Load-balancing auxiliary loss penalizes uneven expert utilization during training.

## Sliding window attention

Mixtral also uses sliding window attention: each token attends to at most W previous tokens rather than all previous tokens. This reduces attention memory from O(n²) to O(n · W). At 4096 window size, a 32k context is processed at a fraction of full-attention cost.

## Results and impact

Mixtral 8x7B outperforms LLaMA 2 70B and GPT-3.5 on most benchmarks while running 6x faster at inference. Mistral released the weights publicly, making it one of the most capable open-weight models at the time and demonstrating that MoE is practically viable at 7B-equivalent compute cost.
