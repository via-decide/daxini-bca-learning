-- 💼 Freelancer Marketplace API: Database Schema

-- 1. Users (Clients & Freelancers)
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('client', 'freelancer')),
  full_name TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Projects (The Job Posting)
CREATE TABLE projects (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  
  -- The client's estimated budget
  budget DECIMAL(10,2) NOT NULL CHECK (budget > 0),
  
  -- The State Machine
  status TEXT DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'completed')),
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (client_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 3. Bids (The Proposals)
CREATE TABLE bids (
  id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL,
  freelancer_id TEXT NOT NULL,
  
  -- The freelancer's proposed price
  amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
  delivery_days INTEGER NOT NULL CHECK (delivery_days > 0),
  proposal_text TEXT NOT NULL,
  
  -- The State Machine
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected')),
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY (freelancer_id) REFERENCES users(id) ON DELETE CASCADE,
  
  -- CRITICAL: Prevent freelancer from bidding on the same project multiple times
  UNIQUE (project_id, freelancer_id)
);

-- INDEXES
-- Freelancers searching for open projects
CREATE INDEX idx_projects_status ON projects(status) WHERE status = 'open';

-- Clients fetching bids for their project
CREATE INDEX idx_bids_project ON bids(project_id);

-- Freelancers fetching their own bid history
CREATE INDEX idx_bids_freelancer ON bids(freelancer_id);
