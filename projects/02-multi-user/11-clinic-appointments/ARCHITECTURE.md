# Clinic Appointment System

## 🏗️ Architecture: Design Before Coding

**The Problem:**
Patients need to book doctors. Doctors have schedules. We need to prevent double-booking a doctor for the exact same 30-minute slot.

**The Solution:**
Instead of checking availability in code, use a unique constraint on the database: `(doctor_id, appointment_time)`. This guarantees no two patients can claim the same slot.

**Database Architecture:**
```text
Doctors
├─ id
├─ name
└─ specialty

Patients
├─ id
├─ name
└─ phone

Appointments
├─ id
├─ doctor_id
├─ patient_id
├─ appointment_time (TIMESTAMP)
├─ status (ENUM: Scheduled, Completed, Cancelled)
└─ UNIQUE(doctor_id, appointment_time)
```
