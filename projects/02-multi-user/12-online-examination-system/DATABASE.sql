-- Schema Design
CREATE TABLE exams (
    id UUID PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    duration_minutes INT NOT NULL
);

CREATE TABLE questions (
    id UUID PRIMARY KEY,
    exam_id UUID REFERENCES exams(id),
    text TEXT NOT NULL,
    correct_option CHAR(1) NOT NULL,
    weight INT DEFAULT 1
);

CREATE TABLE test_attempts (
    id UUID PRIMARY KEY,
    student_id UUID REFERENCES users(id),
    exam_id UUID REFERENCES exams(id),
    start_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    submitted_at TIMESTAMP,
    UNIQUE(student_id, exam_id) -- Prevent retakes
);
