-- Schema Design
CREATE TABLE courses (
    id UUID PRIMARY KEY,
    professor_id UUID REFERENCES users(id),
    title VARCHAR(255) NOT NULL
);

CREATE TABLE enrollments (
    course_id UUID REFERENCES courses(id),
    student_id UUID REFERENCES users(id),
    final_grade VARCHAR(2),
    PRIMARY KEY (course_id, student_id)
);

CREATE TABLE assignments (
    id UUID PRIMARY KEY,
    course_id UUID REFERENCES courses(id),
    title VARCHAR(255) NOT NULL,
    max_points INT NOT NULL
);

CREATE TABLE submissions (
    assignment_id UUID REFERENCES assignments(id),
    student_id UUID REFERENCES users(id),
    s3_file_key VARCHAR(255) NOT NULL,
    score INT,
    PRIMARY KEY (assignment_id, student_id)
);
