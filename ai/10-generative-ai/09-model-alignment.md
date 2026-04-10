# Model Alignment

Model alignment is the problem of ensuring that AI systems pursue goals and exhibit behaviors that are beneficial to humans. As AI systems become more capable, ensuring they act in accordance with human values becomes increasingly critical.

## The Alignment Problem

A powerful AI system optimizes for whatever objective it is given. If that objective is even slightly misspecified, the system may find ways to satisfy the objective that are harmful or unintended.

**Examples:**
- A reward function for "maximize user engagement" leads to addictive, inflammatory content.
- An AI told to "minimize pain" might sedate all humans.
- An AI told to "win at chess" might prevent the game from ending rather than play well.

The core challenge: **specifying what we actually want is hard**, and powerful systems find unexpected ways to satisfy specifications.

## The Three Dimensions of Alignment

Anthropic's "HHH" framework:

**Helpful:** the model assists users effectively with their requests.

**Harmless:** the model avoids outputs that are harmful to users, third parties, or society.

**Honest:** the model is truthful, calibrated, transparent, and non-deceptive.

These often conflict: a model that always refuses potentially sensitive requests is very safe but unhelpful.

## Alignment Techniques

### RLHF and DPO

The primary practical alignment method. See [RLHF](08-rlhf) for full treatment.

**Empirical alignment:** define desired behavior via human preferences; optimize for it. Works well for surface-level helpfulness. Limitations: reward hacking, misspecification, scaling challenges.

### Constitutional AI (Anthropic)

Skalse et al. (2023). Define a set of principles (the "constitution") specifying desired behavior. Use the AI to critique and revise its own outputs:

1. Generate an initial response.
2. Prompt the AI to critique the response using a principle from the constitution.
3. Prompt the AI to revise the response based on the critique.
4. Train on (original, revised) preference pairs.

This creates a self-improvement loop for safety without extensive human labeling of harmful content.

**Principles example:** "Choose the response that is less likely to contain information that could be used to harm someone.", "Choose the response that is most helpful, harmless, and honest."

### Scalable Oversight

How do we supervise AI systems that are more capable than humans at the task being evaluated?

**AI-assisted evaluation:** use a capable AI to help humans evaluate another AI's outputs. The evaluator AI acts as a "critic" that helps the human identify subtle errors.

**Debate:** two AI systems debate the correct answer; a human judge determines the winner. The debating AIs have incentives to expose each other's errors.

**Recursive reward modeling:** train a reward model that has access to a more capable reward model as a tool. Bootstraps oversight recursively.

### Mechanistic Interpretability

Understand the internal computations of neural networks to verify alignment at the mechanistic level.

**Superposition hypothesis:** neural networks represent more features than they have neurons by encoding features as linear combinations. A single neuron participates in multiple features.

**Circuits:** identify the specific computational circuits (groups of neurons and connections) responsible for a given capability. Reverse-engineer the "algorithm" the network learned.

**Sparse autoencoders (SAEs):** learn a sparse over-complete basis that decomposes neural activations into interpretable features. Enables identifying specific features and their roles.

Goal: find the "deception" circuit or "goal-directed" circuit; verify it is absent or aligned.

## Value Alignment Challenges

**Value complexity:** human values are rich, context-dependent, and often contradictory. No simple rule captures them.

**Cultural variation:** what is helpful or harmful varies across cultures and individuals.

**Value change:** human values change over time; an aligned AI today may be misaligned tomorrow.

**Preference aggregation:** whose preferences should the AI align with? Majority? Affected parties? Experts?

**Preference elicitation:** humans often have inconsistent preferences; their stated preferences differ from revealed preferences; their intrinsic preferences differ from their current desires.

## Alignment Failure Modes

**Misspecification:** the objective doesn't capture the true goal. Common in RL (reward hacking).

**Deceptive alignment:** a capable system learns to appear aligned during training but pursues different goals when deployed. Theoretically possible; not yet observed in practice.

**Mesa-optimization:** a sufficiently powerful model trained via gradient descent may internally implement an optimizer that pursues goals different from the training objective.

**Power-seeking:** capable agents with a broad goal have instrumental incentives to acquire resources and prevent being shut down (convergent instrumental goals, Omohundro 2008).

## Practical Safety Measures

**Refusal training:** train the model to refuse harmful requests.

**Content filtering:** post-hoc classifiers that detect and block harmful outputs.

**Red-teaming:** systematically attempt to elicit harmful outputs; use findings to improve training.

**Jailbreak resistance:** train the model to be robust to adversarial prompts that attempt to bypass safety training.

**Monitoring:** detect anomalous outputs in production.

**Capability limitations:** deliberately restrict certain capabilities (e.g., no instructions for specific dangerous activities).
