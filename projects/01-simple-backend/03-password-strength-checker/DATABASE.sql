-- 🔐 Password Strength Checker: Database Schema

-- ============================================================================
-- ⚠️ WARNING: DO NOT CREATE A DATABASE FOR THIS PROJECT ⚠️
-- ============================================================================

-- This project is explicitly designed to be STATELESS.
-- You should NEVER store user-submitted plaintext passwords in a database.
-- Even for a testing/checking tool, storing this data creates a massive
-- honeypot for hackers. If your database leaks, you are exposing passwords
-- that users likely use on their real accounts (because people reuse passwords).

-- There is no users table.
-- There is no logs table.
-- There is no passwords table.

-- If you MUST log API usage for analytics (e.g. rate limiting), log ONLY:
-- 1. IP Address (hashed)
-- 2. Timestamp
-- 3. The resulting SCORE (e.g., 0, 1, 2, 3, 4)

CREATE TABLE IF NOT EXISTS api_analytics (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  hashed_ip TEXT NOT NULL,
  result_score INTEGER NOT NULL,
  checked_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Note: DO NOT include the actual password string in the analytics table!