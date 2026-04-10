# Transformers

The Transformer (Vaswani et al. 2017, "Attention Is All You Need") replaces recurrence entirely with stacked self-attention layers. It is the dominant architecture for NLP, vision, audio, and multimodal models.

## Architecture Overview

The original Transformer is an encoder-decoder model for sequence-to-sequence tasks. Modern usage separates the encoder and decoder into independent architectures.

```
Input tokens
  → Token embeddings + Positional encoding
  → Encoder stack (N layers)
      → Multi-Head Self-Attention
      → Add & Norm
      → Feed-Forward Network
      → Add & Norm
  → Encoder output

Target tokens (shifted right)
  → Token embeddings + Positional encoding
  → Decoder stack (N layers)
      → Masked Multi-Head Self-Attention
      → Add & Norm
      → Cross-Attention (Q from decoder, K/V from encoder)
      → Add & Norm
      → Feed-Forward Network
      → Add & Norm
  → Linear + Softmax → output distribution
```

## Transformer Layer

Each encoder layer consists of two sub-layers.

### Multi-Head Self-Attention

Described in [Attention Mechanisms](05-attention-mechanisms). Each token's representation is updated as a weighted sum of all other token representations.

### Feed-Forward Network (FFN)

Applied position-wise (independently to each token):

$$\text{FFN}(x) = \max(0, x W_1 + b_1) W_2 + b_2$$

Dimension: $d_\text{model} \to d_\text{ff} \to d_\text{model}$, where $d_\text{ff} = 4 d_\text{model}$ typically.

This is where most of the model's "knowledge" is stored. Can be interpreted as a key-value memory: the first layer selects patterns, the second layer outputs values.

**SwiGLU FFN (used in LLaMA, PaLM):**

$$\text{FFN}_\text{SwiGLU}(x) = (\text{SiLU}(x W_1) \odot x W_3) W_2$$

Adds a gating mechanism. Empirically outperforms ReLU FFN at the same parameter count.

### Layer Normalization

**Post-LN (original paper):** LayerNorm applied after residual addition:

$$x \leftarrow \text{LayerNorm}(x + \text{Sublayer}(x))$$

**Pre-LN (most modern models):** LayerNorm before the sublayer:

$$x \leftarrow x + \text{Sublayer}(\text{LayerNorm}(x))$$

Pre-LN is more stable to train without warmup; preferred in large models.

**RMSNorm:** simplifies LayerNorm by removing the mean-centering term:

$$\text{RMSNorm}(x) = \frac{x}{\text{RMS}(x)} \odot g, \quad \text{RMS}(x) = \sqrt{\frac{1}{d}\sum_i x_i^2}$$

Faster and equally effective. Used in LLaMA, Mistral, T5.

## Encoder-Only Models (BERT family)

Bidirectional encoder. Uses all tokens as context for each position.

**BERT (Devlin et al. 2018):**
- Pretraining: Masked LM (predict 15% randomly masked tokens) + Next Sentence Prediction.
- Input: `[CLS] sentence A [SEP] sentence B [SEP]`.
- Fine-tuning: add a classification head on `[CLS]` for sequence tasks; token-level head for tagging tasks.

**RoBERTa:** BERT without NSP; trained longer on more data with larger batches and dynamic masking. Significantly outperforms BERT.

**DeBERTa:** disentangled attention over content and position; uses virtual adversarial training. State-of-the-art encoder for many benchmarks.

**ELECTRA:** replaced token detection pretraining. A generator corrupts tokens; the discriminator classifies each token as real or replaced. Much more efficient than BERT.

## Decoder-Only Models (GPT family)

Causal (left-to-right) decoder. Used for generation; fine-tuned with RLHF for instruction following.

**GPT-2 (2019):** 1.5B parameters; trained on WebText. Demonstrated zero-shot text generation.

**GPT-3 (2020):** 175B parameters; demonstrated strong few-shot in-context learning.

**GPT-4 (2023):** multimodal; significantly improved reasoning and instruction following.

**LLaMA family (Meta):** open-weight decoder-only models. LLaMA-3 (2024): 8B/70B/405B; 128k vocabulary; grouped query attention; 8k+ context.

**Mistral 7B:** sliding window attention; grouped query attention; outperforms LLaMA 7B.

## Encoder-Decoder Models (T5 family)

Full encoder-decoder. Reframe all NLP tasks as text-to-text: input and output are both text strings.

**T5 (Raffel et al. 2020):** "Text-to-Text Transfer Transformer". Pretraining: span denoising (mask spans, predict them). Fine-tuning: task prompt prepended to input.

**BART:** denoising autoencoder pretraining. Encoder reads corrupted text; decoder reconstructs original. Strong on summarization and generation.

**mT5:** multilingual T5 trained on 101 languages.

## Positional Encoding

See [Attention Mechanisms](05-attention-mechanisms) for RoPE, ALiBi, and sinusoidal encodings.

## Key Hyperparameters

| Hyperparameter | Typical range | Effect |
|---------------|--------------|--------|
| $N$ (layers) | 12-96 | Depth; more capacity |
| $d_\text{model}$ | 768-12288 | Width; representation size |
| $h$ (heads) | 12-96 | Attention diversity |
| $d_\text{ff}$ | $4 d_\text{model}$ | FFN capacity |
| Context length | 512-128k+ | Maximum input length |

## Efficient Transformer Variants

**Grouped Query Attention (GQA):** multiple query heads share the same key/value heads. Reduces KV cache memory at inference. Used in LLaMA-3, Mistral.

**Multi-Query Attention (MQA):** all query heads share a single key/value head. Maximum memory savings; slight quality loss.

**Mixture of Experts (MoE):** replace the dense FFN with a sparse combination of $E$ expert FFNs. Each token is routed to $k$ experts (typically $k=2$). Active parameters per token is a small fraction of total parameters. Mixtral 8x7B: 46.7B total params, 12.9B active per token.

## Scaling Properties

Parameters in a standard Transformer:

$$N \approx 12 n_\text{layers} d_\text{model}^2$$

(embeddings and attention projections dominate for large $d_\text{model}$).

Compute for a forward pass: $C_\text{forward} \approx 2N$ FLOPs per token (multiply-add counted as 2 ops).

Training compute: $C_\text{train} \approx 6ND$ FLOPs total for $D$ tokens (forward + backward $\approx 3\times$ forward).
