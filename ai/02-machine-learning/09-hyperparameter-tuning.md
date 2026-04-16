# Hyperparameter Tuning

**Hyperparameters** are configuration choices that control the learning process but are not learned from data: learning rate, regularization strength, tree depth, number of layers. Tuning finds the configuration that maximizes validation performance.

Distinguish from **model parameters** (learned during training, e.g., weights $\mathbf{w}$).

## Search Strategies

### Grid Search

Exhaustively evaluates all combinations of a discrete hyperparameter grid.

**Algorithm:** for each $(h_1, h_2, \ldots, h_k) \in \mathcal{H}_1 \times \mathcal{H}_2 \times \cdots \times \mathcal{H}_k$, train and evaluate via CV.

**Complexity:** $O(\lvert\mathcal{H}_1\rvert \times \cdots \times \lvert\mathcal{H}_k\rvert \times k\text{-fold cost})$.

**Advantage:** systematic, reproducible.

**Disadvantage:** exponential in number of hyperparameters; wastes resources on unimportant ones.

### Random Search

Samples hyperparameter configurations at random from specified distributions.

**Key insight (Bergstra & Bengio 2012):** if only a few hyperparameters matter, random search explores each of them more densely than grid search with the same budget.

For $n$ trials, each hyperparameter is sampled with $n$ distinct values vs. grid search which repeats the same values across all rows.

**Advantage:** efficient when some hyperparameters are unimportant; easy to parallelize.

**Disadvantage:** no learning from past evaluations.

### Bayesian Optimization

Builds a **surrogate model** of the objective function $f: \mathcal{H} \to \mathbb{R}$ and uses it to select the next most promising configuration to evaluate.

**Algorithm:**
1. Evaluate $f$ at a few initial random points.
2. Fit surrogate model (e.g., Gaussian Process) to observed $\{(h_i, f(h_i))\}$.
3. Maximize **acquisition function** to select next $h$.
4. Evaluate $f(h)$, add to observations. Repeat.

**Acquisition functions:**

| Function | Idea |
|----------|------|
| Expected Improvement (EI) | $\mathbb{E}[\max(f(h) - f^*, 0)]$ |
| Upper Confidence Bound (UCB) | $\mu(h) + \kappa \sigma(h)$; balances exploration and exploitation |
| Probability of Improvement (PI) | $P(f(h) > f^* + \xi)$ |

**Surrogate models:**
- **Gaussian Process (GP):** provides uncertainty estimates; exact but scales $O(n^3)$ with evaluations.
- **Tree Parzen Estimator (TPE):** models $P(h \mid f(h) < \text{threshold})$ and its complement; scales better.
- **Random Forest:** used in SMAC; handles categorical hyperparameters well.

Bayesian optimization is most effective when function evaluations are expensive.

### Successive Halving and Hyperband

**Successive Halving:** allocate a small budget (epochs) to many configurations; keep the top fraction; increase budget; repeat.

| Round | Configurations | Budget per config |
|-------|---------------|-------------------|
| 1 | $n$ | $r$ |
| 2 | $n/\eta$ | $r\eta$ |
| $\ldots$ | $\ldots$ | $\ldots$ |
| $\log_\eta n$ | 1 | $r\eta^{\log_\eta n}$ |

**Hyperband:** runs successive halving with multiple brackets at different initial $n$, trading off exploration vs. exploitation across brackets. Robust to the $n$ vs. $r$ choice.

**BOHB (Bayesian Optimization + HyperBand):** replaces random sampling in Hyperband with TPE-based Bayesian optimization. State of the art for many benchmarks.

## Key Hyperparameters by Algorithm

| Algorithm | Key Hyperparameters |
|-----------|---------------------|
| Gradient Boosted Trees | `n_estimators`, `max_depth`, `learning_rate`, `subsample`, `colsample_bytree`, `min_child_weight` |
| Random Forest | `n_estimators`, `max_depth`, `max_features`, `min_samples_leaf` |
| Neural Networks | `learning_rate`, `batch_size`, `n_layers`, `hidden_size`, `dropout`, `weight_decay` |
| SVM | `C`, `kernel`, `gamma` (RBF) |
| k-NN | `k`, distance metric |
| Lasso / Ridge | `alpha` ($\lambda$) |

## Search Space Design

- **Learning rate:** log-uniform in $[10^{-5}, 10^{-1}]$. Always search on log scale.
- **Regularization strength:** log-uniform in $[10^{-5}, 10]$.
- **Integer hyperparameters:** uniform discrete (tree depth, n\_estimators).
- **Categorical:** one-hot in Bayesian methods or direct in TPE.
- **Conditional hyperparameters:** e.g., gamma is only relevant if kernel = RBF. Use conditional search spaces in frameworks like Optuna.

## Practical Considerations

- Always use validation data (or CV) for tuning. Never use test set.
- Use early stopping to terminate unpromising runs cheaply.
- Parallelize across hardware when possible.
- Start coarse (wide ranges), then refine around good regions.
- Budget for final model: refit on full training data with best hyperparameters.
- Log all experiments (hyperparameters + metrics) for reproducibility and analysis.

## Software

| Library | Search Strategy | Notable Features |
|---------|----------------|-----------------|
| scikit-learn `GridSearchCV` / `RandomizedSearchCV` | Grid, Random | Integrated with sklearn pipeline |
| Optuna | TPE, CMA-ES | Pruning, distributed, conditional search |
| Ray Tune | Grid, Random, BOHB, PBT | Distributed, scheduler integration |
| Hyperopt | TPE | Functional API |
| Ax / BoTorch | Bayesian (GP) | Research-grade, multi-objective |
| SMAC3 | Random Forest surrogate | Strong for algorithm configuration |

## Population Based Training (PBT)

PBT trains a population of models simultaneously. Underperforming models **copy** hyperparameters and weights from better-performing ones and **perturb** the hyperparameters:

- **Exploit:** copy weights and hyperparameters from a top-performing member.
- **Explore:** randomly perturb the copied hyperparameters.

Discovers schedules (e.g., learning rate schedules) not possible with fixed hyperparameters. Used at DeepMind for AlphaGo, Waymo, and language model training.
