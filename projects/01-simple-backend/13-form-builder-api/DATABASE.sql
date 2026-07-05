-- 📝 Form Builder API (Typeform Clone): Database Schema

CREATE TABLE users (
  id TEXT PRIMARY KEY,          -- UUID
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE forms (
  id TEXT PRIMARY KEY,          -- UUID
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  is_published BOOLEAN DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE questions (
  id TEXT PRIMARY KEY,          -- UUID
  form_id TEXT NOT NULL REFERENCES forms(id) ON DELETE CASCADE,
  question_text TEXT NOT NULL,
  type TEXT NOT NULL CHECK(type IN ('text', 'long_text', 'radio', 'checkbox', 'rating', 'email')),
  options TEXT,                 -- JSON array for radio/checkbox (e.g. '["Red", "Blue"]')
  is_required BOOLEAN DEFAULT 0,
  position INTEGER NOT NULL,    -- To maintain order of questions
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE submissions (
  id TEXT PRIMARY KEY,          -- UUID
  form_id TEXT NOT NULL REFERENCES forms(id) ON DELETE CASCADE,
  ip_address TEXT,              -- Optional, for basic spam prevention
  submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE answers (
  id TEXT PRIMARY KEY,          -- UUID
  submission_id TEXT NOT NULL REFERENCES submissions(id) ON DELETE CASCADE,
  question_id TEXT NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  value TEXT NOT NULL           -- The actual answer text. Checkboxes might be stored as '["Red", "Blue"]' JSON string.
);

-- Indexes for fast querying
CREATE INDEX idx_forms_user ON forms(user_id);
CREATE INDEX idx_questions_form ON questions(form_id);
CREATE INDEX idx_submissions_form ON submissions(form_id);
CREATE INDEX idx_answers_submission ON answers(submission_id);
CREATE INDEX idx_answers_question ON answers(question_id);

-- Note on the 'answers' table:
-- 'value' is stored as TEXT. If the question type is 'checkbox' (multiple choice),
-- the client should send the answers as a JSON string array '["Apple", "Banana"]',
-- which we just store directly in this TEXT column.