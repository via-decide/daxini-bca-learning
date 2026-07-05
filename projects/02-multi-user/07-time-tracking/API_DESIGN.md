# ⏱️ Time Tracking API: API Design

**"Build a multi-user API where freelancers log hours against client projects, generating automated invoices and tracking real-time productivity."**

---

## 🔗 API Endpoints

*(All routes require Authentication via JWT)*

**Clients & Projects:**
```
POST   /api/clients            → Add a new client
GET    /api/clients            → Get all my clients
POST   /api/projects           → Add a project to a client
```

**Time Tracking (The Core Loop):**
```
POST   /api/time/start         → Start a new timer for a project
POST   /api/time/:id/stop      → Stop a running timer
GET    /api/time/active        → Get the currently running timer (if any)
```

**Invoicing & Analytics:**
```
GET    /api/reports/unbilled   → Get a summary of all unbilled time grouped by Client
POST   /api/invoices           → Mark a set of time entries as 'billed'
```

---

## 📦 Request/Response Examples

### 1. Start a Timer

**Request:**
```json
POST /api/time/start
{
  "project_id": "proj-123",
  "description": "Designing the homepage wireframes"
}
```

**Response (201):**
```json
{
  "message": "Timer started",
  "entry": {
    "id": "entry-999",
    "project_id": "proj-123",
    "start_time": "2026-11-05T09:00:00Z",
    "end_time": null,
    "description": "Designing the homepage wireframes"
  }
}
```

### 2. Stop a Timer

**Request:**
```json
POST /api/time/entry-999/stop
{}
```

**Response (200):**
```json
{
  "message": "Timer stopped",
  "entry": {
    "id": "entry-999",
    "start_time": "2026-11-05T09:00:00Z",
    "end_time": "2026-11-05T11:30:00Z",
    "duration_hours": 2.5,
    "earned": 125.00
  }
}
```

### 3. Generate Unbilled Report (For Invoicing)

**Request:**
```http
GET /api/reports/unbilled HTTP/1.1
```

**Response (200):**
```json
{
  "total_unbilled": 850.00,
  "clients": [
    {
      "client_id": "client-apple",
      "client_name": "Apple Inc.",
      "total_hours": 10.5,
      "total_owed": 525.00,
      "entries": [
        { "id": "entry-1", "date": "2026-11-01", "hours": 5.0, "amount": 250.00 },
        { "id": "entry-2", "date": "2026-11-02", "hours": 5.5, "amount": 275.00 }
      ]
    },
    {
      "client_id": "client-google",
      "client_name": "Google",
      "total_hours": 6.5,
      "total_owed": 325.00,
      "entries": [ ... ]
    }
  ]
}
```
*(Notice how the API does all the math and grouping. The frontend just takes this JSON and renders a beautiful invoice).*

---

## ⚠️ Error Responses

```json
// 409 Conflict (User tries to start a timer when one is already running)
{ "error": "You already have an active timer running. Stop it first." }

// 403 Forbidden (User tries to stop a timer belonging to another user)
{ "error": "You do not have permission to modify this entry." }

// 400 Bad Request (Timer is already stopped)
{ "error": "This timer has already been stopped." }
```
