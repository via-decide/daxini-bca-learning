-- 💼 Job Portal API: Database Schema

-- 1. Users (Employers & Candidates)
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('employer', 'candidate')),
  full_name TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Companies
CREATE TABLE companies (
  id TEXT PRIMARY KEY,
  employer_id TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (employer_id) REFERENCES users(id) ON DELETE CASCADE,
  
  -- An employer can only have one company profile in this simple system
  UNIQUE (employer_id) 
);

-- 3. Job Postings
CREATE TABLE job_postings (
  id TEXT PRIMARY KEY,
  company_id TEXT NOT NULL,
  
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  salary_range TEXT,
  
  status TEXT DEFAULT 'open' CHECK (status IN ('open', 'closed')),
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE
);

-- 4. Applications (The intersection of Jobs and Candidates)
CREATE TABLE applications (
  id TEXT PRIMARY KEY,
  job_id TEXT NOT NULL,
  candidate_id TEXT NOT NULL,
  
  resume_link TEXT NOT NULL,
  cover_letter TEXT,
  
  -- The Hiring Pipeline State Machine
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'reviewing', 'interviewing', 'rejected', 'hired')),
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (job_id) REFERENCES job_postings(id) ON DELETE CASCADE,
  FOREIGN KEY (candidate_id) REFERENCES users(id) ON DELETE CASCADE,
  
  -- CRITICAL: Prevent candidate from applying to the exact same job twice
  UNIQUE (job_id, candidate_id)
);

-- INDEXES
-- Searching for open jobs quickly
CREATE INDEX idx_jobs_status ON job_postings(status) WHERE status = 'open';

-- Fetching applicants for a specific job quickly (Employer view)
CREATE INDEX idx_apps_job ON applications(job_id);

-- Fetching application history for a candidate (Candidate view)
CREATE INDEX idx_apps_candidate ON applications(candidate_id);
