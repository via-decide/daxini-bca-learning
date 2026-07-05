-- 🩺 Clinic Appointments API: Database Schema

-- 1. Users
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('doctor', 'patient')),
  full_name TEXT NOT NULL
);

-- 2. Doctor Schedules (Their general weekly availability)
CREATE TABLE doctor_schedules (
  id TEXT PRIMARY KEY,
  doctor_id TEXT NOT NULL,
  
  -- 0 = Sunday, 1 = Monday ... 6 = Saturday
  day_of_week INTEGER NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
  
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  
  FOREIGN KEY (doctor_id) REFERENCES users(id) ON DELETE CASCADE,
  
  -- A doctor can only have one schedule row per day of the week
  UNIQUE(doctor_id, day_of_week),
  
  -- Sanity check
  CHECK (end_time > start_time)
);

-- 3. Appointments
CREATE TABLE appointments (
  id TEXT PRIMARY KEY,
  doctor_id TEXT NOT NULL,
  patient_id TEXT NOT NULL,
  
  appointment_date DATE NOT NULL,
  start_time TIME NOT NULL,
  
  status TEXT DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'completed', 'cancelled')),
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (doctor_id) REFERENCES users(id),
  FOREIGN KEY (patient_id) REFERENCES users(id)
);

-- INDEXES & CONSTRAINTS

-- 1. The Double-Booking Preventer
-- Only ONE scheduled appointment can exist for a specific doctor, at a specific date and time.
-- Note: SQLite does not support partial indexes with UNIQUE easily, so you may need to use a trigger or application logic if not using Postgres. 
-- In PostgreSQL, you would write:
-- CREATE UNIQUE INDEX idx_no_double_booking ON appointments(doctor_id, appointment_date, start_time) WHERE status = 'scheduled';

-- For SQLite/Standard SQL, we'll index it for fast lookups:
CREATE INDEX idx_appointments_lookup ON appointments(doctor_id, appointment_date, start_time);

-- 2. Fetching a patient's history
CREATE INDEX idx_appointments_patient ON appointments(patient_id);
