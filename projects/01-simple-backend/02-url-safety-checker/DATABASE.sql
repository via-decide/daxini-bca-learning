-- 🛡️ URL Safety Checker: Database Schema

CREATE TABLE users (
  id TEXT PRIMARY KEY,          -- UUID
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE blocked_domains (
  id TEXT PRIMARY KEY,          -- UUID
  domain TEXT UNIQUE NOT NULL,  -- e.g., "evil-phishing-site.com"
  threat_type TEXT NOT NULL CHECK(threat_type IN ('phishing', 'malware', 'scam', 'spam')),
  added_by TEXT REFERENCES users(id),
  notes TEXT,                   -- Context on why it was blocked
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE scan_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  submitted_url TEXT NOT NULL,
  extracted_domain TEXT NOT NULL,
  is_safe BOOLEAN NOT NULL,
  matched_threat_type TEXT,     -- Nullable, only populated if is_safe is false
  ip_address TEXT,              -- Optional, for rate limiting/analytics
  scanned_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance

-- 1. The Core Lookup Index (CRITICAL)
-- Every time someone scans a URL, we parse out the domain and query:
-- "SELECT * FROM blocked_domains WHERE domain = ?"
-- This MUST be indexed, or scanning will be incredibly slow.
-- Note: The UNIQUE constraint on the 'domain' column automatically creates this index in SQLite/Postgres.

-- 2. Analytics Indexes
-- For the admin dashboard to quickly see recent malicious scans
CREATE INDEX idx_scan_logs_date ON scan_logs(scanned_at);
CREATE INDEX idx_scan_logs_safety ON scan_logs(is_safe, scanned_at);

-- Domain Normalization Note:
-- The database expects normalized domains.
-- It expects "example.com", NOT "http://example.com" or "www.example.com".
-- It is the Backend's responsibility to parse and normalize the URL 
-- BEFORE attempting to INSERT or SELECT from `blocked_domains`.