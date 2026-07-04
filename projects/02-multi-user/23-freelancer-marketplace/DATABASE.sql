-- Schema Design
CREATE TABLE projects (
    id UUID PRIMARY KEY,
    client_id UUID REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    budget DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'open'
);

CREATE TABLE bids (
    id UUID PRIMARY KEY,
    project_id UUID REFERENCES projects(id),
    freelancer_id UUID REFERENCES users(id),
    amount DECIMAL(10,2) NOT NULL,
    is_accepted BOOLEAN DEFAULT false,
    UNIQUE(project_id, freelancer_id)
);

CREATE TABLE milestones (
    id UUID PRIMARY KEY,
    project_id UUID REFERENCES projects(id),
    description VARCHAR(255) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'funded'
);
