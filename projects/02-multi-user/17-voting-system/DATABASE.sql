-- Schema Design
CREATE TABLE polls (
    id UUID PRIMARY KEY,
    title VARCHAR(255) NOT NULL
);

CREATE TABLE poll_options (
    id UUID PRIMARY KEY,
    poll_id UUID REFERENCES polls(id),
    option_text VARCHAR(255) NOT NULL,
    vote_count INT DEFAULT 0
);

CREATE TABLE user_votes (
    poll_id UUID REFERENCES polls(id),
    user_id UUID REFERENCES users(id),
    option_id UUID REFERENCES poll_options(id),
    PRIMARY KEY (poll_id, user_id) -- ENFORCES ONE VOTE PER POLL
);
