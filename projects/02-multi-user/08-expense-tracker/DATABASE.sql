-- 💸 Expense Tracker API: Database Schema

-- 1. Users
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL
);

-- 2. Categories
CREATE TABLE categories (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  name TEXT NOT NULL,
  
  -- Store budgets as strict decimals, or integers (cents)
  monthly_budget DECIMAL(10,2),
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  -- Prevent a user from creating two categories named "Groceries"
  UNIQUE (user_id, name)
);

-- 3. Expenses
CREATE TABLE expenses (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  category_id TEXT NOT NULL,
  
  amount DECIMAL(10,2) NOT NULL,
  description TEXT,
  
  -- We strictly use DATE because time of day doesn't matter for basic monthly budgets
  date DATE NOT NULL,
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
  
  -- Prevent negative expenses
  CHECK (amount > 0)
);

-- INDEXES FOR PERFORMANCE
-- Generating a monthly report requires fetching a user's expenses grouped by date and category
CREATE INDEX idx_expenses_user_date ON expenses(user_id, date);
CREATE INDEX idx_expenses_category ON expenses(category_id);
