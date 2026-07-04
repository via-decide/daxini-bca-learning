# Hospital Management System: Learn By Building

**"Build a multi-user system for managing patient records, doctor appointments, and hospital administration with strict access controls."**

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
