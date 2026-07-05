-- 💱 Currency Converter API: Database Schema

-- We use the database primarily as a persistent cache.
-- By storing the rates as JSON, we avoid creating 170+ columns 
-- (one for every currency in the world).

CREATE TABLE exchange_rates_cache (
  base_currency TEXT PRIMARY KEY, -- e.g., 'USD'
  rates_json TEXT NOT NULL,       -- e.g., '{"EUR": 0.85, "GBP": 0.72}'
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Optional: Track usage
CREATE TABLE conversion_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  from_currency TEXT NOT NULL,
  to_currency TEXT NOT NULL,
  amount DECIMAL(15,4) NOT NULL,
  result DECIMAL(15,4) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Note on JSON in SQLite:
-- SQLite handles text perfectly fine, and we parse the JSON in Node.js.
-- If using PostgreSQL, you would use the `JSONB` data type for `rates_json`.