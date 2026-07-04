# 🤖 AI Chatbot (NLP): Learn By Building

**"Build an intelligent chatbot that understands user intent and generates contextual responses. Master NLP fundamentals."**

---


## 🧪 Testing: How to Verify

### Test 1: Intent Classification

```
Test: Can it identify intent correctly?

Inputs:
- "What's the weather?" → weather_query ✓
- "Hi there" → greeting ✓
- "I want pizza" → food_order ✓
- "Tell me a joke" → entertainment ✓

Expected: 90%+ accuracy
```

### Test 2: Entity Extraction

```
Test: Can it pull out important data?

Input: "Weather in Mumbai tomorrow"
Expected Entities:
- location: "Mumbai" ✓
- date: "tomorrow" ✓
- intent: weather_query ✓
```

### Test 3: Context Memory

```
Test: Does it remember previous messages?

User: "Weather in Mumbai?"
Bot: "Sunny, 28°C"

User: "How about tomorrow?" 
Bot: Should know "tomorrow" in Mumbai context ✓
```

### Test 4: Response Quality

```
Test: Are responses natural and helpful?

Criteria:
- Grammatically correct ✓
- Contextually relevant ✓
- Specific to intent ✓
- No generic "I don't know" ✓
```

### Test 5: Fallback Handling

```
Test: What happens on unknown intent?

Input: "xyzabc qwerty"
Expected:
- Confidence < 0.5
- Bot asks clarification ✓
- Doesn't crash ✓
```

---


## 🐛 Debugging: When Things Break

### Problem: "Bot always classifies as 'other' intent"

**Root Causes:**
1. Model not trained enough
2. Intent categories too similar
3. Preprocessing removing important words
4. Model weights incorrect

**Debug Steps:**
```
1. Check training data:
   - How many examples per intent?
   - Are they diverse?
   - Are they labeled correctly?

2. Check preprocessing:
   - What's being removed?
   - Is that hurting classification?
   - Try without preprocessing

3. Check model:
   - Print confidence scores for each intent
   - Is 0.3 going to "other"?
   - Retrain with more data

4. Test step by step:
   print("Input:", message)
   print("After preprocess:", cleaned)
   print("Intent scores:", scores)
   print("Chosen intent:", best_intent)
```

### Problem: "Bot remembers wrong context"

**Root Causes:**
1. Not storing context properly
2. Context expires too quickly
3. Retrieving context incorrectly
4. Mixing up conversations

**Debug:**
```
1. Check context storage:
   - What's being saved?
   - Is it timestamped?
   - Can you retrieve it?

2. Check context retrieval:
   - Getting right conversation?
   - Getting right timeframe?
   - Merging correctly?

3. Test with fresh conversation:
   - Start new session
   - Does it still fail?
   - Or was it old context issue?
```

---
