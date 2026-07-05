-- 👔 Project Management System: Database Schema

-- 1. Users
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  full_name TEXT NOT NULL
);

-- 2. Projects (Top Level)
CREATE TABLE projects (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  owner_id TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (owner_id) REFERENCES users(id)
);

-- 3. Tickets (Child of Projects)
CREATE TABLE tickets (
  id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  
  -- The core state machine
  status TEXT DEFAULT 'to_do' 
    CHECK (status IN ('to_do', 'in_progress', 'review', 'done')),
    
  assignee_id TEXT, -- Can be NULL if unassigned
  reporter_id TEXT NOT NULL,
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  -- ON DELETE CASCADE: If project is deleted, delete this ticket!
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY (assignee_id) REFERENCES users(id),
  FOREIGN KEY (reporter_id) REFERENCES users(id)
);

-- 4. Comments (Child of Tickets)
CREATE TABLE comments (
  id TEXT PRIMARY KEY,
  ticket_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  content TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  -- ON DELETE CASCADE: If ticket is deleted, delete this comment!
  FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- INDEXES
-- Fetching a Kanban board requires getting all tickets for a specific project
CREATE INDEX idx_tickets_project ON tickets(project_id);
-- Fetching a user's dashboard requires getting all their assigned tickets
CREATE INDEX idx_tickets_assignee ON tickets(assignee_id);
-- Fetching a ticket requires getting all its comments
CREATE INDEX idx_comments_ticket ON comments(ticket_id);
