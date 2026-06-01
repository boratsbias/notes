# Fine-Tuning Language Models from Human Preferences (2019)

**Authors:** Daniel M. Ziegler et al.
**Area:** Natural Language Processing, Reinforcement Learning from Human Feedback
**Link:** [arXiv](https://arxiv.org/abs/1909.08593)

## The fundamental alignment problem

Language models trained on next-token prediction optimize for one thing: predicting the distribution of text in the training corpus. This is not the same as producing outputs that humans find helpful, accurate, or safe. The gap is not a bug that more data or scale automatically closes. A model can achieve low perplexity while generating confident misinformation, plausible but unhelpful responses, or text that matches the statistical surface of training data without satisfying the intent behind a prompt. Defining a scalar reward function that captures "what humans want" for open-ended generation is nearly impossible to do by hand, since the space of possible outputs is enormous and human preferences depend on context in ways that resist simple specification.

## The three-stage RLHF pipeline

RLHF sidesteps the reward specification problem by learning the reward from human behavior. The pipeline has three stages. Stage 1 is supervised fine-tuning: the base language model is fine-tuned on a dataset of high-quality prompt-response pairs written or curated by human labelers, producing an SFT model that generates reasonable outputs. Stage 2 is reward model training: annotators are shown pairs of model responses to the same prompt and asked which they prefer. This comparison data is used to train a reward model $r_\theta$ with a ranking loss that maximizes $r_\theta(\text{preferred}) - r_\theta(\text{rejected})$ using a log-sigmoid objective. Comparisons rather than scalar ratings are used because ratings are noisy and inconsistent across annotators, while binary comparisons are simpler and more reliable to collect at scale. The reward model shares the same architecture as the language model, with the final token's hidden state projected through a linear head to a scalar score. Stage 3 is RL fine-tuning: the SFT model is fine-tuned with PPO using a reward signal that combines the learned reward model score with a KL penalty.

## The KL penalty and why it matters

The reward signal used in Stage 3 is not just the raw reward model score. The full signal is:

$$r = r_\theta(\text{prompt, response}) - \beta \cdot \text{KL}(\pi_\text{RL} \,\|\, \pi_\text{SFT})$$

where $\pi_\text{RL}$ is the current policy and $\pi_\text{SFT}$ is the supervised baseline. Without this penalty, the RL policy tends to find outputs that exploit weaknesses in the reward model: degenerate repetitions or syntactically unusual text that scores high but diverges completely from natural language. The KL term prevents the policy from drifting too far from the SFT initialization, keeping responses fluent and grounded. A typical value of $\beta$ is 0.02, small enough to allow meaningful improvement but large enough to prevent reward hacking.

## Results and impact

Models fine-tuned with RLHF on text continuation tasks were consistently rated as higher quality by human evaluators than the base language models, demonstrating that the learned reward model captured genuine preferences beyond what perplexity measures. The paper established the three-stage pipeline and the KL-penalized PPO objective as the practical recipe for aligning language models to human intent. InstructGPT and ChatGPT are direct descendants, scaling the same approach to much larger models with more annotator data. RLHF is now the standard alignment technique used across large language model training pipelines.
