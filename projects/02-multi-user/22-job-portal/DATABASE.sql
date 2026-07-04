-- Schema Design
CREATE TABLE companies (
    id UUID PRIMARY KEY,
    owner_id UUID REFERENCES users(id),
    name VARCHAR(255) NOT NULL
);

CREATE TABLE jobs (
    id UUID PRIMARY KEY,
    company_id UUID REFERENCES companies(id),
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    is_active BOOLEAN DEFAULT true
);

CREATE TABLE applications (
    id UUID PRIMARY KEY,
    job_id UUID REFERENCES jobs(id),
    applicant_id UUID REFERENCES users(id),
    resume_s3_key VARCHAR(255) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    UNIQUE(job_id, applicant_id) -- Prevent applying twice
);
