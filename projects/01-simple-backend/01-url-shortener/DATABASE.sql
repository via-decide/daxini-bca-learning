-- 🔗 URL Shortener: Database Schema

CREATE TABLE users (
  id TEXT PRIMARY KEY,          -- UUID
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE urls (
  id TEXT PRIMARY KEY,          -- UUID
  user_id TEXT REFERENCES users(id) ON DELETE CASCADE, -- Nullable for anonymous users
  original_url TEXT NOT NULL,
  short_code TEXT UNIQUE NOT NULL, -- e.g. "x7b21q"
  clicks INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE click_analytics (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  url_id TEXT NOT NULL REFERENCES urls(id) ON DELETE CASCADE,
  ip_address TEXT,              -- Optional/Hashed for privacy
  user_agent TEXT,              -- e.g. "Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X)..."
  referrer TEXT,                -- e.g. "https://twitter.com" or "Direct"
  clicked_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance

-- 1. The Redirect Lookup Index (CRITICAL)
-- Every single time someone clicks a link, we query: "SELECT original_url FROM urls WHERE short_code = ?"
-- This index makes that query instant (O(log n)). Without it, the DB does a full table scan.
CREATE UNIQUE INDEX idx_urls_shortcode ON urls(short_code);

-- 2. Dashboard Index
-- For when a user logs in and wants to see all their created URLs
CREATE INDEX idx_urls_user ON urls(user_id);

-- 3. Analytics Index
-- For generating charts on the dashboard
CREATE INDEX idx_analytics_url ON click_analytics(url_id);
CREATE INDEX idx_analytics_date ON click_analytics(clicked_at);

-- A note on Click Analytics:
-- The `click_analytics` table will grow HUGE very quickly. 
-- If a link goes viral, it could get 1,000,000 clicks in a day.
-- This is why storing `clicks` as an integer on the `urls` table is important—
-- we can quickly show total clicks without having to COUNT() 1,000,000 rows.