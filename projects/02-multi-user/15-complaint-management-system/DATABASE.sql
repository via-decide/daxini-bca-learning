-- Schema Design
CREATE TABLE complaints (
    id UUID PRIMARY KEY,
    citizen_id UUID REFERENCES users(id),
    category VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    lat DECIMAL(9,6),
    lng DECIMAL(9,6),
    current_status VARCHAR(50) DEFAULT 'submitted',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE complaint_history (
    id UUID PRIMARY KEY,
    complaint_id UUID REFERENCES complaints(id),
    admin_id UUID REFERENCES users(id),
    previous_status VARCHAR(50),
    new_status VARCHAR(50) NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
