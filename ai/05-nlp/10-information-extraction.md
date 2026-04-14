# Information Extraction

Information extraction (IE) converts unstructured text into structured representations: entities, relationships, events, and facts. IE systems make implicit knowledge in text queryable and actionable.

## Named Entity Recognition (NER)

NER identifies and classifies named entities: spans of text that refer to specific persons, organizations, locations, dates, quantities, etc.

**Standard entity types (CoNLL-2003):** PER (person), ORG (organization), LOC (location), MISC (miscellaneous).

**Richer tagsets (OntoNotes):** 18 types including DATE, TIME, MONEY, PERCENT, CARDINAL, etc.

**Sequence labeling formulation (BIO tagging):**

| Token | Tag |
|-------|-----|
| Barack | B-PER |
| Obama | I-PER |
| visited | O |
| Berlin | B-LOC |

B = beginning of entity, I = inside entity, O = outside any entity. Extensions: BIOES (end, single).

**Models:**

- **CRF (Conditional Random Field):** discriminative sequence model over handcrafted features. $p(y|x) \propto \exp(\sum_t \sum_k \lambda_k f_k(y_t, y_{t-1}, x, t))$. Viterbi decoding finds the globally optimal tag sequence.

- **BiLSTM-CRF:** BiLSTM produces contextual token representations; CRF decodes the optimal tag sequence. Strong pre-Transformer baseline.

- **BERT + linear CRF:** fine-tune BERT; add a linear classification head per token (or a CRF on top). Current standard.

**Span-based NER:** enumerate candidate spans and classify each as an entity type or non-entity. Handles nested entities (entities within entities).

## Relation Extraction

Given a pair of entities $(e_1, e_2)$ in a text, determine the relation $r$ between them.

**Example:** "Steve Jobs founded Apple in 1976." → (Steve Jobs, founded, Apple).

**Formulation:**
- **Sentence-level:** classify the relation for an entity pair within a single sentence.
- **Document-level:** the relation evidence may span multiple sentences.

**Supervised RE:**

1. Identify entity pairs (from NER output or given).
2. Encode the sentence with markers around each entity.
3. Classify the relation with a softmax head.

**Entity marker encoding:**

$$\text{[E1] Steve Jobs [/E1] founded [E2] Apple [/E2] in 1976.}$$

The representation of the `[E1]` token (or a span pooling of the entity) is used for classification.

**Distant supervision (Mintz et al. 2009):** align a knowledge base with text; any sentence mentioning two entities that have a relation in the KB is labeled with that relation. Generates large training sets but with noisy labels.

## Event Extraction

Identify event triggers (words signaling an event), event types, and event arguments (who did what to whom, where, when).

**ACE event types:** 33 event types (e.g., Attack, Elect, Die, Transfer-Money).

**Subtasks:**
1. **Trigger identification:** find the word/phrase that signals the event.
2. **Event type classification:** classify the trigger into an event type.
3. **Argument extraction:** extract and classify the roles of participants.

**Example:** "The bomb exploded in the market." → Trigger: "exploded" (Attack), Place: "market".

**Joint extraction models:** jointly predict triggers and arguments with shared representations; avoids error propagation from pipeline approaches.

## Coreference Resolution

Determine which mentions in a text refer to the same real-world entity (antecedent).

**Example:** "Alice told **her** that **she** was wrong." → all bolded pronouns refer to one entity (or two?).

**Formulation:** for all mention pairs $(m_i, m_j)$ with $i < j$, predict whether they are coreferent.

**End-to-end model (Lee et al. 2017):** enumerate all candidate spans up to a length limit; score each pair for coreference; cluster mentions with the same antecedent. Trained end-to-end with cross-entropy or marginal loss.

**LingMess, S2E:** Transformer-based end-to-end systems; current state of the art on OntoNotes.

## Slot Filling and Template Filling

Fill predefined slots in templates with extracted values.

**Example (hotel booking):** Template `{hotel_name, check_in, check_out, num_guests}` extracted from "Book a room at the Marriott from Monday to Wednesday for two."

**Information Extraction systems for KG construction:** extract (subject, predicate, object) triples from text to populate knowledge graphs. OpenIE systems extract triples without a predefined relation schema.

## Temporal and Numerical Extraction

**Date/time normalization:** map "last Tuesday", "Q3 2024", "3 months ago" to ISO 8601 format. SUTime (Stanford), HeidelTime.

**Number normalization:** "3 million", "three hundred" → structured numeric values with units.

**Event timeline:** order extracted events along a timeline using temporal relations (BEFORE, AFTER, SIMULTANEOUS). TimeML specification.

## Evaluation

**NER:** span-level precision, recall, F1. A predicted span is correct only if both the span boundaries and the entity type are correct.

**Relation extraction:** precision, recall, F1 over (entity1, relation, entity2) triples.

**Coreference:** CoNLL F1: average of MUC, B-CUBED, CEAFE metrics.

## End-to-End IE with LLMs

Instruction-tuned LLMs (GPT-4, Claude) can perform all IE subtasks in a zero-shot or few-shot setting via prompting:

```
Extract all (subject, relation, object) triples from the following text:
"Apple was founded by Steve Jobs, Steve Wozniak, and Ronald Wayne in 1976."
```

Output: JSON list of triples.

**Advantages:** no task-specific training data; flexible to new entity types and relations.

**Disadvantages:** lower precision on domain-specific schemas; hallucination risk; slower than specialized extractors for high-throughput pipelines.
