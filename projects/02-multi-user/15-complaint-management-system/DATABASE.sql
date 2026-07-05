-- 📝 Complaint Management System: Database Schema

-- 1. Users
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('citizen', 'worker', 'admin')),
  full_name TEXT NOT NULL
);

-- 2. Categories (e.g., Roads, Sanitation, Noise)
CREATE TABLE categories (
  id TEXT PRIMARY KEY,
  name TEXT UNIQUE NOT NULL
);

-- 3. Complaints (The Core Entity)
CREATE TABLE complaints (
  id TEXT PRIMARY KEY,
  
  -- If a citizen deletes their account, the city still needs to fix the pothole!
  -- SET NULL means the record stays, but is now anonymous.
  citizen_id TEXT, 
  
  category_id TEXT NOT NULL,
  
  -- This is NULL when the status is 'open'. It gets filled when a worker claims it.
  worker_id TEXT,
  
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  
  -- The State Machine constraints
  status TEXT DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'resolved', 'closed')),
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (citizen_id) REFERENCES users(id) ON DELETE SET NULL,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT,
  FOREIGN KEY (worker_id) REFERENCES users(id) ON DELETE SET NULL
);

-- 4. Comments (The Activity Log)
CREATE TABLE comments (
  id TEXT PRIMARY KEY,
  complaint_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  
  content TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (complaint_id) REFERENCES complaints(id) ON DELETE CASCADE,
  -- If a user is deleted, their comments become anonymous but the history remains
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- INDEXES
-- Workers frequently check for 'open' complaints
CREATE INDEX idx_complaints_open ON complaints(status) WHERE status = 'open';

-- Citizens frequently check their own complaints
CREATE INDEX idx_complaints_citizen ON complaints(citizen_id);

-- Fetching the conversation history for a specific complaint
CREATE INDEX idx_comments_complaint ON comments(complaint_id);
