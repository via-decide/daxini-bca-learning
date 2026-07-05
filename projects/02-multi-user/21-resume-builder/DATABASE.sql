-- 📄 SaaS Resume Builder API: Database Schema

-- 1. Users
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  full_name TEXT NOT NULL
);

-- 2. Resumes (The Core Document)
CREATE TABLE resumes (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  
  title TEXT NOT NULL,
  
  -- Generates a shareable URL like: /p/john-doe-software-dev-a7x9
  public_slug TEXT UNIQUE,
  
  is_published BOOLEAN DEFAULT 0,
  view_count INTEGER DEFAULT 0 CHECK (view_count >= 0),
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 3. Resume Experiences (1-to-Many)
CREATE TABLE resume_experiences (
  id TEXT PRIMARY KEY,
  resume_id TEXT NOT NULL,
  
  company TEXT NOT NULL,
  role TEXT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE, -- NULL means "Present"
  
  description TEXT,
  
  -- In what order should these appear on the page?
  sort_order INTEGER NOT NULL DEFAULT 0,
  
  FOREIGN KEY (resume_id) REFERENCES resumes(id) ON DELETE CASCADE
);

-- 4. Resume Educations (1-to-Many)
CREATE TABLE resume_educations (
  id TEXT PRIMARY KEY,
  resume_id TEXT NOT NULL,
  
  institution TEXT NOT NULL,
  degree TEXT NOT NULL,
  graduation_year INTEGER NOT NULL,
  
  sort_order INTEGER NOT NULL DEFAULT 0,
  
  FOREIGN KEY (resume_id) REFERENCES resumes(id) ON DELETE CASCADE
);

-- INDEXES
-- Looking up a resume by its public slug must be blazing fast
CREATE INDEX idx_resumes_slug ON resumes(public_slug);

-- Fetching all of a user's resumes
CREATE INDEX idx_resumes_user ON resumes(user_id);
