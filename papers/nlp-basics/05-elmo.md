# ELMo: Deep Contextualized Word Representations (2018)

**Authors:** Matthew Peters, Mark Neumann, Mohit Iyyer, Matt Gardner, Christopher Clark, Kenton Lee, Luke Zettlemoyer
**Area:** Natural Language Processing, Contextualized Embeddings
**Link:** [arXiv](https://arxiv.org/abs/1802.05365)

## The polysemy problem with static embeddings

Word2vec and GloVe assign each vocabulary item a single fixed vector regardless of context. This works reasonably well for unambiguous words but fails for **polysemous words**, words with multiple distinct meanings. "Bank" receives one vector that must somehow average over river bank, financial institution, and blood bank. The model has no mechanism to select the appropriate sense based on surrounding text. ELMo's central claim is that a word's representation should be a function of the entire input sentence, produced by a model that reads the full context, so that "bank" in a financial context and "bank" in a geographical context receive genuinely different vectors.

## Architecture: bidirectional LSTM language model

ELMo builds on a **bidirectional language model** trained on a large text corpus. The forward LSTM reads the sentence left to right and predicts each next word given its left context. The backward LSTM reads right to left and predicts each preceding word given its right context. The two directions are trained independently on the same language modeling objective, not jointly conditioned on each other. The model is deep, with L LSTM layers stacked in each direction. Each layer produces a hidden state for every token position, yielding 2L intermediate representations per word plus the initial token embedding layer, for 2L+1 total layers of signal.

## The key contribution: learned layer weighting

Prior contextualized models used only the top layer of the network as the word representation. ELMo's central technical contribution is the observation that **different layers encode different kinds of linguistic information** and that downstream tasks benefit from choosing which layers to emphasize. Lower layers of the biLSTM capture **syntactic information**: part-of-speech tags, dependency structure, and morphological patterns are more decodable from lower-layer representations. Higher layers capture **semantic information**: word sense disambiguation, semantic role labeling, and named entity type emerge more clearly at the top. ELMo computes a task-specific **weighted combination of all 2L+1 layer outputs**, where the weights are learned scalars optimized during downstream training. Letting the task decide which layers matter is the novel mechanism.

## Integration into downstream models

ELMo embeddings are computed from the frozen pretrained biLSTM and concatenated to the input of existing downstream models: they augment, rather than replace, the model's own learned embeddings. This plug-in design required no architectural changes to existing systems and was a practical advantage over approaches that required end-to-end retraining from scratch. The pretrained biLSTM weights are kept fixed during downstream fine-tuning in the original paper, though later work found that fine-tuning the biLSTM itself added further gains.

## Results and impact

ELMo improved state of the art on six diverse benchmarks simultaneously: SQuAD question answering, SNLI textual entailment, SemEval semantic role labeling, Ontonotes named entity recognition, SST-5 sentiment analysis, and coreference resolution. Gains ranged from 4 to 25 percent relative improvement, demonstrating that contextual representations transfer broadly across task types. ELMo was the first clear demonstration that **language model pre-training on unlabeled text produces representations that transfer across NLP tasks**, directly motivating GPT and BERT, both of which replaced the biLSTM with the Transformer architecture and moved from feature extraction to full end-to-end fine-tuning.
