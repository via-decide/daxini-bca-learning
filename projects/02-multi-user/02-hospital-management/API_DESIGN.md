# Hospital Management System: Learn By Building

**"Build a multi-user system for managing patient records, doctor appointments, and hospital administration with strict access controls."**

---


## 🔌 API Design: Plan Before Coding

### Endpoint 1: Book Appointment (Patient)
**POST `/api/appointments`**
- **Auth**: Requires Patient JWT.
- **Body**: `{ "doctor_id": "uuid", "time": "2024-11-01T10:00:00Z" }`

### Endpoint 2: Add Medical Record (Doctor)
**POST `/api/records`**
- **Auth**: Requires Doctor JWT.
- **Body**: `{ "appointment_id": "uuid", "diagnosis": "Flu", "prescription": "Rest" }`

### Endpoint 3: View Appointments
**GET `/api/appointments`**
- **Auth**: Required.
- **Logic**:
  - If role == `patient`, return only `WHERE patient_id = my_id`.
  - If role == `doctor`, return only `WHERE doctor_id = my_id`.
  - If role == `admin`, return all.

---
