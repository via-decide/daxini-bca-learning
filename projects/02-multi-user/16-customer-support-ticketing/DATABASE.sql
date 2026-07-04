-- Schema Design
CREATE TABLE tickets (
    id UUID PRIMARY KEY,
    customer_id UUID REFERENCES users(id),
    assignee_id UUID REFERENCES users(id),
    subject VARCHAR(255) NOT NULL,
    status VARCHAR(50) DEFAULT 'open',
    priority VARCHAR(50) DEFAULT 'medium'
);

CREATE TABLE ticket_comments (
    id UUID PRIMARY KEY,
    ticket_id UUID REFERENCES tickets(id),
    user_id UUID REFERENCES users(id),
    message TEXT NOT NULL,
    is_internal_note BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
