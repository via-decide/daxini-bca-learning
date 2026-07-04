-- Schema Design
CREATE TABLE cars (
    id UUID PRIMARY KEY,
    make VARCHAR(50),
    model VARCHAR(50),
    daily_rate INT
);

CREATE TABLE bookings (
    id UUID PRIMARY KEY,
    car_id UUID REFERENCES cars(id),
    user_id UUID REFERENCES users(id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(50) DEFAULT 'confirmed'
);
