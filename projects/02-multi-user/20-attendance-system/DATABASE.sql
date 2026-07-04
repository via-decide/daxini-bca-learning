-- Schema Design
CREATE TABLE daily_attendance (
    id UUID PRIMARY KEY,
    employee_id UUID REFERENCES employees(id),
    work_date DATE NOT NULL,
    punch_in TIMESTAMP NOT NULL,
    punch_out TIMESTAMP,
    total_hours DECIMAL(5,2),
    UNIQUE(employee_id, work_date) -- One record per day
);
