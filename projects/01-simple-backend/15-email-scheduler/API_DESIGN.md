# ✉️ Email Scheduler API: API Design

**"Build a background job system that accepts email content, schedules it for a specific time, and uses cron jobs or a worker queue to deliver it reliably."**

---

## 🔗 API Endpoints

### Authentication

```
POST   /api/auth/register     → Create account
POST   /api/auth/login        → Login, get JWT token
```

### Contacts (Address Book)

```
GET    /api/contacts          → List saved contacts
POST   /api/contacts          → Save a new contact
DELETE /api/contacts/:id      → Delete a contact
```

### Email Scheduling (Requires JWT Authentication)

```
GET    /api/emails            → List all emails (can filter by ?status=pending)
POST   /api/emails/schedule   → Create and schedule a new email
GET    /api/emails/:id        → View email details and status
PATCH  /api/emails/:id/cancel → Change status to 'cancelled' (only if currently 'pending')
```

---

## 📦 Request/Response Examples

### 1. Schedule an Email

**Request:**
```json
POST /api/emails/schedule
Authorization: Bearer <jwt_token>
{
  "recipient_email": "client@example.com",
  "subject": "Invoice for Q3",
  "body_text": "Please find your invoice attached...",
  "scheduled_for": "2026-10-01T09:00:00Z"
}
```

**Response (201):**
```json
{
  "message": "Email scheduled successfully",
  "data": {
    "id": "uuid-email-1",
    "status": "pending",
    "scheduled_for": "2026-10-01T09:00:00Z"
  }
}
```

### 2. Check Email Status

**Request:**
```json
GET /api/emails/uuid-email-1
Authorization: Bearer <jwt_token>
```

**Response (200):**
```json
{
  "id": "uuid-email-1",
  "recipient_email": "client@example.com",
  "subject": "Invoice for Q3",
  "status": "sent",
  "scheduled_for": "2026-10-01T09:00:00Z",
  "sent_at": "2026-10-01T09:00:05Z",
  "attempt_count": 1,
  "last_error": null
}
```

### 3. Cancel an Email

**Request:**
```json
PATCH /api/emails/uuid-email-1/cancel
Authorization: Bearer <jwt_token>
```

**Response (200):**
```json
{
  "message": "Email cancelled",
  "status": "cancelled"
}
```

---

## ⚠️ Error Responses

```json
// 400 Bad Request
{ "error": "scheduled_for must be a future date in ISO 8601 format" }

// 403 Forbidden (Trying to cancel an email that already sent)
{ "error": "Cannot cancel an email that is already processing or sent" }

// 404 Not Found
{ "error": "Email not found" }
```
