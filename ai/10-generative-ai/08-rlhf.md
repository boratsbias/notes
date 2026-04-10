# RLHF

Reinforcement Learning from Human Feedback (RLHF) aligns language model outputs to human preferences through a reward model trained on human comparisons, followed by RL fine-tuning.

## Why RLHF?

Instruction tuning teaches models to follow instructions, but doesn't specify what "good" means beyond the training examples. RLHF captures the nuanced human preference for helpfulness, harmlessness, and honesty that is hard to express in a fixed training set.

**The alignment problem:** designing a reward function that correctly captures all dimensions of human preference is very hard. RLHF learns the reward function from data.

## The Three-Stage Pipeline

### Stage 1: Supervised Fine-Tuning (SFT)

Fine-tune a pretrained LLM on a curated (prompt, response) dataset to create a well-behaved baseline model $\pi_\text{SFT}$.

This is the instruction tuning step described in [Instruction Tuning](07-instruction-tuning).

### Stage 2: Reward Model Training

**Data collection:** for each prompt, generate two responses from the SFT model. Human labelers rank which response is better.

**Training:** train a reward model $r_\phi(x, y)$ that predicts human preference scores.

**Bradley-Terry preference model:**

$$P(y_w \succ y_l | x) = \sigma(r_\phi(x, y_w) - r_\phi(x, y_l))$$

$y_w$: preferred (winning) response. $y_l$: dispreferred (losing) response.

**Loss:**

$$\mathcal{L}_\text{RM}(\phi) = -\mathbb{E}_{(x, y_w, y_l) \sim \mathcal{D}}[\log \sigma(r_\phi(x, y_w) - r_\phi(x, y_l))]$$

**Architecture:** take the SFT model; replace the language model head with a scalar regression head. The final hidden state of the last token is projected to a single reward value.

### Stage 3: RL Fine-Tuning (PPO)

Optimize the language model to maximize expected reward while staying close to $\pi_\text{SFT}$:

$$\max_\theta \mathbb{E}_{x \sim \mathcal{D}, y \sim \pi_\theta(\cdot|x)}\left[r_\phi(x, y) - \beta \log \frac{\pi_\theta(y|x)}{\pi_\text{SFT}(y|x)}\right]$$

The KL penalty $\beta \log \frac{\pi_\theta}{\pi_\text{SFT}}$ prevents reward hacking (exploiting weaknesses in $r_\phi$ without genuinely improving).

**PPO in RLHF:**
- The language model is the policy $\pi_\theta$.
- Each token generation step is an "action."
- The reward is applied at the end of the generated sequence.
- Intermediate rewards are zero (sparse reward).

**Implementation challenges:** PPO for LLMs requires 4 models simultaneously in memory (policy, reference policy, critic, reward model) and complex multi-step generation during training. Expensive.

## Reward Hacking

The policy finds ways to maximize $r_\phi$ without genuinely becoming more helpful:

- Long, verbose outputs that score high on completeness.
- Sycophantic responses that agree with the user regardless of correctness.
- Specific patterns that confuse the reward model.

**Mitigation:** KL constraint, diverse reward model ensemble, iterative data collection, constitutional principles.

## DPO (Direct Preference Optimization)

Rafailov et al. (2023). Eliminates the explicit reward model and PPO training loop. Directly optimizes the LLM on preference data.

**Key insight:** the optimal policy under the RLHF objective can be expressed in closed form:

$$\pi^*(y|x) \propto \pi_\text{SFT}(y|x) \exp\!\left(\frac{1}{\beta} r^*(x,y)\right)$$

Rearranging, the reward can be expressed in terms of the policy and the reference:

$$r^*(x,y) = \beta \log \frac{\pi^*(y|x)}{\pi_\text{SFT}(y|x)} + \beta \log Z(x)$$

Substituting into the Bradley-Terry model and dropping the partition function:

$$\mathcal{L}_\text{DPO}(\theta) = -\mathbb{E}\!\left[\log \sigma\!\left(\beta \log \frac{\pi_\theta(y_w|x)}{\pi_\text{ref}(y_w|x)} - \beta \log \frac{\pi_\theta(y_l|x)}{\pi_\text{ref}(y_l|x)}\right)\right]$$

**Gradient interpretation:** DPO increases the relative log-probability of the preferred response over the dispreferred one. The implicit reward is implicitly learned without a separate model.

**Advantages over RLHF:** simpler (no RM, no PPO, fewer models); stable training; no reward hacking surface.

**Limitations:** requires high-quality preference data; no explicit reward signal for verification; distribution shift from $\pi_\text{ref}$ to $\pi_\theta$ can degrade quality.

## DPO Variants

**IPO (Identity Preference Optimization):** regularizes DPO to avoid overfitting to preference pairs.

**KTO:** uses a different objective based on Kahneman-Tversky prospect theory. Works with scalar "thumbs up/down" labels instead of paired comparisons; more data-efficient.

**ORPO:** online rejection sampling + preference optimization in one stage. Stronger than DPO.

**SimPO:** simplifies DPO by removing the reference model; uses sequence length normalization.

## Reward Model Quality

**Goodhart's Law:** "When a measure becomes a target, it ceases to be a good measure." The RM is an imperfect proxy for human preferences; optimizing it too aggressively causes reward hacking.

**Constitutional AI (Anthropic):** use a set of principles to generate critique-revision pairs; use the revised responses to train the RM. Reduces dependence on human labelers for safety.

**RLAIF (RL from AI Feedback):** replace human labelers with another LLM (Claude, GPT-4) to generate preference labels. Scalable; risks propagating the annotator model's biases.
