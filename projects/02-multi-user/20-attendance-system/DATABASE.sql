-- 🕒 Employee Attendance System: Database Schema

-- 1. Users (Employees & Managers)
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  
  -- The Hierarchy (Self-Referencing)
  manager_id TEXT,
  
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('manager', 'employee')),
  full_name TEXT NOT NULL,
  
  -- E.g., '09:00:00'. If they clock in after this, they are marked 'late'
  expected_start_time TIME NOT NULL DEFAULT '09:00:00',
  
  FOREIGN KEY (manager_id) REFERENCES users(id) ON DELETE SET NULL
);

-- 2. Attendance Records
CREATE TABLE attendance_records (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  
  -- The Calendar Day
  date DATE NOT NULL,
  
  -- The exact timestamps
  clock_in_time DATETIME NOT NULL,
  clock_out_time DATETIME,
  
  -- Status derived upon clock-in
  status TEXT NOT NULL CHECK (status IN ('present', 'late', 'absent')),
  
  -- For anomalies or manager corrections
  notes TEXT,
  
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  
  -- CRITICAL CONSTRAINT: An employee can only have ONE record per calendar day
  UNIQUE (user_id, date),
  
  -- Sanity check: You cannot clock out before you clock in
  CHECK (clock_out_time IS NULL OR clock_out_time >= clock_in_time)
);

-- INDEXES
-- Managers frequently fetch records for a specific date
CREATE INDEX idx_attendance_date ON attendance_records(date);

-- Finding "open" records (missing clock-outs) for the nightly cron job
CREATE INDEX idx_attendance_open ON attendance_records(clock_out_time) WHERE clock_out_time IS NULL;
