# AI Safety

AI safety is the field concerned with ensuring that AI systems, particularly powerful ones, are beneficial, controllable, and aligned with human values. It encompasses both near-term practical safety (preventing current harms) and long-term safety (preventing catastrophic outcomes from advanced AI).

## Near-Term AI Safety

Practical safety concerns for systems deployed today.

### Harmful Content

**Categories:** hate speech, violence, self-harm, CSAM, misinformation, harassment.

**Technical mitigations:**
- Refusal training: fine-tune the model to decline harmful requests.
- Input classifiers: detect and block harmful prompts before reaching the model.
- Output classifiers: detect harmful completions; refuse or substitute.
- Red-teaming: systematic adversarial testing to find failure modes.

### Bias and Fairness

**Types of bias:** representation bias (underrepresentation of groups in training data), measurement bias (systematic errors in labels for some groups), historical bias (reflects historical inequalities).

**Fairness metrics:**
- **Demographic parity:** equal prediction rates across groups.
- **Equalized odds:** equal true positive and false positive rates across groups.
- **Individual fairness:** similar individuals should be treated similarly.

**Auditing:** evaluate model outputs on bias benchmarks (WinoBias, BBQ, StereoSet) and sliced evaluation on protected attributes.

### Privacy

**Memorization:** LLMs memorize and can reproduce training data, including personal information. Risk of exposing PII.

**Mitigation:** differential privacy during training (DP-SGD); data deduplication; canary detection; filtering PII from training data.

**Right to erasure (GDPR):** individuals can request their data be deleted. Requires machine unlearning techniques to remove specific information from a trained model.

### Misinformation

**Hallucination:** models generate plausible but false information confidently. Risk of spreading misinformation at scale.

**Mitigation:** RAG grounds responses in verified sources; calibration training improves uncertainty awareness; citations allow source verification.

## Long-Term AI Safety

Concerns about advanced AI systems with broadly superhuman capabilities.

### Existential Risk

The possibility that advanced AI systems could cause catastrophic or irreversible harm to humanity.

**Argument structure (Bostrom, Russell, Yudkowsky):**
1. It is possible to build AI systems far more capable than humans.
2. Such systems will pursue instrumental goals (resource acquisition, self-preservation) regardless of their terminal goals.
3. If the terminal goal is even slightly misaligned with human values, the instrumental pursuit of it may be catastrophic.

**The orthogonality thesis:** intelligence and goals are orthogonal dimensions. A superintelligent AI could have arbitrary terminal goals.

**Convergent instrumental goals:** almost any terminal goal leads to the same intermediate goals: self-preservation, goal-content integrity, resource acquisition, avoiding interference.

### X-risk Timelines and Uncertainty

**Disagreement:** experts disagree widely on the probability and timeline of transformative AI. Estimates range from "decades away" to "imminent."

**Planning under uncertainty:** even low-probability catastrophic risks justify significant investment in safety research.

### Technical Safety Research Areas

**Interpretability:** understand the internal representations and computations of neural networks. Identify dangerous goals, deceptive behaviors, or misaligned circuits before deployment.

**Scalable oversight:** maintain meaningful human oversight as AI capabilities grow. AI-assisted evaluation, debate, recursive reward modeling.

**Robustness:** ensure models behave safely under distribution shift, adversarial inputs, and novel situations.

**Corrigibility:** ensure AI systems remain controllable and correctable by humans. Resist power-seeking; accept shutdowns and corrections.

**Formal verification:** mathematically prove properties of AI systems (extremely hard; limited to small models or specific properties).

## Governance and Policy

**Model evaluations:** evaluate frontier models for dangerous capabilities (CBRN uplift, cyberattacks, deception) before deployment. Anthropic, OpenAI, and Google DeepMind publish safety cards.

**Responsible scaling policies:** commit to not deploying a model if it exhibits certain dangerous capabilities. Only continue scaling if safety measures are in place.

**Frontier AI regulation:** the EU AI Act classifies AI systems by risk level; high-risk systems require conformity assessments. Executive Order on AI (US 2023) mandates safety evaluations for large foundation models.

**International coordination:** AI safety requires global coordination to prevent race-to-the-bottom dynamics. AI Safety Summits (Bletchley Park 2023, Seoul 2024) bring together governments and AI companies.

## AI Safety vs. AI Ethics

**AI ethics:** fairness, bias, transparency, accountability, privacy, economic impacts. Primarily concerns current systems.

**AI safety:** control, alignment, corrigibility, existential risk. Primarily concerns future, more capable systems.

Both are important; they complement each other. The field is sometimes conflated; distinguishing them clarifies the different research agendas.

## Organizations

| Organization | Focus |
|-------------|-------|
| Anthropic | Alignment research + frontier models |
| DeepMind Safety | Scalable oversight, interpretability |
| OpenAI Safety | Alignment, red-teaming, policy |
| ARC Evals / METR | Model evaluations for dangerous capabilities |
| Redwood Research | Adversarial training, interpretability |
| MIRI | Mathematical AI alignment theory |
| Center for AI Safety | Broad safety research + policy |
