-- ✉️ Email Scheduler API: Database Schema

CREATE TABLE users (
  id TEXT PRIMARY KEY,          -- UUID
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE contacts (
  id TEXT PRIMARY KEY,          -- UUID
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  name TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, email)        -- Prevent duplicate contacts per user
);

CREATE TABLE scheduled_emails (
  id TEXT PRIMARY KEY,          -- UUID
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  recipient_email TEXT NOT NULL,
  subject TEXT NOT NULL,
  body_text TEXT NOT NULL,
  body_html TEXT,
  scheduled_for DATETIME NOT NULL,
  
  -- Workflow states: pending -> processing -> sent/failed
  -- Also supports: cancelled
  status TEXT NOT NULL DEFAULT 'pending' CHECK(status IN ('pending', 'processing', 'sent', 'failed', 'cancelled')),
  
  -- Retry mechanism fields
  attempt_count INTEGER DEFAULT 0,
  last_error TEXT,
  
  -- Audit fields
  sent_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX idx_contacts_user ON contacts(user_id);
CREATE INDEX idx_emails_user ON scheduled_emails(user_id);

-- This is the MOST CRITICAL index for the background worker.
-- The worker will constantly query: "WHERE status = 'pending' AND scheduled_for <= NOW()"
-- Without this index, the database would do a full table scan every minute.
CREATE INDEX idx_emails_worker_queue ON scheduled_emails(status, scheduled_for);