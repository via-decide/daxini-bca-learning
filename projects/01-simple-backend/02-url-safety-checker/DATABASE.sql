-- Schema Design
-- Scans Cache
CREATE TABLE scans_cache (
  id INTEGER PRIMARY KEY,
  url_hash TEXT UNIQUE, -- Hashed URL for fast indexing
  original_url TEXT,
  is_safe BOOLEAN,
  threat_type TEXT,
  scanned_at DATETIME,
  expires_at DATETIME
);

-- Custom Blacklist
CREATE TABLE custom_blacklist (
  id INTEGER PRIMARY KEY,
  domain TEXT UNIQUE,
  reason TEXT,
  added_at DATETIME
);