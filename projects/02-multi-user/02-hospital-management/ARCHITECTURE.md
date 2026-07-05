# 🏥 Hospital Management System: Learn By Building

**"Build a multi-user platform where Doctors can view their appointments, Receptionists can book patients, and Administrators can manage hospital resources, all backed by a relational database."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. A receptionist books an appointment for John Doe to see Dr. Smith on Tuesday at 10 AM.
2. Dr. Smith logs in and sees his schedule for Tuesday.
3. The administrator adds a new Doctor to the system.

**What data do you need for each?**

After thinking, here's the data model:

```
Table: Users (Doctors, Receptionists, Admins)
├─ id (UUID)
├─ email (String)
├─ password_hash (String)
├─ role (Enum: 'doctor', 'receptionist', 'admin')
└─ full_name (String)

Table: Patients
├─ id (UUID)
├─ full_name (String)
├─ date_of_birth (Date)
├─ phone_number (String)
└─ medical_history (Text)

Table: Appointments
├─ id (UUID)
├─ patient_id (Foreign Key -> Patients)
├─ doctor_id (Foreign Key -> Users WHERE role='doctor')
├─ appointment_date (DateTime)
├─ status (Enum: 'scheduled', 'completed', 'cancelled')
└─ notes (Text)
```

---

### Step 2: Multi-User Authorization (Role-Based Access Control)

**Question: How do you prevent a Receptionist from deleting a Doctor's account?**

**Bad Idea:** Trusting the frontend to hide the "Delete Doctor" button. Hackers can easily bypass the frontend and send a DELETE request directly to your API using Postman.

**Good Idea:** Implement Role-Based Access Control (RBAC) middleware on the backend. Every single HTTP request must be checked to see if the user has the correct `role`.

```javascript
// Middleware example
function requireRole(allowedRoles) {
  return (req, res, next) => {
    // req.user is set by your JWT authentication middleware
    if (!allowedRoles.includes(req.user.role)) {
      return res.status(403).json({ error: "Forbidden: Insufficient permissions." });
    }
    next();
  };
}

// Only Admins can hit this route
app.delete('/api/users/:id', requireRole(['admin']), deleteUserHandler);

// Doctors and Receptionists can hit this route
app.get('/api/appointments', requireRole(['doctor', 'receptionist']), getAppointmentsHandler);
```

---

### Step 3: Complex Queries (JOINs)

When Dr. Smith logs in to view his appointments, he doesn't just want to see a bunch of UUIDs. He wants to see the Patient's Name. This requires a SQL `JOIN`.

```sql
SELECT 
  appointments.id, 
  appointments.appointment_date, 
  patients.full_name as patient_name 
FROM appointments 
JOIN patients ON appointments.patient_id = patients.id 
WHERE appointments.doctor_id = 'doctor-uuid' 
ORDER BY appointments.appointment_date ASC;
```

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Login Screen                         │  │
│  │ Doctor Dashboard (View Appts)        │  │
│  │ Reception Dashboard (Book Appts)     │  │
│  │ Admin Dashboard (Manage Users)       │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP requests with JWT in Authorization header
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. Authentication (JWT verification) │  │
│  │ 2. Authorization (RBAC checking)     │  │
│  │ 3. Route Handlers                    │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (PostgreSQL/MySQL)         │
│  - users table (roles)                     │
│  - patients table                          │
│  - appointments table                      │
└────────────────────────────────────────────┘
```
