# An Overview of Gradient Descent Optimization Algorithms (2017)

**Authors:** Sebastian Ruder
**Area:** Optimization, Deep Learning
**Link:** [arXiv](https://arxiv.org/abs/1609.04747)

## What the paper argues

Gradient descent has many variants and the optimizer landscape is fragmented. This paper gives a unified treatment of the major algorithms, tracing each one as a solution to a specific problem with the previous variant.

## The variant hierarchy

```
SGD
 └─ + momentum           → smooths oscillations across steps
     └─ + Nesterov       → looks ahead before computing gradient
         └─ + per-param  → Adagrad (cumulative), RMSProp (moving avg)
             └─ + both   → Adam (momentum + adaptive rate)
                 └─ + natural gradient → KFAC, Shampoo
```

**Batch gradient descent** uses the full dataset per step: exact gradient, but very slow and infeasible for large data.

**Stochastic gradient descent (SGD)** uses one sample: fast but high variance, making the loss noisy and hard to converge.

**Mini-batch SGD** uses a small batch (typically 32-512): the practical standard, balancing speed and stability.

## Key challenges each optimizer addresses

**Choosing a learning rate:** too large causes divergence, too small wastes compute. Learning rate schedules (step decay, cosine annealing, warmup) are standard responses.

**Ill-conditioned curvature:** loss landscapes are elongated ellipses when features have different scales. Adaptive methods (Adagrad, Adam) rescale each dimension. Input normalization also helps.

**Saddle points:** in high-dimensional spaces, most critical points are saddle points, not local minima. Momentum and noise from mini-batches help escape them.

## Results and impact

The paper became the standard reference for optimization in deep learning. Its recommendations (use Adam as default, tune learning rate first, use schedules) remain the practical starting point for most training runs.
