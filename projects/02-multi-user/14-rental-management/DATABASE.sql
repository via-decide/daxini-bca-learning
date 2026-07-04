-- Schema Design
CREATE TABLE properties (
    id UUID PRIMARY KEY,
    address VARCHAR(500) NOT NULL,
    monthly_rent DECIMAL(10,2) NOT NULL
);

CREATE TABLE leases (
    id UUID PRIMARY KEY,
    property_id UUID REFERENCES properties(id),
    tenant_id UUID REFERENCES users(id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

CREATE TABLE invoices (
    id UUID PRIMARY KEY,
    lease_id UUID REFERENCES leases(id),
    due_date DATE NOT NULL,
    amount_due DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'unpaid'
);

CREATE TABLE payments (
    id UUID PRIMARY KEY,
    invoice_id UUID REFERENCES invoices(id),
    amount_paid DECIMAL(10,2) NOT NULL,
    payment_date DATE DEFAULT CURRENT_DATE
);
