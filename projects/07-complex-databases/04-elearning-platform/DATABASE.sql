-- Schema Design
-- Users (inheritance: Student, Instructor, Admin)
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  email TEXT UNIQUE,
  password_hash TEXT,
  name TEXT,
  role TEXT (student, instructor, admin),
  profile_picture_url TEXT,
  bio TEXT,
  created_at DATETIME
);

-- Courses
CREATE TABLE courses (
  id INTEGER PRIMARY KEY,
  instructor_id INTEGER FOREIGN KEY,
  title TEXT,
  description TEXT,
  category TEXT,
  level TEXT (beginner, intermediate, advanced),
  price DECIMAL,
  thumbnail_url TEXT,
  total_duration_minutes INTEGER,
  created_at DATETIME,
  published_at DATETIME
);

-- Lessons
CREATE TABLE lessons (
  id INTEGER PRIMARY KEY,
  course_id INTEGER FOREIGN KEY,
  lesson_number INTEGER,
  title TEXT,
  description TEXT,
  duration_minutes INTEGER,
  lesson_order INTEGER,
  created_at DATETIME
);

-- Videos
CREATE TABLE videos (
  id INTEGER PRIMARY KEY,
  lesson_id INTEGER FOREIGN KEY,
  video_url TEXT,
  resolution TEXT (360p, 720p, 1080p),
  file_size_mb INTEGER,
  has_captions BOOLEAN,
  created_at DATETIME
);

-- Quizzes
CREATE TABLE quizzes (
  id INTEGER PRIMARY KEY,
  course_id INTEGER FOREIGN KEY,
  title TEXT,
  description TEXT,
  pass_percentage INTEGER,
  time_limit_minutes INTEGER,
  retake_allowed BOOLEAN,
  max_attempts INTEGER,
  created_at DATETIME
);

-- Questions
CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  quiz_id INTEGER FOREIGN KEY,
  question_text TEXT,
  question_type TEXT (multiple_choice, true_false, essay),
  points INTEGER,
  correct_answer TEXT,
  options TEXT (JSON array for multiple choice),
  explanation TEXT
);

-- Enrollments
CREATE TABLE enrollments (
  id INTEGER PRIMARY KEY,
  student_id INTEGER FOREIGN KEY,
  course_id INTEGER FOREIGN KEY,
  enrollment_date DATETIME,
  payment_status TEXT (paid, pending, free),
  access_expiration DATETIME,
  completion_status TEXT (active, completed, dropped),
  UNIQUE(student_id, course_id)
);

-- Progress
CREATE TABLE progress (
  id INTEGER PRIMARY KEY,
  student_id INTEGER FOREIGN KEY,
  course_id INTEGER FOREIGN KEY,
  lessons_completed INTEGER,
  lessons_total INTEGER,
  current_lesson_id INTEGER FOREIGN KEY,
  total_time_spent_minutes INTEGER,
  last_accessed DATETIME,
  completion_percentage FLOAT
);

-- Quiz Attempts
CREATE TABLE quiz_attempts (
  id INTEGER PRIMARY KEY,
  student_id INTEGER FOREIGN KEY,
  quiz_id INTEGER FOREIGN KEY,
  attempt_number INTEGER,
  answers TEXT (JSON),
  score FLOAT,
  time_taken_minutes INTEGER,
  attempt_date DATETIME,
  passed BOOLEAN
);

-- Grades
CREATE TABLE grades (
  id INTEGER PRIMARY KEY,
  student_id INTEGER FOREIGN KEY,
  course_id INTEGER FOREIGN KEY,
  quiz_average FLOAT,
  assignment_average FLOAT,
  final_score FLOAT,
  grade_letter TEXT (A, B, C, D, F),
  grade_date DATETIME
);

-- Certificates
CREATE TABLE certificates (
  id INTEGER PRIMARY KEY,
  student_id INTEGER FOREIGN KEY,
  course_id INTEGER FOREIGN KEY,
  issue_date DATETIME,
  certificate_url TEXT,
  verification_code TEXT UNIQUE,
  valid_until DATETIME
);