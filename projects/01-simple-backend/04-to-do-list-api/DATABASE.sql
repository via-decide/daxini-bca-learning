-- 📝 To-Do List API: Database Schema

CREATE TABLE users (
  id TEXT PRIMARY KEY,          -- UUID
  username TEXT UNIQUE NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tasks (
  id TEXT PRIMARY KEY,          -- UUID
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,          -- The main to-do item
  description TEXT,             -- Optional details
  is_completed BOOLEAN DEFAULT 0, -- 0 for false, 1 for true
  due_date DATETIME,            -- Optional deadline
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance

-- 1. The primary lookup index
-- Every time a user fetches their tasks, we query by user_id
CREATE INDEX idx_tasks_user ON tasks(user_id);

-- 2. Compound index for filtering
-- If the frontend frequently requests "Show me pending tasks for User A ordered by due_date"
CREATE INDEX idx_tasks_user_status ON tasks(user_id, is_completed, due_date);

-- Security Note:
-- The `ON DELETE CASCADE` on the `user_id` foreign key is important.
-- If a user deletes their account (deleting the row in `users`), the database
-- will automatically delete every single task they ever created.
-- This ensures you don't end up with "orphan" tasks clogging your database.