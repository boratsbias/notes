# Evaluation of Generative Models

Evaluating generative models is challenging because outputs are open-ended: there is no single correct answer. Evaluation must measure fluency, coherence, factuality, helpfulness, safety, and task-specific quality.

## The Evaluation Challenge

**Reference-based metrics** (BLEU, ROUGE) compare output to a small set of human references. Fail when a model produces a correct but differently worded response. Low correlation with human judgment for high-quality models.

**Human evaluation** is the gold standard but is expensive, slow, and not reproducible.

**LLM-as-judge** is emerging as a scalable proxy for human evaluation.

## Automated Metrics

### Text Generation

| Metric | Measures | Limitations |
|--------|----------|------------|
| BLEU | n-gram precision vs. references | Insensitive to meaning; poor for diverse outputs |
| ROUGE | n-gram recall vs. references | Same as BLEU |
| METEOR | Stems, synonyms, recall | Better than BLEU; still reference-dependent |
| BERTScore | Semantic similarity via BERT | Requires references; scales better |
| MAUVE | Distribution-level quality | Requires samples; no direct item scores |
| Perplexity | Fluency under a reference LM | Measures likelihood; doesn't capture factuality |

### Image Generation

| Metric | Measures |
|--------|----------|
| FID (Fréchet Inception Distance) | Distribution similarity (real vs. generated) |
| IS (Inception Score) | Quality and diversity |
| CLIP score | Image-text alignment |
| Precision / Recall | Fidelity (precision) and diversity (recall) separately |
| LPIPS | Perceptual similarity to reference images |

**FID** is computed by passing 50k real and 50k generated images through an InceptionV3 classifier; comparing the statistics of the penultimate layer activations:

$$\text{FID} = \|\mu_r - \mu_g\|^2 + \text{tr}(\Sigma_r + \Sigma_g - 2(\Sigma_r \Sigma_g)^{1/2})$$

Lower FID = more similar distributions. Sensitive to the number of samples used.

## LLM-as-Judge

Use a capable LLM (GPT-4, Claude) to evaluate another model's output. Scales better than human evaluation.

**Pointwise scoring:** rate a single response on a Likert scale.

```
Rate the following response for helpfulness and accuracy on a scale of 1-5.
Question: [question]
Response: [model response]
Rating:
```

**Pairwise comparison:** choose the better of two responses.

```
Which of the following responses to the question is more helpful and accurate?
Question: [question]
Response A: [model A]
Response B: [model B]
Better response: A or B
```

**MT-Bench:** 80 challenging multi-turn questions; GPT-4 as judge. Standard for assistant model evaluation.

**AlpacaEval:** automatically evaluates instruction-following quality vs. a reference model (text-davinci-003).

**Arena Hard:** 500 challenging user prompts; pairwise GPT-4 judging.

**Chatbot Arena (lmarena.ai):** crowdsourced human pairwise comparisons; ELO ratings. The most trusted LLM ranking.

## Calibration Evaluation

**Expected Calibration Error (ECE):** see [ML Evaluation Systems](../09-ai-systems/11-ml-evaluation-systems). Measures how well predicted confidence matches empirical accuracy.

**TriviaQA calibration:** ask factual questions; measure ECE of verbalized confidence ("I'm 90% sure...").

## Factuality and Hallucination Evaluation

**TruthfulQA:** 817 questions where humans frequently give wrong answers due to misconceptions. Tests if models generate truthful responses.

**FACTOR / FActScorer:** given a generated response, decompose into atomic claims; verify each claim against a knowledge base. Precision and recall of factual claims.

**FactScore:** GPT-4-based fact verification for person biographies. Scores the fraction of atomic claims that are factually correct.

**FEVEROUS / HaluEval:** evaluate hallucination rates in specific domains (dialogue, summarization, QA).

## Safety Evaluation

**ToxiGen:** measure the probability that the model generates toxic content about demographic groups.

**BBQ (Bias Benchmark for QA):** evaluate social bias in question answering.

**WinoBias / WinoGrande:** coreference bias evaluation.

**HarmBench:** standardized red-teaming benchmark. Attack success rate of adversarial jailbreaks.

**SORRY-Bench:** evaluate refusal quality. Does the model refuse appropriately without over-refusal of benign requests?

## Capability Benchmarks

| Benchmark | Capability tested |
|-----------|-----------------|
| MMLU | World knowledge (57 subjects) |
| HellaSwag | Commonsense reasoning |
| ARC-E / ARC-C | Science reasoning |
| GSM8K | Grade school math |
| MATH | Competition math |
| HumanEval | Python code generation |
| MBPP | Programming benchmarks |
| DROP | Discrete reasoning over paragraphs |
| GPQA | PhD-level science questions |

**Benchmark saturation:** as models improve, benchmarks become saturated (near-100% accuracy). New harder benchmarks are continually needed.

**Data contamination:** if benchmark questions appear in training data, scores are inflated. Hard to detect with certainty; decontamination by fuzzy matching is imperfect.

## Evaluation Best Practices

**Use multiple benchmarks:** no single benchmark captures all relevant dimensions.

**Report error bars:** evaluation has variance; report confidence intervals.

**Diverse prompts:** test with different phrasings; models can be sensitive to prompt wording.

**Failure analysis:** categorize failures by type. Random errors, consistent failures on a specific topic, and format failures have different remedies.

**Human evaluation for final assessment:** automated metrics correlate imperfectly with human judgment. Human side-by-side evaluation is required for final product decisions.

**Avoid overfitting to benchmarks:** optimizing solely for benchmark performance may improve numbers without improving real-world utility.
