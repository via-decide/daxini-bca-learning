-- 💻 Code Snippet Storage API: Database Schema

CREATE TABLE snippets (
  -- We use a short TEXT ID (like 'aBcD12') instead of an Integer or UUID.
  -- Integers (1, 2, 3) are easily guessable. UUIDs are too long for URLs.
  id TEXT PRIMARY KEY,
  
  content TEXT NOT NULL,
  
  -- The programming language (for frontend syntax highlighting)
  language TEXT DEFAULT 'plaintext',
  
  -- Boolean flag
  is_burn_after_reading BOOLEAN DEFAULT 0,
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- We don't need any complex indexes here because we only ever 
-- look up snippets by their exact Primary Key (id). 
-- Primary Keys are automatically indexed.