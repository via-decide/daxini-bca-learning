-- Schema Design
CREATE TABLE employee_contracts (
    employee_id UUID PRIMARY KEY REFERENCES employees(id),
    annual_base_salary DECIMAL(12,2) NOT NULL
);

CREATE TABLE payslips (
    id UUID PRIMARY KEY,
    employee_id UUID REFERENCES employees(id),
    month_year VARCHAR(7) NOT NULL, -- e.g. '2024-10'
    gross_pay DECIMAL(10,2) NOT NULL,
    net_pay DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'draft'
);

CREATE TABLE payslip_line_items (
    id UUID PRIMARY KEY,
    payslip_id UUID REFERENCES payslips(id),
    type VARCHAR(20) NOT NULL, -- 'addition' or 'deduction'
    description VARCHAR(255) NOT NULL,
    amount DECIMAL(10,2) NOT NULL
);
