-- 🎓 College Management System API: Database Schema

-- 1. Users (Admins, Professors, Students)
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('admin', 'professor', 'student')),
  full_name TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Courses (The Catalog)
CREATE TABLE courses (
  id TEXT PRIMARY KEY,
  course_code TEXT UNIQUE NOT NULL, -- e.g., 'CS101'
  title TEXT NOT NULL,
  
  -- Who teaches this? (NULL if unassigned)
  professor_id TEXT,
  
  credits INTEGER NOT NULL CHECK (credits > 0),
  capacity INTEGER NOT NULL CHECK (capacity > 0),
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (professor_id) REFERENCES users(id) ON DELETE SET NULL
);

-- 3. Enrollments (The Junction Table / Transcript)
CREATE TABLE enrollments (
  id TEXT PRIMARY KEY,
  student_id TEXT NOT NULL,
  course_id TEXT NOT NULL,
  
  status TEXT DEFAULT 'enrolled' CHECK (status IN ('enrolled', 'dropped', 'completed')),
  
  -- The academic grade (NULL until the end of the semester)
  grade TEXT CHECK (grade IN ('A', 'B', 'C', 'D', 'F', NULL)),
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  
  -- A student can only be enrolled in a specific course once per semester
  UNIQUE (student_id, course_id)
);

-- INDEXES
-- Fetching a student's transcript quickly
CREATE INDEX idx_enrollments_student ON enrollments(student_id);

-- Fetching a course roster quickly
CREATE INDEX idx_enrollments_course ON enrollments(course_id);

-- Finding courses taught by a specific professor
CREATE INDEX idx_courses_professor ON courses(professor_id);
