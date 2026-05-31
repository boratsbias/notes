# A Neural Probabilistic Language Model (2003)

**Authors:** Yoshua Bengio, Rejean Ducharme, Pascal Vincent, Christian Janvin
**Area:** Natural Language Processing, Language Modeling
**Link:** [JMLR](https://www.jmlr.org/papers/v3/bengio03a.html)

## What the paper argues

N-gram models assign zero probability to any word sequence not seen in training. Language is too combinatorially large for this to work: most valid sentences never appear in any corpus. The paper argues that learning a dense vector for each word lets the model generalize, because similar words end up near each other in the learned space and their probabilities can be shared.

## Architecture

Each of the previous n words is mapped to a feature vector, the vectors are concatenated, passed through a hidden layer, and projected to a probability distribution over the vocabulary:

```
[w_{t-n+1}, ..., w_{t-1}]
        ↓  (lookup table)
[e_{t-n+1}, ..., e_{t-1}]
        ↓  (concat + tanh layer)
      hidden
        ↓  (linear + softmax)
   P(w_t | context)
```

The lookup table is the first word embedding matrix. It is learned jointly with the rest of the network.

## Why it generalizes

If the model has seen "the cat sat on the mat" and a new sentence has "the dog sat on the mat", the embeddings for "cat" and "dog" will be close (both are common animals that appear in similar contexts). The model therefore assigns reasonable probability to the new sentence without ever having seen it.

## Results and impact

Outperformed n-gram baselines on standard language modeling benchmarks by using word similarity to smooth probabilities. This paper introduced the concept of word embeddings learned from data, which became the foundation for word2vec, GloVe, and eventually BERT and GPT.
