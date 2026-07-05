-- 🎟️ Event Management System: Database Schema

CREATE TABLE users (
  id TEXT PRIMARY KEY,          -- UUID
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  name TEXT NOT NULL,
  role TEXT NOT NULL CHECK(role IN ('organizer', 'attendee', 'admin')),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE events (
  id TEXT PRIMARY KEY,          -- UUID
  organizer_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  location TEXT NOT NULL,       -- e.g., 'Madison Square Garden' or 'Zoom Link'
  start_time DATETIME NOT NULL,
  end_time DATETIME NOT NULL,
  category TEXT NOT NULL,       -- e.g., 'Technology', 'Music'
  status TEXT DEFAULT 'draft' CHECK(status IN ('draft', 'published', 'cancelled')),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ticket_tiers (
  id TEXT PRIMARY KEY,          -- UUID
  event_id TEXT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  name TEXT NOT NULL,           -- e.g., 'VIP', 'General Admission'
  price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  capacity INTEGER NOT NULL,    -- Total tickets allowed to be sold
  sold_count INTEGER DEFAULT 0, -- Current number of tickets sold
  
  -- CRITICAL: Database-level protection against overbooking
  CONSTRAINT check_capacity CHECK (sold_count <= capacity)
);

CREATE TABLE registrations (
  id TEXT PRIMARY KEY,          -- UUID
  event_id TEXT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  total_amount DECIMAL(10, 2) NOT NULL,
  payment_status TEXT DEFAULT 'completed' CHECK(payment_status IN ('pending', 'completed', 'failed', 'refunded')),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tickets (
  id TEXT PRIMARY KEY,          -- UUID
  registration_id TEXT NOT NULL REFERENCES registrations(id) ON DELETE CASCADE,
  tier_id TEXT NOT NULL REFERENCES ticket_tiers(id) ON DELETE CASCADE,
  qr_code TEXT UNIQUE NOT NULL, -- Secure random string for check-in
  status TEXT DEFAULT 'valid' CHECK(status IN ('valid', 'checked_in', 'cancelled')),
  checked_in_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX idx_events_organizer ON events(organizer_id);
CREATE INDEX idx_events_status_category ON events(status, category);
CREATE INDEX idx_ticket_tiers_event ON ticket_tiers(event_id);
CREATE INDEX idx_registrations_user ON registrations(user_id);
CREATE INDEX idx_registrations_event ON registrations(event_id);
CREATE INDEX idx_tickets_registration ON tickets(registration_id);
CREATE INDEX idx_tickets_qrcode ON tickets(qr_code);

-- Note on Concurrency:
-- Because of the `CHECK (sold_count <= capacity)` constraint on `ticket_tiers`,
-- if multiple users try to buy the last ticket simultaneously, the database will 
-- throw a constraint violation error for all but the first successful transaction.
-- The API must catch this SQL error and return a friendly "Sold Out" message.