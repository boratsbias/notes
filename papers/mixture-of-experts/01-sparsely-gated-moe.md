# Outrageously Large Neural Networks: The Sparsely-Gated Mixture-of-Experts Layer (2017)

**Authors:** Noam Shazeer, Azalia Mirhoseini, Krzysztof Maziarz, Andy Davis, Quoc Le, Geoffrey Hinton, Jeff Dean
**Area:** Deep Learning, Scalability
**Link:** [arXiv](https://arxiv.org/abs/1701.06538)

## What the paper argues

In a dense model, doubling parameters doubles compute per forward pass. MoE breaks this coupling: a large bank of expert sub-networks is trained, but each input token is routed to only a small subset. The model grows in capacity without proportionally growing in compute.

## The MoE layer

Each MoE layer contains E experts (feed-forward networks). A gating network selects top-k experts per token:

```
Token h
  ↓
Gating: G(h) = softmax( h · W_g + noise )
  ↓
Select top-k experts by gate score
  ↓
Output = Σ_{i ∈ top-k} G_i(h) · Expert_i(h)
```

Noise is added to the gate logits during training to encourage exploration and prevent a few experts from monopolizing all tokens.

For k=1 (Switch Transformer style), each token routes to a single expert. For k=2 (Mixtral style), two experts contribute weighted outputs.

## Load balancing

Without constraints, the gating network collapses: a few experts receive most tokens and others are never trained. An auxiliary load-balancing loss penalizes uneven routing:

```
L_balance = w_importance · CV(Importance)² + w_load · CV(Load)²
```

where CV is coefficient of variation (standard deviation / mean). This encourages all experts to receive similar total weight and token counts.

## Results and impact

Demonstrated 1000x capacity increases with only 2x compute increase on language modeling. Established the MoE architecture used by Switch Transformer, Mixtral, and likely GPT-4. The load balancing problem it identified remains an active research area.
