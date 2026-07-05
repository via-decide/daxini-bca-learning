-- 🗣️ Customer Support Feedback System: Database Schema

-- 1. Users (Role-Based Access Control)
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('admin', 'agent', 'customer')),
  full_name TEXT NOT NULL
);

-- 2. Support Tickets (The thing being reviewed)
CREATE TABLE support_tickets (
  id TEXT PRIMARY KEY,
  customer_id TEXT NOT NULL,
  agent_id TEXT NOT NULL,
  
  issue_description TEXT NOT NULL,
  resolved_at DATETIME NOT NULL,
  
  FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (agent_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 3. Feedback Reviews
CREATE TABLE feedback_reviews (
  id TEXT PRIMARY KEY,
  
  -- The most important constraint: A ticket can only have ONE review.
  -- Making this column UNIQUE creates a 1-to-1 relationship.
  ticket_id TEXT UNIQUE NOT NULL,
  
  customer_id TEXT NOT NULL,
  
  -- We duplicate agent_id here so we don't have to JOIN the tickets table
  -- every single time we want to calculate an agent's average score.
  -- This is called Denormalization for performance.
  agent_id TEXT NOT NULL,
  
  rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comments TEXT,
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (ticket_id) REFERENCES support_tickets(id) ON DELETE CASCADE,
  FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (agent_id) REFERENCES users(id) ON DELETE CASCADE
);

-- INDEXES
-- Fetching the leaderboard requires grouping by agent
CREATE INDEX idx_feedback_agent ON feedback_reviews(agent_id);

-- Fetching a customer's past reviews
CREATE INDEX idx_feedback_customer ON feedback_reviews(customer_id);
