# Hypothesis Testing

## Core Idea

Hypothesis testing provides a framework for making decisions about population parameters based on sample data. It answers: "Is the observed effect real, or could it be due to random chance?"

## Basic Framework

**Null hypothesis ($H_0$):** Default assumption (no effect, no difference, status quo).

**Alternative hypothesis ($H_1$ or $H_a$):** What we want to find evidence for.

**Test statistic:** A function of the data used to decide between hypotheses.

**Rejection region:** Values of the test statistic that lead to rejecting $H_0$.

## Types of Errors

| Decision | $H_0$ True | $H_0$ False |
|----------|------------|-------------|
| Reject $H_0$ | Type I error ($\alpha$) | Correct (Power) |
| Fail to reject $H_0$ | Correct | Type II error ($\beta$) |

**Type I error ($\alpha$):** False positive (rejecting true null).

**Type II error ($\beta$):** False negative (failing to reject false null).

**Power ($1 - \beta$):** Probability of correctly rejecting a false null hypothesis.

## Significance Level

**Significance level ($\alpha$):** Maximum acceptable Type I error rate.

Common choices: $\alpha = 0.05$, $\alpha = 0.01$, $\alpha = 0.001$.

**Decision rule:** Reject $H_0$ if p-value $< \alpha$.

## P-value

The **p-value** is the probability of observing a test statistic as extreme as (or more extreme than) the observed value, assuming $H_0$ is true:

$$\text{p-value} = P(T \geq t_{\text{obs}} | H_0)$$

**Interpretation:**
- Small p-value ($< \alpha$): Data is unlikely under $H_0$ → reject $H_0$
- Large p-value: Data is consistent with $H_0$ → fail to reject

**Important:** p-value is NOT:
- The probability that $H_0$ is true
- The probability that the result is due to chance
- A measure of effect size or practical significance

## Common Tests

### Z-test (One Sample)

Test if population mean equals a specified value $\mu_0$ (known variance $\sigma^2$).

**Hypotheses:**
- $H_0: \mu = \mu_0$
- $H_1: \mu \neq \mu_0$ (two-tailed), $\mu > \mu_0$ or $\mu < \mu_0$ (one-tailed)

**Test statistic:**

$$Z = \frac{\bar{x} - \mu_0}{\sigma / \sqrt{n}}$$

**Distribution:** $Z \sim \mathcal{N}(0, 1)$ under $H_0$.

### T-test (One Sample)

Test if population mean equals $\mu_0$ (unknown variance, estimated from data).

**Test statistic:**

$$t = \frac{\bar{x} - \mu_0}{s / \sqrt{n}}$$

**Distribution:** $t \sim t_{n-1}$ (Student's t with $n-1$ degrees of freedom).

### T-test (Two Sample)

Compare means from two independent groups.

**Test statistic:**

$$t = \frac{\bar{x}_1 - \bar{x}_2}{s_p \sqrt{\frac{1}{n_1} + \frac{1}{n_2}}}$$

where $s_p^2 = \frac{(n_1-1)s_1^2 + (n_2-1)s_2^2}{n_1 + n_2 - 2}$ (pooled variance).

**Distribution:** $t \sim t_{n_1 + n_2 - 2}$.

### Paired T-test

Compare means from matched pairs (before/after, same subjects).

**Test statistic:**

$$t = \frac{\bar{d}}{s_d / \sqrt{n}}$$

where $d_i = x_{i1} - x_{i2}$ (differences).

### Chi-Squared Test (Goodness of Fit)

Test if observed frequencies match expected frequencies.

**Test statistic:**

$$\chi^2 = \sum_{i=1}^k \frac{(O_i - E_i)^2}{E_i}$$

**Distribution:** $\chi^2 \sim \chi^2_{k-1-p}$ where $p$ = number of estimated parameters.

### Chi-Squared Test (Independence)

Test if two categorical variables are independent.

**Test statistic:**

$$\chi^2 = \sum_{i,j} \frac{(O_{ij} - E_{ij})^2}{E_{ij}}$$

where $E_{ij} = \frac{(\text{row total}_i)(\text{column total}_j)}{\text{grand total}}$.

**Distribution:** $\chi^2 \sim \chi^2_{(r-1)(c-1)}$.

### F-test (ANOVA)

Compare means across $k > 2$ groups.

**Test statistic:**

$$F = \frac{\text{Between-group variance}}{\text{Within-group variance}} = \frac{MS_B}{MS_W}$$

**Distribution:** $F \sim F_{k-1, N-k}$.

**Null hypothesis:** All group means are equal.

### F-test (Variance Comparison)

Compare variances from two populations.

**Test statistic:**

$$F = \frac{s_1^2}{s_2^2}$$

**Distribution:** $F \sim F_{n_1-1, n_2-1}$.

## Confidence Intervals

A **$100(1-\alpha)\%$ confidence interval** is a range that, under repeated sampling, would contain the true parameter value in $100(1-\alpha)\%$ of cases.

**For mean (known $\sigma$):**

$$\bar{x} \pm z_{\alpha/2} \frac{\sigma}{\sqrt{n}}$$

**For mean (unknown $\sigma$):**

$$\bar{x} \pm t_{\alpha/2, n-1} \frac{s}{\sqrt{n}}$$

**Interpretation (frequentist):** If we repeated the experiment many times, $100(1-\alpha)\%$ of the computed intervals would contain the true parameter.

## Relationship Between Hypothesis Tests and Confidence Intervals

A two-tailed hypothesis test at level $\alpha$ rejects $H_0: \mu = \mu_0$ if and only if $\mu_0$ is outside the $100(1-\alpha)\%$ confidence interval.

## Multiple Testing Problem

When conducting $m$ hypothesis tests, the probability of at least one false positive increases:

$$P(\text{at least one Type I error}) = 1 - (1 - \alpha)^m$$

For $m = 20$ tests at $\alpha = 0.05$: ~64% chance of at least one false positive.

### Correction Methods

**Bonferroni correction:** Divide significance level by number of tests.

$$\alpha_{\text{adjusted}} = \frac{\alpha}{m}$$

Conservative but simple.

**Holm-Bonferroni method:** Step-down procedure (less conservative).

1. Sort p-values: $p_{(1)} \leq p_{(2)} \leq \ldots \leq p_{(m)}$
2. Reject $H_{(i)}$ if $p_{(i)} \leq \frac{\alpha}{m - i + 1}$
3. Stop at first non-rejection

**Benjamini-Hochberg procedure:** Controls False Discovery Rate (FDR).

1. Sort p-values: $p_{(1)} \leq p_{(2)} \leq \ldots \leq p_{(m)}$
2. Find largest $k$ such that $p_{(k)} \leq \frac{k}{m} \alpha$
3. Reject all $H_{(i)}$ for $i \leq k$

## Power Analysis

**Statistical power:** $P(\text{reject } H_0 | H_1 \text{ is true}) = 1 - \beta$

**Factors affecting power:**
- Sample size ($n$): larger $n$ → higher power
- Effect size: larger effect → higher power
- Significance level ($\alpha$): higher $\alpha$ → higher power (but more Type I errors)
- Variance: lower variance → higher power

**A priori power analysis:** Determine required sample size before conducting study.

## Non-parametric Tests

When distributional assumptions (e.g., normality) are violated.

### Mann-Whitney U Test (Wilcoxon Rank-Sum)

Non-parametric alternative to two-sample t-test.

**Procedure:** Rank all observations, sum ranks for each group.

### Wilcoxon Signed-Rank Test

Non-parametric alternative to paired t-test.

### Kruskal-Wallis Test

Non-parametric alternative to one-way ANOVA.

## Key AI/ML Applications

| Test/Concept | Where Used |
|--------------|------------|
| A/B testing | Comparing model versions, UI experiments |
| Chi-squared test | Feature selection, independence testing |
| ANOVA | Comparing multiple models/algorithms |
| Multiple testing correction | Genomics, feature screening |
| Power analysis | Experimental design, sample size determination |
| Confidence intervals | Reporting model performance with uncertainty |
| Non-parametric tests | When normality assumptions violated |
