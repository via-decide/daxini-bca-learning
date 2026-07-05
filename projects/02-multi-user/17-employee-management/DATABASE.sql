-- 🏢 Employee Management System (HRIS): Database Schema

-- Notice the order of creation. We cannot make departments first if it requires a manager_id 
-- that references users, and users require a department_id.
-- We must defer the foreign key constraint or allow NULLs.

-- 1. Departments
CREATE TABLE departments (
  id TEXT PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  
  -- The manager of the department. We will add the Foreign Key constraint AFTER creating the users table.
  manager_id TEXT UNIQUE, -- UNIQUE because one person can only manage one department
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Users (Employees, Managers, Admins)
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  
  -- Which department do they work in? NULL if they are the Admin or unassigned.
  department_id TEXT,
  
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  
  -- RBAC Role
  role TEXT NOT NULL CHECK (role IN ('admin', 'manager', 'employee')),
  
  full_name TEXT NOT NULL,
  job_title TEXT NOT NULL,
  hire_date DATE NOT NULL,
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL
);

-- Now that users exist, we can alter the departments table to add the constraint.
-- Note: SQLite does not support ALTER TABLE ADD CONSTRAINT, so in SQLite you would 
-- just omit the explicit constraint here, but logically enforce it in your application,
-- OR create users first without department_id constraints. 
-- In PostgreSQL/MySQL:
-- ALTER TABLE departments ADD CONSTRAINT fk_manager FOREIGN KEY (manager_id) REFERENCES users(id) ON DELETE SET NULL;

-- INDEXES
-- Searching the directory by name
CREATE INDEX idx_users_name ON users(full_name);

-- Fetching all employees for a specific department
CREATE INDEX idx_users_department ON users(department_id);
