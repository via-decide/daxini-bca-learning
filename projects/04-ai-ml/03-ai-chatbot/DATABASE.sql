-- Schema Design
-- Conversations
CREATE TABLE conversations (
  id INTEGER PRIMARY KEY,
  user_id INTEGER,
  start_time DATETIME,
  end_time DATETIME,
  satisfaction INTEGER,
  context_summary TEXT -- What we remember
);

-- Messages
CREATE TABLE messages (
  id INTEGER PRIMARY KEY,
  conversation_id INTEGER FOREIGN KEY,
  timestamp DATETIME,
  user_message TEXT,
  detected_intent TEXT,
  confidence FLOAT,
  extracted_entities TEXT (JSON),
  bot_response TEXT,
  was_helpful INTEGER
);

-- Intents
CREATE TABLE intents (
  id INTEGER PRIMARY KEY,
  name TEXT UNIQUE,
  description TEXT,
  training_phrases TEXT (JSON array)
);

-- Training Data
CREATE TABLE training_data (
  id INTEGER PRIMARY KEY,
  sentence TEXT,
  intent_label TEXT FOREIGN KEY,
  entity_annotations TEXT (JSON),
  verified INTEGER
);