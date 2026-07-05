# 🏥 Hospital Management System: Learn By Building

**"Build a multi-user platform where Doctors can view their appointments, Receptionists can book patients, and Administrators can manage hospital resources, all backed by a relational database."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Authentication vs Authorization** - The difference between proving *who* you are (Login/JWT) and proving *what* you can do (Role-Based Access Control).  
✅ **Relational Database Design** - Managing multiple tables (`users`, `patients`, `appointments`) with Foreign Keys.  
✅ **SQL JOINs** - Combining data from multiple tables into a single efficient query.  
✅ **Data Isolation** - Ensuring users (like Doctors) can only fetch and view data that belongs to them.

---

## 📋 Project Overview

### The Problem

Simple apps only have one type of user (e.g., a To-Do list app). Enterprise applications have a hierarchy. An Admin can do everything. A Receptionist can create records but not delete staff. A Doctor can only view their own schedule. 

If you mess up the logic, a receptionist might accidentally delete the database, or a doctor might see another doctor's private patient notes.

**Your job:** Build a secure, role-based backend that strictly enforces who can read, write, and delete specific types of data.

### Who Uses It

```
Admin:
├─ Logs in -> Gets Admin JWT
└─ POST /api/users to create Doctors and Receptionists

Receptionist:
├─ Logs in -> Gets Receptionist JWT
├─ POST /api/patients
└─ POST /api/appointments to book a patient with a doctor

Doctor:
├─ Logs in -> Gets Doctor JWT
└─ GET /api/appointments -> Sees ONLY their own schedule
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. The RBAC Middleware (The Gatekeeper)

This is the most important part of a multi-user application.
```javascript
// 1. Verify the JWT Token
function authenticateUser(req, res, next) {
  token = req.headers.authorization
  if (!token) return 401 "Missing token"
  
  try {
    userPayload = jwt.verify(token, "SECRET_KEY")
    req.user = userPayload // { id: "123", role: "doctor" }
    next()
  } catch {
    return 401 "Invalid token"
  }
}

// 2. Check the Role
function requireRole(allowedRolesArray) {
  return function(req, res, next) {
    if (allowedRolesArray.includes(req.user.role)) {
      next() // Access granted!
    } else {
      return 403 "Forbidden: You don't have the right role"
    }
  }
}
```

### 2. Registering a New Patient (Receptionist/Admin only)

```pseudocode
// Attach our middlewares to the route
POST /api/patients 
  middlewares: [authenticateUser, requireRole(['admin', 'receptionist'])]

  // If we reach this code, the user is GUARANTEED to be logged in 
  // AND guaranteed to be an admin or receptionist.
  
  try {
    db.insert("patients", {
      id: generateUUID(),
      full_name: request.body.full_name,
      date_of_birth: request.body.dob,
      medical_history: request.body.medical_history
    })
    return 201 "Patient created"
  } catch {
    return 500 "Database error"
  }
```

### 3. Viewing Appointments (Data Isolation + JOINs)

```pseudocode
// Doctors and Receptionists can view appointments
GET /api/appointments
  middlewares: [authenticateUser, requireRole(['doctor', 'receptionist'])]
  
  // Setup the base SQL query with a JOIN so we get the patient's name
  sql = `
    SELECT appointments.*, patients.full_name as patient_name
    FROM appointments
    JOIN patients ON appointments.patient_id = patients.id
  `
  params = []
  
  // DATA ISOLATION: If they are a doctor, force the query to only 
  // return their appointments. If receptionist, return all.
  if req.user.role == 'doctor':
    sql += " WHERE appointments.doctor_id = ?"
    params.push(req.user.id)
    
  sql += " ORDER BY appointments.appointment_date ASC"
  
  // Execute
  results = db.query(sql, params)
  
  // Since SQL returns "flat" data, we might want to shape it into nice JSON
  formatted_results = results.map(row => {
    return {
      id: row.id,
      date: row.appointment_date,
      status: row.status,
      patient: {
        id: row.patient_id,
        name: row.patient_name
      }
    }
  })
  
  return 200 formatted_results
```

---

## ✅ Before Submission

- [ ] System supports Login with JWT generation.
- [ ] Routes are protected by authentication middleware.
- [ ] Role-Based Access Control (RBAC) middleware prevents unauthorized actions (e.g., Doctors creating new users).
- [ ] The API uses SQL `JOIN`s to return readable data (e.g., Patient Names instead of just UUIDs).
- [ ] Data isolation is enforced (Doctors only see their own appointments).
- [ ] Code is on GitHub.

**Success:** You have built a secure, enterprise-grade multi-tenant architecture!
