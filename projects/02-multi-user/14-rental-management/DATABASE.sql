-- 🏠 Property Rental Management System: Database Schema

-- 1. Users
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('landlord', 'tenant')),
  full_name TEXT NOT NULL
);

-- 2. Properties
CREATE TABLE properties (
  id TEXT PRIMARY KEY,
  landlord_id TEXT NOT NULL,
  address TEXT NOT NULL,
  
  -- Strict decimal for money
  monthly_rent DECIMAL(10,2) NOT NULL CHECK (monthly_rent > 0),
  
  -- Automatically flips to false when a lease is approved
  is_available BOOLEAN DEFAULT 1,
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (landlord_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 3. Leases
CREATE TABLE leases (
  id TEXT PRIMARY KEY,
  property_id TEXT NOT NULL,
  tenant_id TEXT NOT NULL,
  
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'terminated')),
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (property_id) REFERENCES properties(id),
  FOREIGN KEY (tenant_id) REFERENCES users(id),
  
  CHECK (end_date > start_date)
);

-- 4. Rent Payments (The Ledger)
CREATE TABLE rent_payments (
  id TEXT PRIMARY KEY,
  lease_id TEXT NOT NULL,
  
  -- What is owed vs what was actually paid
  amount_due DECIMAL(10,2) NOT NULL,
  amount_paid DECIMAL(10,2) DEFAULT 0.00,
  
  due_date DATE NOT NULL,
  
  status TEXT DEFAULT 'unpaid' CHECK (status IN ('unpaid', 'partial', 'paid')),
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (lease_id) REFERENCES leases(id) ON DELETE CASCADE,
  
  -- You can never pay more than you owe on a single invoice
  CHECK (amount_paid <= amount_due AND amount_paid >= 0)
);

-- INDEXES
-- Fetching a landlord's arrears requires checking all payments for their leases
CREATE INDEX idx_payments_status ON rent_payments(status) WHERE status != 'paid';

-- Checking if a property is currently occupied
CREATE INDEX idx_leases_property_active ON leases(property_id) WHERE status = 'active';
