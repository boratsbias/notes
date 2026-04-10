# Sequence Models

Sequence models process variable-length ordered inputs, maintaining state across time steps. They were the dominant NLP architecture before Transformers and remain relevant for streaming, low-latency, and resource-constrained settings.

## Recurrent Neural Networks (RNN)

At each time step $t$, the hidden state $h_t$ summarizes all past inputs:

$$h_t = \tanh(W_h h_{t-1} + W_x x_t + b)$$
$$y_t = W_o h_t + b_o$$

Parameters $W_h$, $W_x$ are shared across all time steps (weight tying).

**Training:** backpropagation through time (BPTT). Unroll the computation graph over $T$ steps and backpropagate. Memory scales with $T$.

**Vanishing gradients:** gradients of the loss w.r.t. early hidden states involve $\prod_{t'=t}^T W_h$. If the spectral radius $\rho(W_h) < 1$, gradients shrink exponentially. Limits effective context to $\sim$10-20 steps.

**Exploding gradients:** $\rho(W_h) > 1$ causes gradients to diverge. Fixed with gradient clipping: $g \leftarrow g \cdot \min(1, \theta / \|g\|)$.

## Long Short-Term Memory (LSTM)

Hochreiter & Schmidhuber (1997). Introduces a cell state $c_t$ as a linear memory bus, controlled by learned gates.

$$f_t = \sigma(W_f [h_{t-1}, x_t] + b_f) \quad \text{(forget gate)}$$
$$i_t = \sigma(W_i [h_{t-1}, x_t] + b_i) \quad \text{(input gate)}$$
$$\tilde{c}_t = \tanh(W_c [h_{t-1}, x_t] + b_c) \quad \text{(candidate)}$$
$$c_t = f_t \odot c_{t-1} + i_t \odot \tilde{c}_t \quad \text{(cell update)}$$
$$o_t = \sigma(W_o [h_{t-1}, x_t] + b_o) \quad \text{(output gate)}$$
$$h_t = o_t \odot \tanh(c_t)$$

**Forget gate:** how much of the previous cell state to retain.

**Input gate:** how much of the new candidate to write.

**Output gate:** what part of the cell state to expose as hidden state.

The additive cell update $c_t = f_t \odot c_{t-1} + i_t \odot \tilde{c}_t$ allows gradients to flow without repeated multiplication by the same matrix. This is the key to learning long-range dependencies.

## Gated Recurrent Unit (GRU)

Cho et al. (2014). Simplification of LSTM with two gates; no separate cell state.

$$z_t = \sigma(W_z [h_{t-1}, x_t]) \quad \text{(update gate)}$$
$$r_t = \sigma(W_r [h_{t-1}, x_t]) \quad \text{(reset gate)}$$
$$\tilde{h}_t = \tanh(W [r_t \odot h_{t-1}, x_t]) \quad \text{(candidate)}$$
$$h_t = (1 - z_t) \odot h_{t-1} + z_t \odot \tilde{h}_t$$

Fewer parameters than LSTM; comparable performance on most tasks. More amenable to efficient hardware implementation.

| Model | Parameters | Gates | Cell state | Typical use |
|-------|-----------|-------|-----------|-------------|
| Vanilla RNN | Fewest | None | No | Simple tasks |
| GRU | Medium | 2 | No | General |
| LSTM | Most | 3 | Yes | Long sequences |

## Bidirectional RNNs

Standard RNNs process sequences left to right. For tasks requiring full context (classification, NER, parsing), process the sequence in both directions and concatenate hidden states:

$$\overrightarrow{h}_t = \text{RNN}(x_t, \overrightarrow{h}_{t-1})$$
$$\overleftarrow{h}_t = \text{RNN}(x_t, \overleftarrow{h}_{t+1})$$
$$h_t = [\overrightarrow{h}_t; \overleftarrow{h}_t]$$

Cannot be used for autoregressive generation (left-to-right only).

## Encoder-Decoder (Seq2Seq)

Sutskever et al. (2014). Maps a source sequence to a target sequence of different length.

**Encoder:** reads the source and produces a context vector (the final hidden state).

$$c = h_T^{\text{enc}}$$

**Decoder:** generates the target token by token, conditioned on $c$:

$$h_t^{\text{dec}} = \text{LSTM}(y_{t-1}, h_{t-1}^{\text{dec}}, c)$$
$$p(y_t | y_{<t}, x) = \text{softmax}(W h_t^{\text{dec}})$$

**Bottleneck problem:** the entire source must compress into a single vector $c$. For long sequences, this is insufficient. Solved by attention (see [Attention Mechanisms](05-attention-mechanisms)).

**Applications:** machine translation, summarization, dialogue, code generation.

## Convolutional Sequence Models

1D convolutions over sequences. Each filter captures local patterns of fixed width $k$.

**Temporal Convolutional Network (TCN):**
- Causal convolutions (no future leakage).
- Dilated convolutions with exponentially growing dilation $d = 1, 2, 4, \ldots, 2^{L-1}$ to achieve $O(\log T)$ depth for $O(T)$ receptive field.
- Residual connections for training stability.

**Advantages over RNN:**
- Fully parallelizable over time during training.
- Stable gradients (no BPTT).
- Explicit receptive field size.

**Disadvantages:** fixed receptive field; must set network depth to cover the required context.

## State Space Models (SSM)

Recent alternative to RNNs that models sequences via a latent state transition:

$$h'(t) = A h(t) + B x(t)$$
$$y(t) = C h(t) + D x(t)$$

Discretized for sequences. The structured state space sequence model (S4) parameterizes $A$ as a special structured matrix to enable efficient $O(N \log N)$ convolution computation.

**Mamba (2023):** selective SSM where $B$, $C$, and the step size $\Delta$ depend on the input, allowing the model to selectively remember or forget. Linear time complexity at inference; competitive with Transformers on many tasks.

## Comparison with Transformers

| Property | RNN / LSTM | CNN / TCN | Transformer | SSM / Mamba |
|----------|-----------|-----------|-------------|-------------|
| Training parallelism | None (sequential) | Full | Full | Full |
| Inference per token | $O(1)$ | $O(k)$ | $O(n)$ | $O(1)$ |
| Long-range dependencies | Difficult | Fixed receptive field | Excellent | Good |
| Memory (train) | $O(T)$ | $O(T)$ | $O(T^2)$ | $O(T)$ |
| Memory (inference) | $O(d)$ | $O(d)$ | $O(T \cdot d)$ (KV cache) | $O(d)$ |

RNNs are preferred for streaming inference (constant memory, constant per-step compute), while Transformers dominate quality on offline tasks.
