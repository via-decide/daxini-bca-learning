-- ⏱️ Timer & Countdown Service: Database Schema

CREATE TABLE timers (
  id TEXT PRIMARY KEY,          -- Short unique ID (e.g., 'x8f9Z')
  title TEXT NOT NULL,
  
  -- The exact moment the timer expires. 
  -- Saved as a standard text string in ISO 8601 format (UTC).
  target_datetime TEXT NOT NULL, 
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- We don't need complex indexes because we only query by Primary Key (id).