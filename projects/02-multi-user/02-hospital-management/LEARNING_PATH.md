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


## ✅ Before Submission

- [ ] Does the system have a unified Users table with separate Profiles?
- [ ] Are Doctors prevented from viewing other doctors' appointments?
- [ ] Is double-booking prevented at the database or logic level?
- [ ] Are medical records strictly tied to a specific appointment ID?

---

**Build this and learn: Multi-user architecture, IDOR prevention, and complex relational modeling.**
