# A Neural Probabilistic Language Model (2003)

**Authors:** Yoshua Bengio, Rejean Ducharme, Pascal Vincent, Christian Janvin
**Area:** Natural Language Processing, Language Modeling
**Link:** [JMLR Paper](https://www.jmlr.org/papers/v3/bengio03a.html)

## The n-gram problem

Statistical language models before this paper were built on **n-grams**: count how often a sequence of words appears in a corpus and estimate the probability of the next word from those counts. This approach has two fundamental failure modes. First, the number of distinct word sequences grows exponentially with sequence length, so most sequences encountered at test time were never seen during training, producing zero probabilities that must be patched with ad hoc smoothing. Second, n-gram models treat words as atomic, discrete symbols with no notion of similarity. Seeing "the cat sat on the mat" teaches the model nothing about "the dog lay on the rug," because "dog" and "cat" are unrelated tokens to a count-based model. The paper argues that both problems dissolve once words are represented as **dense continuous vectors** in a shared geometric space.

## Distributed word representations

The core idea is a **word embedding**: a learned dense vector assigned to each vocabulary item. These vectors are initialized randomly and updated by gradient descent. Because the model must predict held-out text, gradient pressure pushes words that appear in similar contexts toward the same region of the embedding space. "Cat" and "dog" end up geometrically close. When the model encounters "the dog sat on the," it can borrow probability mass from the near-identical training sequence "the cat sat on the," because dog and cat share a neighborhood in the continuous space. Generalization to unseen sequences emerges naturally as a consequence of the geometry, not from hand-crafted smoothing rules.

## Architecture and the softmax bottleneck

The forward pass follows a simple pipeline: word indices feed into a **lookup table** that retrieves their embedding vectors, the context vectors are concatenated, passed through a tanh hidden layer, and then through a **softmax** over the full vocabulary to produce a probability distribution over the next word. The lookup table is just an embedding matrix, index in and vector out, updated by backpropagation like any other parameter. The embedding matrix is learning semantic similarity as a side effect of learning to predict language. The softmax is the computational bottleneck: normalizing over tens of thousands of vocabulary entries at every training step is expensive, a problem the authors addressed with short-list approximations and one that word2vec would later solve more elegantly with negative sampling.

## Results and impact

The paper was largely overlooked at publication in 2003 but proved foundational in retrospect. It introduced word embeddings learned from raw text, demonstrated that continuous representations enable generalization to unseen sequences, and identified the vocabulary-size bottleneck that shaped a decade of follow-on work. It is the direct ancestor of word2vec, GloVe, and every contextualized embedding system that followed. The core claim, that a distributed representation over a continuous space can substitute for exhaustive enumeration of discrete sequences, became the organizing principle of the entire pre-training era in NLP.
