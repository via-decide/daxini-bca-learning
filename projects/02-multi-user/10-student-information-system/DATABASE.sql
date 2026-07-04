-- Schema Design
CREATE TABLE students (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    enrollment_year INT
);

CREATE TABLE courses (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    credits INT NOT NULL
);

CREATE TABLE enrollments (
    student_id UUID REFERENCES students(id),
    course_id UUID REFERENCES courses(id),
    semester VARCHAR(20),
    grade VARCHAR(2), -- 'A', 'A-', 'B+', etc.
    PRIMARY KEY (student_id, course_id, semester)
);
