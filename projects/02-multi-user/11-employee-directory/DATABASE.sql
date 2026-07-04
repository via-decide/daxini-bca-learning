-- Schema Design
CREATE TABLE employees (
    id UUID PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    title VARCHAR(100),
    manager_id UUID REFERENCES employees(id) -- The self-reference!
);
