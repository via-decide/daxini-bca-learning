-- 📚 Tutoring Platform API: Database Schema

-- 1. Users (Tutors & Students)
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('tutor', 'student')),
  full_name TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tutor Profiles
CREATE TABLE tutor_profiles (
  id TEXT PRIMARY KEY,
  tutor_id TEXT NOT NULL,
  subjects TEXT NOT NULL, -- e.g., "Math, Physics"
  hourly_rate DECIMAL(6,2) NOT NULL,
  
  FOREIGN KEY (tutor_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE (tutor_id)
);

-- 3. Availability Slots (The Inventory)
CREATE TABLE availability_slots (
  id TEXT PRIMARY KEY,
  tutor_id TEXT NOT NULL,
  
  -- MUST be stored in UTC
  start_time DATETIME NOT NULL,
  end_time DATETIME NOT NULL,
  
  -- True if a student has successfully booked it
  is_booked BOOLEAN DEFAULT 0,
  
  FOREIGN KEY (tutor_id) REFERENCES users(id) ON DELETE CASCADE,
  
  -- Prevent time paradoxes
  CHECK (end_time > start_time)
);

-- 4. Bookings (The Transactions)
CREATE TABLE bookings (
  id TEXT PRIMARY KEY,
  slot_id TEXT NOT NULL,
  student_id TEXT NOT NULL,
  
  status TEXT DEFAULT 'confirmed' CHECK (status IN ('confirmed', 'cancelled')),
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (slot_id) REFERENCES availability_slots(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE
);

-- INDEXES

-- Fast lookup for available slots for a specific tutor
CREATE INDEX idx_slots_available ON availability_slots(tutor_id, is_booked) WHERE is_booked = 0;

-- Students looking up their upcoming sessions
CREATE INDEX idx_bookings_student ON bookings(student_id, status);

-- CRITICAL CONSTRAINT:
-- A single slot can only have ONE 'confirmed' booking.
-- If someone cancels, we can have multiple rows, but only ONE confirmed.
CREATE UNIQUE INDEX idx_unique_confirmed_booking ON bookings(slot_id) WHERE status = 'confirmed';
