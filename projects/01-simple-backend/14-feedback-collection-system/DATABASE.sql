-- 📝 Feedback Collection System: Database Schema

-- Table 1: The Forms
CREATE TABLE forms (
  -- We allow admins to create their own IDs (e.g. 'beta-feedback') so URLs look nice
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  is_active BOOLEAN DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table 2: The Responses
CREATE TABLE responses (
  id TEXT PRIMARY KEY,               -- UUID
  form_id TEXT NOT NULL,
  
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,                      -- Comments are optional
  
  -- Anonymized hash of the user's IP to prevent double voting
  voter_hash TEXT NOT NULL,
  
  submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  -- The Foreign Key links this response to a specific form
  FOREIGN KEY (form_id) REFERENCES forms(id)
);

-- INDEXES FOR PERFORMANCE
-- When an admin requests analytics, the database will search the 
-- responses table by form_id. If we have 1 million responses, this 
-- index makes that search instant.
CREATE INDEX idx_responses_form_id ON responses(form_id);

-- Prevent the exact same voter_hash from submitting to the same form_id twice
CREATE UNIQUE INDEX idx_unique_vote ON responses(form_id, voter_hash);