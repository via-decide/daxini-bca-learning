# 🏥 Hospital Management System: API Design

**"Build a multi-user platform where Doctors can view their appointments, Receptionists can book patients, and Administrators can manage hospital resources, all backed by a relational database."**

---

## 🔗 API Endpoints

**Authentication:**
```
POST /api/auth/login           → Login and receive a JWT
```

**Admin Routes (Requires 'admin' role):**
```
POST   /api/users              → Create a new staff member (Doctor, Receptionist)
GET    /api/users              → List all staff members
DELETE /api/users/:id          → Remove a staff member
```

**Patient Management (Requires 'admin' or 'receptionist' role):**
```
POST   /api/patients           → Register a new patient
GET    /api/patients           → List all patients (with search)
GET    /api/patients/:id       → View a specific patient's medical history
```

**Appointment Management:**
```
POST   /api/appointments       → Book an appointment (Requires 'receptionist')
GET    /api/appointments       → List appointments. 
                                 - If Doctor: Only sees their own.
                                 - If Receptionist: Sees all.
PUT    /api/appointments/:id   → Update status (e.g., 'completed'). (Requires 'doctor' or 'receptionist')
```

---

## 📦 Request/Response Examples

### 1. Login

**Request:**
```json
POST /api/auth/login
{
  "email": "dr.smith@hospital.com",
  "password": "securepassword123"
}
```

**Response (200):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "doc-123",
    "role": "doctor",
    "full_name": "Dr. John Smith"
  }
}
```

### 2. Book an Appointment (Receptionist)

**Request:**
*(Requires `Authorization: Bearer <token>` in headers)*
```json
POST /api/appointments
{
  "patient_id": "pat-456",
  "doctor_id": "doc-123",
  "appointment_date": "2026-10-15T10:00:00Z",
  "notes": "Complaining of severe headaches."
}
```

**Response (201):**
```json
{
  "message": "Appointment booked successfully",
  "appointment": {
    "id": "apt-789",
    "patient_id": "pat-456",
    "doctor_id": "doc-123",
    "appointment_date": "2026-10-15T10:00:00.000Z",
    "status": "scheduled"
  }
}
```

### 3. View Appointments (Doctor)

**Request:**
*(Requires `Authorization: Bearer <token>` in headers)*
```http
GET /api/appointments?date=2026-10-15 HTTP/1.1
```

**Response (200):**
```json
{
  "appointments": [
    {
      "id": "apt-789",
      "appointment_date": "2026-10-15T10:00:00.000Z",
      "status": "scheduled",
      "patient": {
        "id": "pat-456",
        "full_name": "Jane Doe"
      }
    }
  ]
}
```
*(Notice how the API returns nested patient data, requiring a SQL JOIN on the backend).*

---

## ⚠️ Error Responses

```json
// 401 Unauthorized (Missing or invalid JWT token)
{ "error": "Authentication required." }

// 403 Forbidden (A doctor tries to delete a user)
{ "error": "You do not have permission to perform this action." }

// 409 Conflict (Double booking a doctor)
{ "error": "Dr. Smith already has an appointment at this time." }
```
