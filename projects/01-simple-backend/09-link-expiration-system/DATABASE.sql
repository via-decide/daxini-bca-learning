-- 🔗 Link Expiration System: Database Schema

CREATE TABLE links (
  id TEXT PRIMARY KEY,               -- e.g. 'j9F2kL'
  target_url TEXT NOT NULL,
  
  -- Validation Limits
  max_clicks INTEGER,                -- NULL means unlimited
  expires_at DATETIME,               -- NULL means it never expires
  
  -- Tracking State
  current_clicks INTEGER DEFAULT 0,
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- We don't need complex indexes because we only query by Primary Key (id).