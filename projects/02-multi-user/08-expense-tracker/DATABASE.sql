-- Schema Design
CREATE TABLE expenses (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    category VARCHAR(100) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL, -- NEVER USE FLOAT!
    currency VARCHAR(3) DEFAULT 'USD',
    expense_date DATE NOT NULL
);
