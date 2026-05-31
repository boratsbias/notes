# Fine-Tuning Language Models from Human Preferences (2019)

**Authors:** Daniel M. Ziegler et al.
**Area:** Natural Language Processing, Reinforcement Learning from Human Feedback
**Link:** [arXiv](https://arxiv.org/abs/1909.08593)

## What the paper argues

Language models trained on next-token prediction optimize for predicting text, not for producing outputs humans actually want. Specifying a good reward function in closed form is nearly impossible for open-ended generation. RLHF argues that human preference comparisons can be used to train a reward model, which then guides fine-tuning via RL. This is the paper that established the three-stage pipeline used to train InstructGPT and ChatGPT.

## The three-stage pipeline

```
Stage 1: Supervised Fine-Tuning (SFT)
  Pre-trained LM  →  fine-tune on (prompt, good response) pairs from humans

Stage 2: Reward Model Training
  Collect (prompt, response_A, response_B, human_preference) data
  Train reward model r_θ to predict which response humans prefer:
    L_RM = -log σ( r_θ(response_win) - r_θ(response_lose) )

Stage 3: RL Fine-Tuning (PPO)
  Use reward model as the reward signal:
    reward = r_θ(prompt, response) - β · KL(π_RL || π_SFT)
  Fine-tune the SFT model with PPO to maximize this reward
```

## The KL penalty

The KL divergence term `β · KL(π_RL || π_SFT)` is critical. Without it, the RL policy learns to produce outputs that score high on the reward model but diverge from coherent language. The penalty keeps the fine-tuned model close to the SFT baseline, preventing reward hacking while still improving alignment.

## Why comparisons, not ratings

Asking humans to rate responses on a scale is inconsistent and noisy. Asking which of two responses is better is simpler, more consistent, and scales more easily to large annotation teams.

## Results and impact

Demonstrated RLHF for text generation. The same pipeline was scaled to produce InstructGPT (which outperformed GPT-3 on human evaluations), and then ChatGPT. RLHF is now the standard technique for aligning large language models.
