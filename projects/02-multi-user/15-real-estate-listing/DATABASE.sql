-- Schema Design
CREATE TABLE properties (
    id UUID PRIMARY KEY,
    agent_id UUID REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    price DECIMAL(12, 2) NOT NULL,
    latitude DECIMAL(9, 6) NOT NULL,
    longitude DECIMAL(9, 6) NOT NULL
);

CREATE TABLE property_images (
    id UUID PRIMARY KEY,
    property_id UUID REFERENCES properties(id),
    image_url VARCHAR(500) NOT NULL,
    is_primary BOOLEAN DEFAULT false
);
