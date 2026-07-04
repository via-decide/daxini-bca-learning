-- Schema Design
CREATE TABLE vehicles (
    id UUID PRIMARY KEY,
    license_plate VARCHAR(20) UNIQUE NOT NULL,
    current_lat DECIMAL(9,6),
    current_lng DECIMAL(9,6),
    last_ping_time TIMESTAMP
);

CREATE TABLE location_telemetry (
    vehicle_id UUID REFERENCES vehicles(id),
    lat DECIMAL(9,6) NOT NULL,
    lng DECIMAL(9,6) NOT NULL,
    recorded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_vehicle_time ON location_telemetry(vehicle_id, recorded_at DESC);
