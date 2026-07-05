# 📝 Complaint Management System: API Design

**"Build a multi-user API for a city or large organization where Citizens submit complaints (like Potholes), and City Workers claim, update, and resolve those complaints via a strict state machine."**

---

## 🔗 API Endpoints

*(All routes require Authentication via JWT)*

**Citizen Operations (Requires 'citizen' role):**
```
GET    /api/complaints/me      → View my submitted complaints
POST   /api/complaints         → Submit a new complaint
PUT    /api/complaints/:id/close → Accept resolution and close it
```

**Worker Operations (Requires 'worker' role):**
```
GET    /api/complaints/open    → View unassigned complaints
PUT    /api/complaints/:id/claim → Assign complaint to myself (changes state to in_progress)
PUT    /api/complaints/:id/resolve → Mark complaint as fixed
```

**Shared Operations (Citizens & Workers):**
```
GET    /api/complaints/:id/comments → View conversation history
POST   /api/complaints/:id/comments → Add a comment to the complaint
```

---

## 📦 Request/Response Examples

### 1. Submit a Complaint (Citizen)

**Request:**
```json
POST /api/complaints
{
  "category_id": "cat-roads",
  "title": "Massive pothole on 5th Ave",
  "description": "It damaged my tire. Needs fixing ASAP."
}
```

**Response (201):**
```json
{
  "message": "Complaint submitted",
  "complaint": {
    "id": "comp-123",
    "status": "open",
    "title": "Massive pothole on 5th Ave",
    "created_at": "2026-10-12T08:30:00Z"
  }
}
```

### 2. Claim a Complaint (Worker)

This endpoint changes the State Machine.

**Request:**
```json
PUT /api/complaints/comp-123/claim
{}
```

**Response (200):**
```json
{
  "message": "Complaint claimed successfully",
  "complaint": {
    "id": "comp-123",
    "status": "in_progress",
    "worker_assigned": "Wendy Worker"
  }
}
```

### 3. Fetch Comments (Shared)

**Request:**
```http
GET /api/complaints/comp-123/comments HTTP/1.1
```

**Response (200):**
```json
{
  "complaint_id": "comp-123",
  "comments": [
    {
      "id": "comment-1",
      "author": "Wendy Worker",
      "role": "worker",
      "content": "I am heading out with the asphalt truck now.",
      "created_at": "2026-10-12T14:00:00Z"
    },
    {
      "id": "comment-2",
      "author": "Charlie Citizen",
      "role": "citizen",
      "content": "Thank you! It's right in front of the bakery.",
      "created_at": "2026-10-12T14:05:00Z"
    }
  ]
}
```

---

## ⚠️ Error Responses

```json
// 409 Conflict (A worker tries to claim a complaint that another worker already claimed)
{ "error": "This complaint is already in progress by another worker." }

// 400 Bad Request (Worker tries to 'resolve' an 'open' complaint without claiming it first)
{ "error": "Invalid state transition. Complaint must be 'in_progress' before it can be 'resolved'." }

// 403 Forbidden (Citizen tries to comment on someone else's complaint)
{ "error": "You do not have permission to view this complaint." }
```
