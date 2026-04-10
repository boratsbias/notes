# Message Passing Networks

Message Passing Neural Networks (MPNNs) provide a unified framework that subsumes most GNN architectures. They explicitly decompose the GNN computation into message, aggregate, and update phases, and are particularly well-studied for molecular property prediction.

## The MPNN Framework

Gilmer et al. (2017) introduced MPNN as a unified formulation for GNNs applied to molecular graphs.

**Message phase:** each node $v$ receives a message from neighbor $u$ via edge $(u,v)$:

$$m_{uv}^{(t)} = M_t(h_v^{(t)}, h_u^{(t)}, e_{uv})$$

$M_t$: message function (MLP, learned, or fixed).
$e_{uv}$: edge feature vector (bond type, distance, etc.).

**Aggregation phase:**

$$m_v^{(t)} = \sum_{u \in \mathcal{N}(v)} m_{uv}^{(t)}$$

(Sum is most common in MPNN; any permutation-invariant function applies.)

**Update phase:**

$$h_v^{(t+1)} = U_t(h_v^{(t)}, m_v^{(t)})$$

$U_t$: update function (GRU, LSTM, or MLP).

**Readout phase (graph-level):**

$$\hat{y} = R\!\left(\{h_v^{(T)}: v \in V\}\right)$$

$R$: readout function (sum + MLP, or hierarchical pooling).

## Special Cases of MPNN

Most GNN architectures are instances of the MPNN framework:

| Model | $M_t$ | Aggregation | $U_t$ |
|-------|--------|------------|-------|
| GCN | $W h_u / \sqrt{d_u d_v}$ | Sum | Identity |
| GraphSAGE | $h_u$ | Mean/Max | MLP |
| GAT | $\alpha_{uv} W h_u$ | Weighted sum | Identity |
| GIN | $h_u$ | Sum | MLP |
| GGNN | $W e_{uv} h_u$ | Sum | GRU |
| SchNet | $f(\|r_u - r_v\|) h_u$ | Sum | MLP |

## GGNN (Gated Graph Neural Network)

Li et al. (2016). Use a GRU as the update function to allow messages to be processed over multiple rounds without storing layer-indexed representations:

$$m_v^{(t)} = \sum_{u \in \mathcal{N}(v)} W e_{uv} \cdot h_u^{(t)}$$

$$h_v^{(t+1)} = \text{GRU}(h_v^{(t)}, m_v^{(t)})$$

The GRU gating mechanism selectively updates the hidden state, allowing the network to "remember" information over multiple rounds. Useful for tasks requiring global reasoning (program verification, bAbI tasks).

## Edge-Conditioned Convolution (ECC)

Simonovsky & Komodakis (2017). The weight matrix is conditioned on the edge feature:

$$h_v^{(k+1)} = W h_v^{(k)} + \sum_{u \in \mathcal{N}(v)} F_\theta(e_{uv}) h_u^{(k)}$$

$F_\theta(e_{uv})$: an MLP that maps the edge feature to a weight matrix. Each edge type gets its own learned transformation. Essential when edges encode fundamentally different relation types.

## SchNet (Equivariant Molecular MPNN)

Schütt et al. (2017). Designed for 3D molecular graphs where atoms have 3D positions $r_v \in \mathbb{R}^3$.

**Continuous filter convolution:**

$$h_v^{(t+1)} = \sum_{u \in \mathcal{N}(v)} h_u^{(t)} \odot W_t(\|r_u - r_v\|)$$

$W_t(d)$: a radial basis function network that maps interatomic distance $d$ to a filter vector. Rotation and translation invariant (depends only on distances, not absolute positions).

**Used for:** quantum chemistry property prediction (energy, forces, dipole moment).

## DimeNet (Directional Message Passing)

Klicpera et al. (2020). Incorporates bond angles (not just distances) into messages.

Represent the message along edge $(j \to i)$ as depending on the angle $\angle kji$ for all incoming edges $k \to j$:

$$m_{ji}^{(t+1)} = \text{MLP}\!\left(e_{ji}, \sum_{k \in \mathcal{N}(j) \setminus i} f(\alpha_{kji}) m_{kj}^{(t)}\right)$$

Angles are encoded via directional Fourier features. More expressive than distance-only models; state-of-the-art on QM9 dataset.

## Over-Squashing

A fundamental limitation of MPNNs. Information from exponentially many nodes (at $k$ hops) must flow through a node's single aggregated message. This bottleneck is called over-squashing.

**Formal analysis:** the sensitivity of $h_v^{(K)}$ to $h_u^{(0)}$ decreases exponentially with $d(u,v)$ and graph commute time.

**Mitigation strategies:**
- **Graph rewiring:** add edges to improve connectivity (DIGL, SDRF). Reduces effective diameter.
- **Virtual nodes:** add a global "supernode" connected to all nodes. Acts as a long-range communication channel.
- **Transformers:** use global attention to bypass the bottleneck.

## Equivariant Graph Neural Networks

For 3D point clouds and molecules, the output should be equivariant under geometric transformations.

**SE(3)-equivariant:** equivariant to 3D rotations and translations.

**E(n)-equivariant GNN (EGNN):** messages incorporate relative positions and distances; update also predicts position updates. Simple and effective.

**Equiformer:** uses irreducible representations (spherical harmonics) as features; operations are equivariant by construction. State of the art on 3D molecular property prediction (OC20, QM9).
