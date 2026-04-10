# Text Preprocessing

Raw text is messy, inconsistent, and not directly consumable by ML models. Preprocessing transforms raw text into a clean, normalized form before tokenization and modeling.

## Text Cleaning

**Lowercasing:** convert all text to lowercase. Simple but loses case-based information (proper nouns, acronyms). Optional for neural models that handle case via subword tokens.

**Punctuation removal:** strip punctuation for bag-of-words or TF-IDF pipelines. Avoid for models where punctuation carries syntactic or semantic meaning.

**Whitespace normalization:** collapse multiple spaces, tabs, newlines into a single space. Strip leading/trailing whitespace.

**HTML/markup stripping:** remove tags, entities (`&amp;`, `&lt;`) from web-scraped text. Use a parser (BeautifulSoup) rather than regex for robustness.

**Encoding normalization:** decode to Unicode; handle mojibake (garbled encodings). Normalize Unicode to NFC or NFKC form to merge equivalent representations (e.g., accented characters).

## Sentence Segmentation

Split a document into individual sentences. Non-trivial due to abbreviations ("Dr.", "U.S."), ellipses, and quoted speech.

**Rule-based:** Punkt algorithm (NLTK). Trains on abbreviation lists; handles common cases well.

**Neural:** spaCy's sentencizer, stanza. More robust on diverse domains.

## Stopword Removal

Remove high-frequency function words ("the", "is", "at") that carry little discriminative information for bag-of-words models.

**When to use:** TF-IDF, topic models, classical IR.

**When not to use:** sentiment analysis (negation words like "not" are critical), neural models (handle stopwords implicitly), tasks where function words carry grammatical meaning.

**Caution:** stopword lists are language-specific and domain-specific.

## Stemming

Reduces a word to its root form by stripping affixes using rules, without regard for linguistic correctness.

- "running" → "run"
- "studies" → "studi" (over-stemming)
- "better" → "better" (under-stemming)

**Porter Stemmer:** fast, simple, English-specific. Applies a cascade of suffix-stripping rules.

**Snowball Stemmer:** improved Porter; supports multiple languages.

**Output may not be a real word.** Useful for increasing recall in IR.

## Lemmatization

Maps a word to its canonical dictionary form (lemma) using morphological analysis and POS tags.

- "running" → "run"
- "better" → "good"
- "studies" → "study"

**Requires POS tagging** for disambiguation ("saw" as verb → "see"; "saw" as noun → "saw").

**Tools:** NLTK WordNetLemmatizer, spaCy, stanza. Slower than stemming but linguistically correct.

| Method | Speed | Accuracy | Real word output |
|--------|-------|----------|-----------------|
| Stemming | Fast | Lower | No |
| Lemmatization | Slower | Higher | Yes |

## Part-of-Speech (POS) Tagging

Labels each token with its grammatical role: noun, verb, adjective, adverb, etc.

**Universal POS tags:** NOUN, VERB, ADJ, ADV, PRON, DET, ADP, NUM, CONJ, PUNCT, X.

**Methods:**
- HMM-based (Viterbi decoding over tag sequence).
- CRF-based (discriminative sequence labeling).
- Neural (BiLSTM or Transformer encoder; state of the art).

**Uses:** lemmatization disambiguation, dependency parsing, feature engineering.

## Named Entity Recognition (NER)

Identifies and classifies named entities in text: persons, organizations, locations, dates, etc.

See [Information Extraction](10-information-extraction) for detailed treatment.

## Dependency Parsing

Identifies syntactic relationships between words as a directed tree (dependency graph). Each word has a head word and a dependency relation label (subject, object, modifier, etc.).

**Transition-based parsing (arc-eager):** $O(n)$ transitions; fast. Used in spaCy.

**Graph-based parsing (Biaffine):** scores all possible arcs; $O(n^2)$ but highly accurate. Used in stanza.

**Uses:** relation extraction, semantic role labeling, question answering.

## Text Normalization for Specific Domains

**Social media:** expand contractions ("don't" → "do not"), handle hashtags, mentions, emojis, slang.

**Medical text:** expand abbreviations, normalize drug names, handle negation ("no fever").

**Numbers and dates:** normalize "3rd", "three", "3" to a consistent form where needed.

## Preprocessing Pipeline Summary

A typical classical NLP pipeline:

```
raw text
  → clean (strip HTML, fix encoding)
  → sentence segment
  → tokenize
  → lowercase
  → remove stopwords (optional)
  → stem / lemmatize (optional)
  → POS tag (optional)
  → feature extraction (TF-IDF, n-grams)
```

For neural models, most steps are replaced by a learned tokenizer and the model itself. Cleaning (HTML stripping, encoding normalization) and sentence segmentation remain useful.
