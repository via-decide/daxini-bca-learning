# Email Scheduler API: Learn By Building

**"Build a background worker system that queues up emails to be sent at a specific time in the future, and gracefully handles retries if the email provider crashes."**

---


## 🔌 API Design: Plan Before Coding

### Endpoint 1: Schedule an Email
**POST `/api/emails/schedule`**
- **Body**:
```json
{
  "to": "user@example.com",
  "subject": "Don't forget your meeting!",
  "body": "Your meeting is in 10 minutes.",
  "send_at": "2024-11-01T09:00:00Z" 
}
```
- **Response**: `201 Created`
```json
{ "job_id": "8f2c...", "status": "pending" }
```

---
