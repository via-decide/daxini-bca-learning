-- 🎓 Student Information System: Database Schema

-- 1. Users (Role-Based Access Control)
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  
  role TEXT NOT NULL CHECK (role IN ('admin', 'professor', 'student')),
  
  full_name TEXT NOT NULL
);

-- 2. Courses
CREATE TABLE courses (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  
  -- Most college courses are 3 or 4 credits
  credits INTEGER NOT NULL CHECK (credits > 0),
  
  professor_id TEXT NOT NULL,
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (professor_id) REFERENCES users(id) ON DELETE RESTRICT
);

-- 3. Enrollments (The Many-to-Many Junction Table)
CREATE TABLE enrollments (
  id TEXT PRIMARY KEY,
  student_id TEXT NOT NULL,
  course_id TEXT NOT NULL,
  
  semester TEXT NOT NULL, -- e.g., 'Fall 2026'
  
  -- Grade can be NULL if the course is currently in progress
  grade TEXT CHECK (grade IN ('A', 'B', 'C', 'D', 'F', NULL)),
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  
  -- Prevent a student from enrolling in the same course twice in the same semester
  UNIQUE(student_id, course_id, semester)
);

-- INDEXES
-- Fetching a student's transcript
CREATE INDEX idx_enrollments_student ON enrollments(student_id);

-- Fetching a professor's course roster
CREATE INDEX idx_enrollments_course ON enrollments(course_id);
