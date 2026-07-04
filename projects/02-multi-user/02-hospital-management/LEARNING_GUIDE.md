# Hospital Management System: Learn By Building

**"Build a multi-user system for managing patient records, doctor appointments, and hospital administration with strict access controls."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Multi-User Roles** - Differentiating access for Admins, Doctors, and Patients.
✅ **Data Privacy (HIPAA concepts)** - Ensuring users can only see their own sensitive data.
✅ **Complex Relational Models** - Linking Users to Profiles, Appointments, and Medical Records.
✅ **State Machines** - Managing appointment lifecycles (Scheduled -> In Progress -> Completed -> Cancelled).
✅ **Authentication & Authorization** - Using JWTs and Role-Based Access Control (RBAC).

---

## 📋 Project Overview

### The Problem
A hospital has distinct user groups with very different needs. A patient should only see their own appointments and prescriptions. A doctor needs to see appointments for all *their* patients, but shouldn't be able to edit hospital billing. An admin needs to see everything, manage staff, and handle scheduling conflicts. You must build a unified system with strict boundaries.

### Who Uses It
```
Admin:
├─ Manages Doctor accounts & schedules.
└─ Views hospital-wide analytics.

Doctor:
├─ Views their daily appointment roster.
├─ Adds medical notes and prescriptions for their patients.
└─ Cannot see other doctors' patients.

Patient:
├─ Books new appointments with available doctors.
├─ Views their own medical history and prescriptions.
└─ Cannot see anyone else's data.
```

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data

**Question: How do we handle different types of users?**
Instead of having a `Patients` table with passwords, and a `Doctors` table with passwords, it is much better to have a single `Users` table for authentication, and separate `Profiles` tables for role-specific data.

### Step 2: Database Architecture

```text
Users (Auth)
├─ id (UUID)
├─ email, password_hash
└─ role (ENUM: 'admin', 'doctor', 'patient')

Patient_Profiles
├─ user_id (FK -> Users.id)
├─ date_of_birth
├─ blood_group
└─ emergency_contact

Doctor_Profiles
├─ user_id (FK -> Users.id)
├─ specialization (e.g., 'Cardiology')
└─ consultation_fee

Appointments
├─ id (UUID)
├─ patient_id (FK -> Users.id)
├─ doctor_id (FK -> Users.id)
├─ appointment_time (TIMESTAMP)
└─ status (ENUM: 'scheduled', 'completed', 'cancelled')

Medical_Records
├─ id (UUID)
├─ appointment_id (FK -> Appointments.id)
├─ diagnosis (TEXT)
└─ prescription (TEXT)
```

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

## 🧠 Implementation: Pseudocode First

### 1. The Authorization Middleware
```text
FUNCTION require_role(allowed_roles):
    RETURN FUNCTION(request, response, next):
        token = request.headers.authorization
        user = verify_jwt(token)
        
        IF user.role NOT IN allowed_roles:
            RETURN 403 "Forbidden: Insufficient permissions"
            
        request.user = user // Attach to request for the next step
        next()
```

### 2. The Appointment Logic
```text
// Router: POST /api/records -> require_role(['doctor']) -> add_record
FUNCTION add_record(request, response):
    doctor_id = request.user.id
    appt_id = request.body.appointment_id
    
    // Security Check: Did THIS doctor actually treat THIS patient?
    appointment = DB.find("Appointments", appt_id)
    IF appointment.doctor_id != doctor_id:
        RETURN 403 "You can only add records for your own patients"
        
    DB.insert("Medical_Records", {
        appointment_id: appt_id,
        diagnosis: request.body.diagnosis,
        prescription: request.body.prescription
    })
    
    RETURN 201 "Record added"
```

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Missing Horizontal Authorization (IDOR)
**What's wrong:** A patient logs in, their ID is 5. They call `GET /api/patients/6/records` and the API returns Patient 6's medical data.
**Why it's bad:** This is an Insecure Direct Object Reference (IDOR). You checked if they were logged in, but you didn't check if they *owned* the data they requested.
**How to fix:** Always validate `requested_id == logged_in_user.id` or `logged_in_user.role == 'admin'`.

### ❌ Mistake 2: Overlapping Appointments
**What's wrong:** Two patients book the exact same doctor at 10:00 AM.
**Why it's bad:** The doctor cannot be in two places at once.
**How to fix:** Before inserting an appointment, query the DB: `SELECT count(*) FROM Appointments WHERE doctor_id = X AND time = Y`. If count > 0, return `409 Conflict`.

---

## 🧪 Testing: How to Verify

### Test 1: Role Isolation
- Login as Patient A. Try to hit a Doctor-only endpoint (like adding a prescription). Ensure it returns `403 Forbidden`.
- Try to fetch Patient B's records. Ensure it returns `403 Forbidden`.

### Test 2: Double Booking Prevention
- Login as Patient A. Book Doctor X for Monday at 9 AM.
- Login as Patient B. Attempt to book Doctor X for Monday at 9 AM. Ensure it returns an error.

---

## 📚 Resources

- **RBAC**: Search "Role Based Access Control implementation".
- **JWTs**: JWT.io documentation.

---

## ✅ Before Submission

- [ ] Does the system have a unified Users table with separate Profiles?
- [ ] Are Doctors prevented from viewing other doctors' appointments?
- [ ] Is double-booking prevented at the database or logic level?
- [ ] Are medical records strictly tied to a specific appointment ID?

---

**Build this and learn: Multi-user architecture, IDOR prevention, and complex relational modeling.**
