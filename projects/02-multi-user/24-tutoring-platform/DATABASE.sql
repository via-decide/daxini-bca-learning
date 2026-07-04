-- Schema Design
CREATE TABLE subjects (
    id UUID PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE tutor_subjects (
    tutor_id UUID REFERENCES users(id),
    subject_id UUID REFERENCES subjects(id),
    hourly_rate DECIMAL(8,2) NOT NULL,
    PRIMARY KEY (tutor_id, subject_id)
);

CREATE TABLE sessions (
    id UUID PRIMARY KEY,
    tutor_id UUID REFERENCES users(id),
    student_id UUID REFERENCES users(id),
    subject_id UUID REFERENCES subjects(id),
    start_time TIMESTAMP NOT NULL,
    duration_minutes INT NOT NULL,
    meeting_url VARCHAR(500),
    total_price DECIMAL(8,2) NOT NULL
);
