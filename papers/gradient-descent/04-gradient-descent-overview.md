# An Overview of Gradient Descent Optimization Algorithms (2017)

**Authors:** Sebastian Ruder
**Area:** Optimization, Deep Learning
**Link:** [arXiv](https://arxiv.org/abs/1609.04747)

## The three regimes

Gradient descent comes in three variants, each trading off computation against signal quality. **Batch gradient descent** computes the gradient over the full training set at each step, producing an accurate update direction but making each step prohibitively expensive for large datasets. **Stochastic gradient descent** computes the gradient from a single example, making steps cheap but introducing high variance that can destabilize convergence. **Mini-batch gradient descent** averages gradients over small batches of 32 to 512 examples, providing a useful signal while enabling GPU parallelism and adding a regularizing effect from gradient noise. Modern deep learning essentially always uses mini-batch gradient descent, and refers to it simply as SGD.

## The challenges

Training deep networks surfaces distinct failure modes that no single algorithm solves simultaneously. **Learning rate selection** is the most consequential hyperparameter: too large and the loss oscillates or diverges; too small and training stalls in a flat region. **Ill-conditioned curvature** means the loss surface is far steeper in some directions than others, causing gradient descent to zig-zag inefficiently rather than descending directly. **Saddle points** are common in high-dimensional spaces, where gradients vanish but the point is neither a minimum nor maximum, trapping algorithms that rely on small gradients as a stopping condition. **Noisy gradients** from mini-batches add variance that complicates convergence.

## The algorithm landscape

Each optimizer the survey covers addresses a different challenge. **Momentum** accumulates a velocity vector in the gradient direction, smoothing oscillations and accelerating progress through flat regions. **Nesterov accelerated gradient** improves on momentum by computing the gradient at the anticipated future position, correcting for overshoot. **Adagrad** adapts the learning rate per parameter using accumulated squared gradients, benefiting sparse features in NLP. **RMSProp** replaces Adagrad's cumulative sum with an exponential moving average, fixing the monotonic decay problem. **Adam** combines adaptive per-parameter rates with momentum, addressing both ill-conditioning and gradient noise.

## Results and impact

The survey covers learning rate schedules including step decay, cosine annealing, and linear warmup before peak rate. Its practical recommendation, start with Adam at default hyperparameters and tune the learning rate before anything else, remains the standard first step when approaching a new problem. The paper became the canonical reference for optimization in deep learning, regularly cited for explaining the landscape of choices and their tradeoffs.
