# 🤖 AI Chatbot (NLP): Learn By Building

**"Build an intelligent chatbot that understands user intent and generates contextual responses. Master NLP fundamentals."**

---


## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data

**Question: What information must you store?**

Think about:
1. What conversations have you had?
2. What intents does the bot understand?
3. How do you remember context?
4. How do you measure success?
5. What data makes the bot smarter?

**After thinking, here's the data model:**

```
Messages (Conversation History)
├─ id
├─ user_id
├─ timestamp
├─ user_message (what user said)
├─ detected_intent (what we think they want)
├─ extracted_entities (important data)
├─ bot_response (what bot said)
├─ confidence_score (how sure we are)
└─ feedback (was this helpful?)

Intents (What the bot understands)
├─ id
├─ name (weather_query, greeting, etc)
├─ description
├─ training_phrases (examples)
└─ response_templates

Entities (Important information)
├─ id
├─ name (location, date, person, etc)
├─ type (what kind of data?)
├─ examples
└─ extraction_rules

Conversation Sessions
├─ id
├─ user_id
├─ start_time
├─ end_time
├─ total_messages
├─ conversation_context (what we remember)
└─ satisfaction_score

Training Data
├─ id
├─ sentence
├─ intent_label
├─ entity_annotations
└─ verified (human approved?)
```

### Step 2: Architecture Diagram

```
┌─────────────────────────────────────────────────┐
│              Frontend (React/Vue)               │
│  ┌───────────────────────────────────────────┐  │
│  │ Chat Interface                            │  │
│  │ - Message display                         │  │
│  │ - Input field                             │  │
│  │ - Typing indicator                        │  │
│  │ - Conversation history                    │  │
│  └───────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
                      │
            WebSocket / HTTP API
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│            Backend (Node/Python)                │
│  ┌───────────────────────────────────────────┐  │
│  │ API Server                                │  │
│  │ - Handle incoming messages                │  │
│  │ - Route to NLP engine                     │  │
│  │ - Send responses back                     │  │
│  └───────────────────────────────────────────┘  │
│                      │                          │
│  ┌──────────────────┴──────────────────────┐   │
│  │                                          │   │
│  ▼                                          ▼   │
│ ┌──────────────────┐          ┌──────────────┐ │
│ │ NLP Pipeline     │          │ Knowledge    │ │
│ │ 1. Preprocess   │          │ Base         │ │
│ │ 2. Classify     │          │ - Facts      │ │
│ │ 3. Extract      │          │ - Rules      │ │
│ │ 4. Generate     │          │ - Context    │ │
│ └──────────────────┘          └──────────────┘ │
│                                                 │
└─────────────────────────────────────────────────┘
                      │
            Database Queries
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│         Database (SQLite/PostgreSQL)            │
│ - Conversations                                 │
│ - Messages                                      │
│ - Intents                                       │
│ - Training data                                 │
│ - User feedback                                 │
└─────────────────────────────────────────────────┘
```

### Step 3: Data Flow

```
User types message
       │
       ▼
Message sent to server (WebSocket/HTTP)
       │
       ▼
Server receives: "What's the weather?"
       │
       ▼
Step 1: Preprocessing
   Input: "What's the weather?"
   Output: "whats the weather" (lowercase, no punctuation)
       │
       ▼
Step 2: Intent Classification
   Input: "whats the weather"
   Model: "This is a weather_query intent"
   Confidence: 95%
       │
       ▼
Step 3: Entity Extraction
   Input: "whats the weather"
   Entities: (none found)
   Questions: Should we ask "where" or "when"?
       │
       ▼
Step 4: Context Retrieval
   Previous messages from this user?
   Any location preference stored?
   Time context?
       │
       ▼
Step 5: Response Generation
   Generate response based on:
   - Intent (weather_query)
   - Entities (none)
   - Context (user's preferred location?)
   - Response templates
       │
       ▼
Step 6: Send Response
   "I need to know your location to check weather. Where are you?"
       │
       ▼
Save to database:
   - Original message
   - Detected intent
   - Confidence score
   - Response given
   - Timestamp
```

---
