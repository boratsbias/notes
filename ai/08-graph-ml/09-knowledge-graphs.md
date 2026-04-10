# Knowledge Graphs

A knowledge graph (KG) is a structured representation of real-world entities and the relationships between them, stored as a collection of (subject, predicate, object) triples. KGs power search engines, question answering, and recommendation systems.

## Structure and Notation

A KG $\mathcal{G} = \{(h, r, t)\} \subset \mathcal{E} \times \mathcal{R} \times \mathcal{E}$

- $\mathcal{E}$: entity set (nodes).
- $\mathcal{R}$: relation type set (edge types).
- $(h, r, t)$: head entity, relation, tail entity.

**Example triples:**
- (Barack Obama, born\_in, Honolulu)
- (Honolulu, located\_in, Hawaii)
- (Hawaii, is\_a, US State)

## Large-Scale KGs

| KG | Entities | Relations | Triples | Use |
|----|---------|----------|---------|-----|
| Freebase | 40M | ~35k | 2.4B | General world knowledge |
| Wikidata | 100M+ | 11k+ | 1.7B+ | Structured Wikipedia |
| DBpedia | 6.6M | 50k | 1.3B | Wikipedia extracts |
| YAGO | 10M | 100+ | 120M | Wikipedia + WordNet |
| ConceptNet | 8M | 36 | 21M | Commonsense knowledge |

## Knowledge Graph Completion (Link Prediction)

Most KGs are incomplete (many true triples are missing). KG completion predicts missing triples.

**Task:** given $(h, r, ?)$ or $(?, r, t)$, rank candidate entities by plausibility.

**Evaluation:** MRR, Hits@1, Hits@10 on held-out triples.

## Translational Embedding Models

### TransE

Bordes et al. (2013). The simplest and most influential KG embedding model. Represent entities and relations as vectors in $\mathbb{R}^d$; model each relation as a translation:

$$h + r \approx t \quad \text{if } (h, r, t) \text{ is true}$$

**Scoring function:**

$$f(h, r, t) = -\|h + r - t\|_{1/2}$$

**Training:** minimize margin-based ranking loss:

$$\mathcal{L} = \sum_{(h,r,t) \in \mathcal{G}} \sum_{(h',r,t') \notin \mathcal{G}} \max(0, \gamma + f(h',r,t') - f(h,r,t))$$

Corrupt the triple by replacing $h$ or $t$ with a random entity; push the true score higher than the corrupt score by margin $\gamma$.

**Limitation:** cannot model symmetric, transitive, one-to-many, or composition relations well. If $(h,r,t)$ and $(t,r,h)$ (symmetric), then $h + r = t$ and $t + r = h$, which forces $r = 0$.

### TransR / TransH

Improve TransE with relation-specific projection spaces. TransR projects entities into a relation-specific space before translating.

## Bilinear Models

### DistMult

$$f(h, r, t) = \mathbf{h}^T \text{diag}(r) \mathbf{t} = \sum_i h_i r_i t_i$$

Diagonal bilinear form. Simple; symmetric (cannot model asymmetric relations).

### ComplEx

Trouillon et al. (2016). Use complex-valued embeddings $h, r, t \in \mathbb{C}^d$:

$$f(h, r, t) = \text{Re}(\sum_i h_i r_i \bar{t}_i)$$

Asymmetric because complex conjugate $\bar{t}$ breaks symmetry. Can model symmetric, antisymmetric, and inverse relations.

### RotatE

Sun et al. (2019). Model each relation as element-wise rotation in complex space:

$$t = h \odot r, \quad |r_i| = 1$$

Each relation dimension rotates $h$ by angle $\theta_{r,i}$. Models symmetry ($\theta = 0$ or $\pi$), antisymmetry ($\theta \neq -\theta$), inversion ($\theta_r = -\theta_{r^{-1}}$), and composition ($\theta_{r_1 \circ r_2} = \theta_{r_1} + \theta_{r_2}$).

## Graph Neural Network Models

Apply GNNs to KGs to leverage multi-hop structural information.

### R-GCN (Relational GCN)

Schlichtkrull et al. (2018). GCN with relation-specific weight matrices:

$$h_v^{(l+1)} = \sigma\!\left(\sum_{r \in \mathcal{R}} \sum_{u \in \mathcal{N}_r(v)} \frac{1}{c_{v,r}} W_r^{(l)} h_u^{(l)} + W_0^{(l)} h_v^{(l)}\right)$$

$\mathcal{N}_r(v)$: neighbors of $v$ via relation $r$. $c_{v,r}$: normalization.

**Basis decomposition:** decompose $W_r = \sum_b a_{rb} V_b$ across shared basis matrices $V_b$ to reduce parameters.

### CompGCN

Vashishth et al. (2020). Jointly learn entity and relation embeddings with a composition operator:

$$h_v^{(l+1)} = \sigma\!\left(W_0 h_v^{(l)} + \sum_{(u,r) \in \mathcal{N}(v)} W_\lambda \phi(h_u^{(l)}, z_r)\right)$$

Composition $\phi$: subtraction, multiplication, or circular correlation. Relations are updated as $z_r^{(l+1)} = W_\text{rel} z_r^{(l)}$.

## KG Embedding Applications

**Question answering:** embed the question as a KG traversal query; retrieve the answer entity.

**Recommendation:** model (user, interacted\_with, item) triples; predict items for cold-start users.

**Drug-drug interaction:** (drug A, interacts\_with, drug B) triples; predict unknown interactions.

**Entity alignment:** align entities across different KGs representing the same real-world objects (e.g., align Freebase with Wikidata).

## Temporal Knowledge Graphs

Triples annotated with timestamps: $(h, r, t, \tau)$. Relations may be valid only during certain periods ("Barack Obama, president\_of, USA, 2009-2017").

**Models:** TNTComplEx, TTransE, DE-SimplE.

## Reasoning on KGs

**Multi-hop reasoning:** answer complex queries like "drugs that treat diseases caused by protein X" requires traversing multiple hops.

**Query2Box / BetaE:** embed first-order logic queries (conjunction, disjunction, negation) as geometric regions (boxes, Beta distributions) in entity embedding space. Intersection = box intersection; negation = complement.

**Neural Theorem Provers:** soft unification via differentiable logic rules. Learns rules from the KG structure.
