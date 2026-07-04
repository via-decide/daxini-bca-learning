-- Schema Design
CREATE TABLE entities (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    total_reviews INT DEFAULT 0,
    average_rating DECIMAL(3,2) DEFAULT 0.00
);

CREATE TABLE reviews (
    id UUID PRIMARY KEY,
    entity_id UUID REFERENCES entities(id),
    user_id UUID REFERENCES users(id),
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(entity_id, user_id) -- One review per user per entity
);
