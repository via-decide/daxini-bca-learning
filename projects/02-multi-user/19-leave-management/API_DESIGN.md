# 🌴 Leave Management System: API Design

**"Build a multi-user API where Employees request time off (PTO/Sick leave), and Managers approve or reject these requests while the system strictly enforces available leave balances."**

---

## 🔗 API Endpoints

*(All routes require Authentication via JWT)*

**Employee Operations (Requires 'employee' or 'manager' role):**
```
GET    /api/leave/balances     → View my remaining PTO and Sick days
GET    /api/leave/my-requests  → View status of my past and pending requests
POST   /api/leave/request      → Submit a new time-off request
```

**Manager Operations (Requires 'manager' role):**
```
GET    /api/leave/inbox               → View all 'pending' requests from my direct reports
PUT    /api/leave/requests/:id/approve → Approve a request (Deducts balance)
PUT    /api/leave/requests/:id/reject  → Reject a request
```

---

## 📦 Request/Response Examples

### 1. Apply for Leave (Employee)

**Request:**
```json
POST /api/leave/request
{
  "leave_type": "pto",
  "start_date": "2026-11-20",
  "end_date": "2026-11-25",
  "requested_days": 4
}
```

**Response (201):**
```json
{
  "message": "Leave request submitted to your manager",
  "request": {
    "id": "req-123",
    "status": "pending",
    "requested_days": 4
  }
}
```

### 2. View Manager Inbox (Manager)

The backend must filter this list so Manager Mary ONLY sees requests from users where `manager_id == mary.id`.

**Request:**
```http
GET /api/leave/inbox HTTP/1.1
```

**Response (200):**
```json
{
  "pending_requests": [
    {
      "request_id": "req-123",
      "employee_name": "Ethan Employee",
      "leave_type": "pto",
      "dates": "Nov 20 - Nov 25, 2026",
      "requested_days": 4,
      "employee_pto_balance": 15
    }
  ]
}
```

### 3. Approve Leave (Manager)

This endpoint triggers a database transaction that updates the status AND deducts the balance.

**Request:**
```json
PUT /api/leave/requests/req-123/approve
{
  "manager_comment": "Have a great trip!"
}
```

**Response (200):**
```json
{
  "message": "Leave approved and balance deducted",
  "new_balance": {
    "pto": 11
  }
}
```

---

## ⚠️ Error Responses

```json
// 400 Bad Request (Employee requests 10 days, but only has 5 left)
{ "error": "Insufficient leave balance for this request." }

// 403 Forbidden (Manager tries to approve a request for someone who doesn't report to them)
{ "error": "You are not authorized to approve this request." }

// 409 Conflict (Manager tries to approve a request that was already approved/rejected)
{ "error": "This request has already been processed." }
```
