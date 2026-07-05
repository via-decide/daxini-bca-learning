-- 🌴 Leave Management System: Database Schema

-- 1. Users (Employees & Managers)
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  
  -- The Self-Referencing Foreign Key. 
  -- Who does this user report to? NULL if they are the CEO/Admin.
  manager_id TEXT,
  
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('manager', 'employee')),
  full_name TEXT NOT NULL,
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (manager_id) REFERENCES users(id) ON DELETE SET NULL
);

-- 2. Leave Balances (The Bank Account)
CREATE TABLE leave_balances (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  
  leave_type TEXT NOT NULL CHECK (leave_type IN ('pto', 'sick', 'unpaid')),
  
  -- The ultimate safeguard against overdrafts.
  days_remaining INTEGER NOT NULL CHECK (days_remaining >= 0),
  
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  
  -- A user can only have one 'pto' balance row, one 'sick' balance row, etc.
  UNIQUE (user_id, leave_type)
);

-- 3. Leave Requests (The Transactions)
CREATE TABLE leave_requests (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  
  leave_type TEXT NOT NULL,
  
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  
  -- How many working days is this? (e.g., Nov 1 to Nov 7 might only be 5 working days)
  requested_days INTEGER NOT NULL CHECK (requested_days > 0),
  
  -- The State Machine
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  
  manager_comment TEXT,
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  
  CHECK (end_date >= start_date)
);

-- INDEXES
-- Fetching a manager's inbox requires finding all pending requests for their direct reports
-- We will join this with the users table.
CREATE INDEX idx_leave_status ON leave_requests(status) WHERE status = 'pending';

-- Fetching an employee's history
CREATE INDEX idx_leave_user ON leave_requests(user_id);
