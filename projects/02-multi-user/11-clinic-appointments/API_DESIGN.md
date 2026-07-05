# 🩺 Clinic Appointments API: API Design

**"Build a scheduling API where Doctors define their weekly availability, and Patients book specific 15-minute time slots, requiring strict time-boundary logic and overlap prevention."**

---

## 🔗 API Endpoints

*(All routes require Authentication via JWT)*

**Doctor Operations (Requires 'doctor' role):**
```
GET    /api/schedules/me       → View my current weekly availability schedule
PUT    /api/schedules/me       → Update my weekly availability
GET    /api/appointments/me    → View my upcoming appointments
```

**Patient Operations (Requires 'patient' role):**
```
GET    /api/doctors            → List all doctors
GET    /api/doctors/:id/slots  → Get available 15-min slots for a specific date
POST   /api/appointments       → Book a time slot
```

---

## 📦 Request/Response Examples

### 1. Update Doctor Schedule

**Request:**
```json
PUT /api/schedules/me
{
  "schedule": [
    { "day_of_week": 1, "start_time": "09:00:00", "end_time": "17:00:00" }, 
    { "day_of_week": 2, "start_time": "09:00:00", "end_time": "12:00:00" } 
    // Monday full day, Tuesday half day.
  ]
}
```

**Response (200):**
```json
{
  "message": "Schedule updated successfully"
}
```

### 2. Fetch Available Slots (Patient)

This is the most complex endpoint. The backend calculates these slots dynamically.

**Request:**
```http
GET /api/doctors/doc-123/slots?date=2026-10-12 HTTP/1.1
```

**Response (200):**
```json
{
  "doctor_id": "doc-123",
  "date": "2026-10-12",
  "available_slots": [
    "09:00:00",
    "09:15:00",
    // 09:30:00 is missing because it's already booked!
    "09:45:00",
    "10:00:00",
    "10:15:00"
  ]
}
```

### 3. Book an Appointment (Patient)

**Request:**
```json
POST /api/appointments
{
  "doctor_id": "doc-123",
  "appointment_date": "2026-10-12",
  "start_time": "09:45:00"
}
```

**Response (201):**
```json
{
  "message": "Appointment booked successfully",
  "appointment": {
    "id": "apt-777",
    "doctor_id": "doc-123",
    "patient_id": "pat-456",
    "appointment_date": "2026-10-12",
    "start_time": "09:45:00",
    "status": "scheduled"
  }
}
```

---

## ⚠️ Error Responses

```json
// 409 Conflict (Someone else booked this exact slot 1 second ago)
{ "error": "This time slot is no longer available." }

// 400 Bad Request (Patient tries to book a time the doctor doesn't work)
{ "error": "Doctor is not available at this time." }

// 400 Bad Request (Patient tries to book at 09:12:00 instead of 09:15:00)
{ "error": "Appointments must be on 15-minute intervals." }
```
