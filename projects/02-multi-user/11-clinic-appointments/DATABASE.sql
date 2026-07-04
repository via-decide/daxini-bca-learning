-- Schema Design
CREATE TABLE doctors (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    name VARCHAR(255) NOT NULL,
    specialty VARCHAR(100)
);

CREATE TABLE patients (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    phone VARCHAR(20)
);

CREATE TABLE appointments (
    id UUID PRIMARY KEY,
    doctor_id UUID REFERENCES doctors(id),
    patient_id UUID REFERENCES patients(id),
    appointment_time TIMESTAMP NOT NULL,
    status VARCHAR(50) DEFAULT 'scheduled',
    UNIQUE(doctor_id, appointment_time)
);
