-- 📦 Inventory Management System: Database Schema

-- 1. Users (Role-Based Access Control)
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  
  -- The three distinct roles
  role TEXT NOT NULL CHECK (role IN ('manager', 'warehouse', 'cashier')),
  
  full_name TEXT NOT NULL
);

-- 2. Products Catalog
CREATE TABLE products (
  id TEXT PRIMARY KEY,
  sku TEXT UNIQUE NOT NULL, -- Barcode/Stock Keeping Unit
  name TEXT NOT NULL,
  description TEXT,
  
  -- Price stored as precise decimal (e.g., 29.99)
  price DECIMAL(10,2) NOT NULL,
  
  -- The actual physical count. Must NEVER be negative!
  current_stock INTEGER NOT NULL DEFAULT 0,
  
  -- When stock hits this number, it appears on the Manager's dashboard
  low_stock_threshold INTEGER NOT NULL DEFAULT 10,
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  -- The most important constraint in the system:
  CHECK (current_stock >= 0)
);

-- 3. Inventory Movements (The Immutable Audit Log)
-- Rows in this table should NEVER be updated or deleted. Only Inserted.
CREATE TABLE inventory_movements (
  id TEXT PRIMARY KEY,
  product_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  
  -- Was stock added, removed, or manually adjusted?
  type TEXT NOT NULL CHECK (type IN ('in', 'out', 'adjustment')),
  
  -- How many items moved?
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  
  reason TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT
);

-- INDEXES
-- Searching for a product by barcode is the most common action
CREATE INDEX idx_products_sku ON products(sku);

-- Fetching the audit log for a specific product
CREATE INDEX idx_movements_product ON inventory_movements(product_id);
