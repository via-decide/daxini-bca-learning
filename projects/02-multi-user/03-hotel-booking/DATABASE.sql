-- 🏨 Hotel Booking System: Database Schema

-- Users & Staff
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('guest', 'receptionist', 'admin')),
  full_name TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Hotel Inventory
CREATE TABLE rooms (
  id TEXT PRIMARY KEY,
  room_number TEXT UNIQUE NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('standard', 'deluxe', 'suite')),
  
  -- Store prices as integers (e.g. cents) or precise decimals, never floats!
  price_per_night DECIMAL(10,2) NOT NULL,
  
  is_active BOOLEAN DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Bookings (The Core Transaction)
CREATE TABLE bookings (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  room_id TEXT NOT NULL,
  
  -- Use DATE types, not DATETIME, for check-in/out boundaries
  check_in_date DATE NOT NULL,
  check_out_date DATE NOT NULL,
  
  total_price DECIMAL(10,2) NOT NULL,
  
  status TEXT DEFAULT 'pending' 
    CHECK (status IN ('pending', 'confirmed', 'checked_in', 'checked_out', 'cancelled')),
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (room_id) REFERENCES rooms(id),
  
  -- Prevent bad data
  CHECK (check_out_date > check_in_date)
);

-- INDEXES FOR PERFORMANCE
-- We constantly query bookings by date and room to check availability
CREATE INDEX idx_bookings_dates ON bookings(check_in_date, check_out_date);
CREATE INDEX idx_bookings_room ON bookings(room_id);
CREATE INDEX idx_bookings_user ON bookings(user_id);