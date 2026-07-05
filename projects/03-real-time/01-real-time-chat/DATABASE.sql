-- Schema Design
CREATE TABLE users (
    id UUID PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    status VARCHAR(20) DEFAULT 'offline'
);

CREATE TABLE rooms (
    id UUID PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE messages (
    id UUID PRIMARY KEY,
    room_id UUID REFERENCES rooms(id),
    sender_id UUID REFERENCES users(id),
    content TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);\n