-- Schema Design
CREATE TABLE jobs (
    id UUID PRIMARY KEY,
    employer_id UUID REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    is_remote BOOLEAN DEFAULT false,
    min_salary INT,
    max_salary INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE applications (
    id UUID PRIMARY KEY,
    job_id UUID REFERENCES jobs(id),
    applicant_id UUID REFERENCES users(id),
    resume_file_path VARCHAR(500) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    UNIQUE(job_id, applicant_id) -- Can't apply twice
);
