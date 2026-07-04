-- Schema Design
CREATE TABLE services (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    duration_minutes INT NOT NULL,
    price DECIMAL(8,2) NOT NULL
);

CREATE TABLE stylists (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE appointments (
    id UUID PRIMARY KEY,
    stylist_id UUID REFERENCES stylists(id),
    customer_id UUID REFERENCES users(id),
    service_id UUID REFERENCES services(id),
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL
);
