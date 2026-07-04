# 🤖 AI Chatbot (NLP): Learn By Building

**"Build an intelligent chatbot that understands user intent and generates contextual responses. Master NLP fundamentals."**

---


## ⚠️ Common Mistakes

### ❌ Mistake 1: Hardcoded Responses

**Wrong:**
```pseudocode
if message.contains("weather"):
  return "It's sunny"
if message.contains("greeting"):
  return "Hello!"
```

**Problem:**
- Doesn't scale
- No learning
- Breaks with slight variations
- Bot seems dumb

**Right:**
```pseudocode
// Classify intent using model
intent = classify_intent(message)
// Generate response from template
response = generate_from_template(intent)
```

---

### ❌ Mistake 2: No Context Memory

**Wrong:**
```pseudocode
User: "What's the weather?"
Bot: "Which location?"
User: "Mumbai"
Bot: "Which location?" // Forgot previous!
```

**Problem:**
- User has to repeat
- Bad UX
- Seems like bot doesn't listen

**Right:**
```pseudocode
function getResponse(message):
  previous_messages = get_conversation_history()
  context = build_context(previous_messages)
  
  response = generate_response(message, context)
  return response
```

---

### ❌ Mistake 3: Low Confidence Triggers Response

**Wrong:**
```pseudocode
if confidence > 0.3:  // Very low threshold!
  return response
```

**Problem:**
- Bot guesses wrong 70% of the time
- User frustrated
- Loses trust

**Right:**
```pseudocode
if confidence > 0.7:
  return response
else:
  return "I'm not sure. Did you mean...?"
```

---

### ❌ Mistake 4: No Training

**Wrong:**
```
Bot uses static intent list
Never learns new patterns
Can't improve
```

**Right:**
```
Track conversations
Identify misclassifications
Add training data
Retrain model
Measure improvement
```

---
