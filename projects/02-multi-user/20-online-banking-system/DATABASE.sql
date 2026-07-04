-- Schema Design
CREATE TABLE accounts (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    balance INT DEFAULT 0 -- STORE IN CENTS
);

CREATE TABLE transactions (
    id UUID PRIMARY KEY,
    from_account_id UUID REFERENCES accounts(id),
    to_account_id UUID REFERENCES accounts(id),
    amount INT NOT NULL CHECK (amount > 0),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
