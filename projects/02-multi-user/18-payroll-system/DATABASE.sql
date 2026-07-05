-- 💰 Payroll System API: Database Schema

-- 1. Users
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('admin', 'employee')),
  full_name TEXT NOT NULL
);

-- 2. Salary Configurations (1-to-1 with Users)
CREATE TABLE salary_configs (
  user_id TEXT PRIMARY KEY,
  
  -- We use DECIMAL for money. 
  hourly_rate DECIMAL(10,2) NOT NULL CHECK (hourly_rate >= 0),
  
  -- E.g., 0.15 for 15%
  tax_percentage DECIMAL(5,4) NOT NULL CHECK (tax_percentage BETWEEN 0 AND 1),
  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 3. Timesheets (Daily Logs)
CREATE TABLE timesheets (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  
  work_date DATE NOT NULL,
  hours_worked DECIMAL(4,2) NOT NULL CHECK (hours_worked > 0 AND hours_worked <= 24),
  
  -- Crucial for ensuring we don't pay someone twice
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'processed')),
  
  -- Link back to the payslip once it's processed (NULL initially)
  payslip_id TEXT,
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  
  -- An employee can only log one timesheet per calendar day
  UNIQUE (user_id, work_date)
);

-- 4. Payslips (The Financial Ledger)
CREATE TABLE payslips (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  
  period_start DATE NOT NULL,
  period_end DATE NOT NULL,
  
  -- Snapshot of the math at the exact time of generation
  total_hours DECIMAL(6,2) NOT NULL,
  hourly_rate_applied DECIMAL(10,2) NOT NULL,
  
  gross_pay DECIMAL(10,2) NOT NULL,
  tax_deducted DECIMAL(10,2) NOT NULL,
  net_pay DECIMAL(10,2) NOT NULL,
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Now we can safely add the Foreign Key to Timesheets linking to Payslips
-- (SQLite requires doing this logically or creating Payslips first, 
-- but conceptually this is the relationship).
-- ALTER TABLE timesheets ADD CONSTRAINT fk_payslip FOREIGN KEY (payslip_id) REFERENCES payslips(id);


-- INDEXES
-- Fetching an employee's pending timesheets efficiently
CREATE INDEX idx_timesheets_pending ON timesheets(user_id, status) WHERE status = 'pending';

-- Fetching an employee's payslips
CREATE INDEX idx_payslips_user ON payslips(user_id);
