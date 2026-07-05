-- ⏱️ Time Tracking API: Database Schema

-- 1. Users (Freelancers)
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL
);

-- 2. Clients (Owned by Users)
CREATE TABLE clients (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  name TEXT NOT NULL,
  email TEXT,
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 3. Projects (Owned by Clients)
CREATE TABLE projects (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  name TEXT NOT NULL,
  
  -- Hourly rate stored as Decimal (e.g. 50.00)
  hourly_rate DECIMAL(10,2) NOT NULL,
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE
);

-- 4. Time Entries (The Core Data)
CREATE TABLE time_entries (
  id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL,
  user_id TEXT NOT NULL, -- Redundant, but makes querying MUCH faster than JOINing all the way up
  
  description TEXT,
  
  -- start_time is required. end_time is NULL if the timer is currently running!
  start_time DATETIME NOT NULL,
  end_time DATETIME,
  
  -- Has this time been invoiced to the client?
  is_billed BOOLEAN DEFAULT 0,
  
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- INDEXES
-- We constantly query for a user's time entries
CREATE INDEX idx_time_user ON time_entries(user_id);

-- We constantly query for unbilled time for a specific project/client
CREATE INDEX idx_time_billing ON time_entries(project_id, is_billed);

-- Quick lookup to see if a user has an active timer (end_time IS NULL)
CREATE INDEX idx_active_timers ON time_entries(user_id) WHERE end_time IS NULL;
