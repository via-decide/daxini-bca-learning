-- ⛅ Weather App API: Database Schema

-- This is a caching table.
-- In a real-world enterprise app, you would use Redis (an in-memory key-value store)
-- instead of a SQL database for caching, because it is much faster and can 
-- automatically delete rows when they expire (using TTL).
-- However, for learning the pattern, SQLite/Postgres works perfectly fine.

CREATE TABLE weather_cache (
  city_name TEXT PRIMARY KEY,   -- We use the lowercase city name as the unique key
  temperature_c DECIMAL(5,2),   -- E.g. 15.2
  condition TEXT,               -- E.g. "Cloudy"
  icon_code TEXT,               -- E.g. "04d"
  humidity INTEGER,             
  wind_speed DECIMAL(5,2),
  
  -- CRITICAL: This timestamp dictates when the cache is stale
  fetched_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Note: Because city_name is the Primary Key, it automatically gets a Unique Index.
-- When a user requests "london", we query `SELECT * FROM weather_cache WHERE city_name = 'london'`.
-- If the row exists, we check `fetched_at`.
-- If `fetched_at` is older than 10 minutes, we delete/update the row.