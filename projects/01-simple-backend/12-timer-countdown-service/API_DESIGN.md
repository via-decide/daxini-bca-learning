# ⏱️ Timer & Countdown Service: API Design

**"Build an API that creates shareable countdown timers (e.g., 'Product Launch', 'New Year'), stores them persistently, and calculates the remaining time precisely whenever requested."**

---

## 🔗 API Endpoints

```
POST   /api/timers               → Create a new countdown timer
GET    /api/timers/:id           → Fetch a timer by its short ID
```

---

## 📦 Request/Response Examples

### 1. Create a Timer

**Request:**
```json
POST /api/timers
{
  "title": "My 30th Birthday",
  "target_datetime": "2030-05-15T19:00:00Z"
}
```
*(Note: The client MUST send a standard ISO 8601 date string, preferably with timezone information).*

**Response (201):**
```json
{
  "message": "Timer created",
  "timer": {
    "id": "bDay30",
    "url": "http://localhost:3000/api/timers/bDay30",
    "title": "My 30th Birthday",
    "target_datetime": "2030-05-15T19:00:00.000Z",
    "created_at": "2026-10-01T10:00:00.000Z"
  }
}
```

### 2. Fetch a Timer

**Request:**
```http
GET /api/timers/bDay30 HTTP/1.1
```

**Response (200):**
```json
{
  "id": "bDay30",
  "title": "My 30th Birthday",
  "target_datetime": "2030-05-15T19:00:00.000Z",
  "status": "active"
}
```

*Optional Feature: If you really want the backend to do the math (useful for simple CLI tools), you can include calculated fields in the response:*
```json
{
  "id": "bDay30",
  "title": "My 30th Birthday",
  "target_datetime": "2030-05-15T19:00:00.000Z",
  "status": "active",
  "time_remaining_ms": 114318000000, 
  "is_expired": false
}
```

---

## ⚠️ Error Responses

```json
// 400 Bad Request (Invalid Date Format)
{ "error": "Invalid target_datetime. Please provide a valid ISO 8601 string." }

// 400 Bad Request (Date in the past)
{ "error": "target_datetime must be in the future." }

// 404 Not Found
{ "error": "Timer not found." }
```
