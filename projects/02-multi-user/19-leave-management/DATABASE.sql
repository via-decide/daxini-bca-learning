-- Schema Design
CREATE TABLE leave_balances (
    employee_id UUID REFERENCES employees(id),
    year INT NOT NULL,
    leave_type VARCHAR(50) NOT NULL,
    days_remaining INT NOT NULL,
    PRIMARY KEY (employee_id, year, leave_type)
);

CREATE TABLE leave_requests (
    id UUID PRIMARY KEY,
    employee_id UUID REFERENCES employees(id),
    leave_type VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    days_requested INT NOT NULL,
    status VARCHAR(50) DEFAULT 'pending'
);
