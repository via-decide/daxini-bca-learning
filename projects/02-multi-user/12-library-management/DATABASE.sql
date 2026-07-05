-- 📚 Library Management System: Database Schema

-- 1. Users
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('admin', 'member')),
  full_name TEXT NOT NULL
);

-- 2. Books (The Catalog)
CREATE TABLE books (
  id TEXT PRIMARY KEY,
  isbn TEXT UNIQUE NOT NULL,
  title TEXT NOT NULL,
  author TEXT NOT NULL,
  
  -- The physical inventory count
  total_copies INTEGER NOT NULL CHECK (total_copies >= 0),
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3. Borrow Records (The Transaction Log)
CREATE TABLE borrow_records (
  id TEXT PRIMARY KEY,
  book_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  
  borrowed_date DATE NOT NULL,
  due_date DATE NOT NULL,
  
  -- Null means the user still has the book
  returned_date DATE,
  
  -- Store money as precise decimal
  late_fee DECIMAL(10,2) DEFAULT 0.00,
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE RESTRICT,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
  
  -- Sanity checks
  CHECK (due_date >= borrowed_date),
  CHECK (returned_date IS NULL OR returned_date >= borrowed_date)
);

-- INDEXES
-- Fetching a member's current active loans
CREATE INDEX idx_active_loans ON borrow_records(user_id) WHERE returned_date IS NULL;

-- Calculating how many copies of a book are currently checked out
CREATE INDEX idx_book_availability ON borrow_records(book_id) WHERE returned_date IS NULL;
