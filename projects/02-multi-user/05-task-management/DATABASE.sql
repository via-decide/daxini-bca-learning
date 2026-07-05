-- Task Management System (Trello Clone): Database Schema Design

-- Password Hashing Strategy:
-- When user registers:
--   1. Take password: "mypassword"
--   2. Hash it: bcryptjs.hash("mypassword", 10)
--   3. Result: "$2a$10$N9qo8uLOic..."
--   4. Store the HASH, never the plaintext

-- When user logs in:
--   1. Get plaintext password from login form
--   2. Get stored hash from database
--   3. Compare: bcryptjs.compare("mypassword", "$2a$10$...")
--   4. Result: true/false

CREATE TABLE users (
  id TEXT PRIMARY KEY,          -- UUID
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  name TEXT NOT NULL,
  avatar_url TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE boards (
  id TEXT PRIMARY KEY,          -- UUID
  title TEXT NOT NULL,
  description TEXT,
  background_color TEXT DEFAULT '#1a1a2e',
  owner_id TEXT NOT NULL REFERENCES users(id),
  is_archived BOOLEAN DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE board_members (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  board_id TEXT NOT NULL REFERENCES boards(id) ON DELETE CASCADE,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK(role IN ('admin', 'editor', 'viewer')),
  joined_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(board_id, user_id)   -- Prevent duplicate memberships
);

CREATE TABLE columns (
  id TEXT PRIMARY KEY,          -- UUID
  board_id TEXT NOT NULL REFERENCES boards(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  position TEXT NOT NULL,       -- Lexicographic sorting (e.g., 'a', 'n', 'z')
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cards (
  id TEXT PRIMARY KEY,          -- UUID
  column_id TEXT NOT NULL REFERENCES columns(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,             -- Supports markdown
  position TEXT NOT NULL,       -- Lexicographic sorting
  assigned_to TEXT REFERENCES users(id) ON DELETE SET NULL,
  due_date DATE,
  label_color TEXT,             -- e.g., '#ff671f', '#22c55e'
  is_archived BOOLEAN DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE activity_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  board_id TEXT NOT NULL REFERENCES boards(id) ON DELETE CASCADE,
  user_id TEXT NOT NULL REFERENCES users(id),
  card_id TEXT REFERENCES cards(id) ON DELETE SET NULL,
  action TEXT NOT NULL,         -- 'created', 'moved', 'assigned', 'archived', 'invited'
  details TEXT,                 -- JSON: {"from_column": "To Do", "to_column": "Done"}
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX idx_board_members_board ON board_members(board_id);
CREATE INDEX idx_board_members_user ON board_members(user_id);
CREATE INDEX idx_columns_board ON columns(board_id);
CREATE INDEX idx_cards_column ON cards(column_id);
CREATE INDEX idx_cards_assigned ON cards(assigned_to);
CREATE INDEX idx_activity_board ON activity_log(board_id);
CREATE INDEX idx_activity_created ON activity_log(created_at);

-- Lexicographic Position Strategy:
-- Columns: "a", "n", "z" (To Do, In Progress, Done)
-- Cards within a column: "a", "c", "e", "g"...
--
-- To insert between "a" and "c": new position = "b"
-- To insert between "a" and "b": new position = "an" (extend string)
-- To insert at the end: append after last position
--
-- This ensures O(1) database writes per drag operation.