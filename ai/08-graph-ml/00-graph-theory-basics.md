# Graph Theory Basics

A graph is a mathematical structure for representing pairwise relationships. Graph ML extends machine learning to graph-structured data such as social networks, molecules, knowledge bases, and citation networks.

## Graph Definition

A graph $G = (V, E)$ consists of:

- $V = \{v_1, \ldots, v_n\}$: a set of $n$ nodes (vertices).
- $E \subseteq V \times V$: a set of $m$ edges.

An edge $(u, v) \in E$ connects nodes $u$ and $v$.

**Node features:** $X \in \mathbb{R}^{n \times d}$, where row $X_v$ is the feature vector of node $v$.

**Edge features:** $e_{uv} \in \mathbb{R}^{d_e}$ for each edge $(u,v)$.

**Graph features:** a single vector describing the whole graph.

## Types of Graphs

**Undirected:** $(u,v) \in E \Leftrightarrow (v,u) \in E$. Symmetric relationships. Examples: social friendships, molecular bonds.

**Directed:** edges have direction $(u \to v)$. Examples: web links, citations, Twitter follows.

**Weighted:** each edge has a scalar weight $w_{uv} \in \mathbb{R}$. Examples: road distances, interaction strengths.

**Bipartite:** nodes split into two disjoint sets $U$ and $V$; edges only between sets. Examples: user-item interactions (recommender systems), author-paper networks.

**Multigraph:** multiple edges allowed between the same pair of nodes.

**Hypergraph:** edges (hyperedges) can connect more than two nodes.

**Heterogeneous graph:** multiple types of nodes and edges. Examples: knowledge graphs (entities and relation types), bibliographic networks (papers, authors, venues).

**Dynamic graph:** graph evolves over time; nodes and edges appear and disappear.

## Degree

**Degree** $d_v$: number of edges incident to node $v$.

$$d_v = \sum_{u \in V} A_{vu}$$

**In-degree / out-degree** for directed graphs.

**Degree distribution:** $P(d = k)$ = fraction of nodes with degree $k$. Power-law degree distributions ($P(k) \propto k^{-\alpha}$, $\alpha \approx 2$–$3$) characterize scale-free networks (social networks, web).

## Graph Properties

**Path:** sequence of nodes $v_0, v_1, \ldots, v_k$ where each $(v_{i-1}, v_i) \in E$.

**Shortest path length $d(u,v)$:** minimum number of edges between $u$ and $v$.

**Diameter:** maximum shortest path over all pairs. $\max_{u,v} d(u,v)$.

**Clustering coefficient of node $v$:**

$$C_v = \frac{\text{number of triangles through } v}{\text{number of triplets centered at } v} = \frac{|\{(u,w): (v,u),(v,w),(u,w) \in E\}|}{\binom{d_v}{2}}$$

Measures how connected a node's neighbors are to each other.

**Connected component:** maximal subset of nodes where every pair is reachable via paths. A graph is connected if it has a single component.

**Strongly connected component (directed graphs):** maximal subset where every node can reach every other.

## Common Graph Structures

**Tree:** connected acyclic graph. $n$ nodes, $n-1$ edges.

**Star:** one hub node connected to all others.

**Complete graph $K_n$:** every pair of nodes connected. $n(n-1)/2$ edges.

**Erdos-Renyi $G(n,p)$:** each possible edge included independently with probability $p$. Random graph model; lacks community structure and power-law degrees.

**Barabasi-Albert (preferential attachment):** new nodes attach to existing nodes proportional to their degree. Produces scale-free power-law degree distributions.

**Stochastic Block Model (SBM):** nodes belong to communities; intra-community edges are denser than inter-community. Standard model for community structure.

## Graph Isomorphism

Two graphs $G$ and $G'$ are isomorphic if there exists a bijection $\phi: V \to V'$ that preserves edges. Deciding graph isomorphism is not known to be in P or NP-complete.

**Weisfeiler-Leman (WL) graph isomorphism test:** iteratively aggregate node labels from neighbors; update node labels via hashing. Two graphs are deemed non-isomorphic if their label multisets differ. GNNs are at most as powerful as the 1-WL test (fundamental limitation).
