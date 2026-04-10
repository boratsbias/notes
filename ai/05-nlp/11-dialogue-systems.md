# Dialogue Systems

Dialogue systems enable natural language conversation between humans and machines. They range from narrow task-oriented systems (booking a flight) to open-domain conversational agents (ChatGPT).

## Types of Dialogue Systems

| Type | Goal | Examples |
|------|------|---------|
| Task-oriented dialogue (TOD) | Complete a specific task | Siri, Alexa, booking assistants |
| Open-domain chatbot | Engage in general conversation | BlenderBot, ChatGPT |
| Question answering system | Answer factual questions | See [Question Answering](08-question-answering) |
| Social chatbot | Empathetic, emotional engagement | Replika, Woebot |

## Task-Oriented Dialogue

The system helps the user achieve a goal (e.g., booking a restaurant, troubleshooting a device) within a defined domain.

### Pipeline Architecture

Classical modular pipeline:

```
User utterance
  → Natural Language Understanding (NLU)
      → Intent classification
      → Slot filling
  → Dialogue State Tracking (DST)
  → Dialogue Policy
  → Natural Language Generation (NLG)
  → System response
```

### Natural Language Understanding

**Intent classification:** classify the user's goal.

Examples: `BookRestaurant`, `GetWeather`, `PlayMusic`.

Multi-class classification over the utterance (BERT fine-tune or zero-shot with an LLM).

**Slot filling:** extract key-value pairs from the utterance.

Example: "Book a table for two at noon on Friday." → `{num_guests: 2, time: 12:00, day: Friday}`.

Joint intent-slot models (JointBERT, SlotFilling-BERT) predict both simultaneously.

### Dialogue State Tracking

Maintain the current state (belief state) of the conversation: a set of slot-value pairs representing what the user wants so far.

**Example belief state after multiple turns:**

```
domain: restaurant
  food: Italian
  area: city centre
  price: moderate
  num_guests: 2
```

**Approaches:**

- **Ontology-based:** for each slot, classify over a predefined set of possible values. Fails on unseen values (e.g., new restaurant names).
- **Generative (TRADE, SimpleTOD):** generate slot values directly from the conversation history. Handles unseen values.
- **LLM-based:** prompt an LLM with the conversation and ask it to fill in the belief state as JSON.

**MultiWOZ:** the standard benchmark for TOD. Covers 7 domains; ~10k dialogues.

### Dialogue Policy

Maps the current belief state to a system action (which API to call, what to confirm, what to ask next).

**Rule-based:** handcrafted decision trees or finite-state machines. Robust; brittle to new scenarios.

**Reinforcement learning:** model dialogue as a Markov decision process (MDP). State: belief state + history. Actions: system dialogue acts. Reward: task completion + dialogue efficiency (fewer turns). Policy network optimized with policy gradient (REINFORCE, PPO).

### Natural Language Generation

Map the system action to a natural language response.

**Template-based:** fill slots into predefined templates. Simple; unnatural.

**Neural NLG:** encoder-decoder model conditioned on the dialogue act representation. Produces more natural text.

**LLM NLG:** prompt an LLM with the system action; generates fluent, natural text automatically.

### End-to-End TOD Systems

Train a single seq2seq model to map (conversation history, database results) to the system response. SimpleTOD, T5-based, GPT-based end-to-end models. Trade interpretability for flexibility.

## Open-Domain Chatbots

No specific task or domain. Goal is engaging, coherent, natural conversation.

**Retrieval-based:** given the conversation history, retrieve the most relevant response from a corpus. Fast; responses are always fluent (human-written). Limited to seen responses.

**Generative (seq2seq):** generate a response token by token. Flexible; tends toward generic "I don't know" responses and lacks factual grounding.

**Persona-based:** condition the model on a persona description to produce consistent, interesting responses. PersonaChat dataset.

**Blenderbot (Facebook):** combines retrieval and generation; incorporates knowledge, persona, and empathy modules. Trained on a large social media corpus.

**LLM-based chatbots (ChatGPT, Claude):** instruction-tuned large language models. Combine vast knowledge, coherent multi-turn reasoning, and instruction following. Dominate the field as of 2024.

## Instruction Tuning and RLHF

Modern dialogue systems are created by fine-tuning large language models in two stages:

1. **Supervised Fine-Tuning (SFT):** fine-tune on curated (instruction, response) pairs. Teaches the model to follow conversational norms.

2. **Reinforcement Learning from Human Feedback (RLHF):**
   - Collect human preference comparisons between model responses.
   - Train a **reward model** $r(x, y)$ to predict human preference.
   - Fine-tune the language model with PPO to maximize expected reward, with a KL penalty against the SFT model to prevent reward hacking:

$$\mathcal{L}_\text{RLHF} = \mathbb{E}[r(x, y)] - \beta \cdot D_\text{KL}(\pi_\theta || \pi_\text{SFT})$$

**DPO (Direct Preference Optimization):** eliminates the explicit reward model; directly optimizes the LLM on preference pairs using a closed-form objective. More stable training.

## Evaluation

**Task-oriented:**
- **Task completion rate:** did the system complete the user's goal?
- **Slot accuracy:** are extracted slot values correct?
- **Inform rate:** did the system provide the requested information?
- **Dialogue turns:** fewer turns for the same outcome is better.

**Open-domain:**
- **Automatic:** BLEU, METEOR, BERTScore against reference responses.
- **Human:** overall quality, engagement, consistency, factual accuracy (rated by annotators).
- **Chatbot Arena:** human preference-based ELO ranking (lmarena.ai).

## Challenges

**Multi-turn coherence:** maintaining consistent context, persona, and factual state over long conversations.

**Hallucination:** open-domain chatbots may state false facts with high confidence.

**Safety and alignment:** avoiding harmful, offensive, or manipulative outputs. Requires careful RLHF and safety fine-tuning.

**Grounding:** connecting responses to real-world facts, retrieved documents, or a database.

**Handling ambiguity:** the user's intent may be underspecified; the system must ask clarifying questions.
