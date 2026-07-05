-- Schema Design
CREATE TABLE notifications (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    actor_id UUID REFERENCES users(id),
    type VARCHAR(50) NOT NULL,
    entity_id UUID NOT NULL,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);\n