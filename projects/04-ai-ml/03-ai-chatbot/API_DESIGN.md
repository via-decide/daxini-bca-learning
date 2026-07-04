# 🤖 AI Chatbot (NLP): Learn By Building

**"Build an intelligent chatbot that understands user intent and generates contextual responses. Master NLP fundamentals."**

---


## 🔌 API Design

### Endpoint 1: Send Message

```
Endpoint: POST /api/message
Purpose: User sends message to chatbot

REQUEST:
{
  "user_id": 123,
  "conversation_id": 456,
  "message": "What's the weather?"
}

RESPONSE (200):
{
  "bot_response": "What location?",
  "detected_intent": "weather_query",
  "confidence": 0.95,
  "entities": [],
  "context": "User asked about weather"
}

RESPONSE (400):
{
  "error": "Empty message"
}
```

### Endpoint 2: Get Conversation

```
Endpoint: GET /api/conversation/:id
Purpose: Retrieve conversation history

REQUEST:
GET /api/conversation/456

RESPONSE (200):
{
  "messages": [
    {
      "user": "Hi!",
      "bot": "Hello! How can I help?",
      "intent": "greeting",
      "timestamp": "2026-01-20T10:30:00Z"
    },
    ...
  ]
}
```

### Endpoint 3: Train Intent

```
Endpoint: POST /api/intents/train
Purpose: Add training data (admin only)

REQUEST:
{
  "sentences": [
    "What's the weather?",
    "How's the weather today?",
    "Tell me the weather"
  ],
  "intent": "weather_query"
}

RESPONSE (200):
{
  "trained": 3,
  "intent": "weather_query",
  "total_training_phrases": 15
}
```

---
