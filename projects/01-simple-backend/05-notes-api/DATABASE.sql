-- 📝 Notes API: Database Schema

CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE notes (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title TEXT,                   -- Allowed to be null (quick notes might just have a body)
  content TEXT,                 -- Allowed to be null (might just be a title)
  is_pinned BOOLEAN DEFAULT 0,
  is_archived BOOLEAN DEFAULT 0,
  color TEXT DEFAULT '#FFFFFF', -- UI color code
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tags (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,           -- e.g. "Work", "Personal"
  
  -- A user cannot have two tags with the exact same name
  UNIQUE(user_id, name)
);

-- The Many-to-Many Junction Table
CREATE TABLE note_tags (
  note_id TEXT NOT NULL REFERENCES notes(id) ON DELETE CASCADE,
  tag_id TEXT NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
  
  -- A note cannot have the same tag attached twice
  PRIMARY KEY (note_id, tag_id)
);

-- Indexes for performance

-- 1. Get all notes for a user (Standard lookup)
CREATE INDEX idx_notes_user ON notes(user_id, is_archived, is_pinned);

-- 2. Get all tags for a user
CREATE INDEX idx_tags_user ON tags(user_id);

-- Optional Advanced Feature: SQLite Full-Text Search (FTS5)
-- If you want lightning-fast search (e.g. searching 10,000 notes for the word "apple")
-- a standard `LIKE '%apple%'` query is very slow. 
-- FTS creates a special virtual table optimized for searching text.
-- 
-- CREATE VIRTUAL TABLE notes_fts USING fts5(title, content, content='notes', content_rowid='id');