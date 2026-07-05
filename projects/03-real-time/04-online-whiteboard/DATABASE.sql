-- Schema Design
CREATE TABLE boards (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE board_elements (
    id UUID PRIMARY KEY,
    board_id UUID REFERENCES boards(id),
    type VARCHAR(50) NOT NULL,
    properties JSONB NOT NULL,
    z_index INT NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);\n