# 🕒 Employee Attendance System: API Design

**"Build a multi-user API where Employees clock in and out daily, and Managers view attendance reports to track tardiness and total hours worked."**

---

## 🔗 API Endpoints

*(All routes require Authentication via JWT)*

**Employee Operations (Requires 'employee' role):**
```
POST   /api/attendance/clock-in  → Record start time for the day
PUT    /api/attendance/clock-out → Record end time for the day
GET    /api/attendance/me        → View my attendance history for the month
```

**Manager Operations (Requires 'manager' role):**
```
GET    /api/reports/daily        → View today's attendance for all direct reports
GET    /api/reports/anomalies    → View records missing a clock-out for direct reports
PUT    /api/attendance/:id/fix   → Manually correct an employee's time record
```

---

## 📦 Request/Response Examples

### 1. Clock In (Employee)

The backend records the exact server time. The frontend does not send the time (to prevent cheating).

**Request:**
```json
POST /api/attendance/clock-in
{}
```

**Response (201):**
```json
{
  "message": "Clocked in successfully",
  "record": {
    "id": "att-123",
    "date": "2026-10-15",
    "clock_in_time": "2026-10-15T08:55:00Z",
    "status": "present"
  }
}
```

### 2. Clock Out (Employee)

The backend finds today's open record for the user and updates it.

**Request:**
```json
PUT /api/attendance/clock-out
{}
```

**Response (200):**
```json
{
  "message": "Clocked out successfully",
  "record": {
    "id": "att-123",
    "clock_out_time": "2026-10-15T17:05:00Z",
    "total_hours_worked": 8.16
  }
}
```

### 3. Daily Report (Manager)

The backend fetches all direct reports and shows their status for the current day.

**Request:**
```http
GET /api/reports/daily?date=2026-10-15 HTTP/1.1
```

**Response (200):**
```json
{
  "date": "2026-10-15",
  "attendance": [
    {
      "employee_name": "Ethan Employee",
      "status": "present",
      "clock_in": "08:55",
      "clock_out": null
    },
    {
      "employee_name": "Alice Slacker",
      "status": "late",
      "clock_in": "09:30",
      "clock_out": null
    },
    {
      "employee_name": "Bob Missing",
      "status": "absent",
      "clock_in": null,
      "clock_out": null
    }
  ]
}
```

---

## ⚠️ Error Responses

```json
// 409 Conflict (Employee tries to clock in twice on the same day)
{ "error": "You have already clocked in today." }

// 400 Bad Request (Employee tries to clock out, but hasn't clocked in yet)
{ "error": "No active clock-in record found for today." }

// 403 Forbidden (Manager tries to fix a record for an employee in another department)
{ "error": "You are not authorized to modify this employee's records." }
```
