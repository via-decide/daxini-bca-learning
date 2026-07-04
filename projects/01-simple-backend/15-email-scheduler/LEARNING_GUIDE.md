# Email Scheduler API: Learn By Building

**"Build a background worker system that queues up emails to be sent at a specific time in the future, and gracefully handles retries if the email provider crashes."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Message Queues / Background Jobs** - Offloading slow tasks (like sending emails) so your API can respond instantly.
✅ **Third-Party Email APIs** - Integrating with transactional providers like SendGrid, Resend, or Postmark.
✅ **Retry Logic & Idempotency** - Ensuring an email isn't sent twice if the system restarts halfway through.
✅ **Cron Workers** - Creating a dedicated worker script that runs independently of your main API server.

---

## 📋 Project Overview

### The Problem
Sending an email via an external API (like SendGrid) takes about 1 to 2 seconds. If a user registers for your site and your API waits for the email to send before responding, the user stares at a loading spinner for 2 seconds. Worse, if they schedule a reminder for next Tuesday, your API cannot simply use `setTimeout` for 5 days, because if the server restarts, the timer is lost forever. You need a durable database queue and a background worker.

### Who Uses It
```
Frontend App:
├─ Requests: "Send me a reminder email on Tuesday at 9 AM"
└─ Receives instant response: 201 Created

Backend API (You):
├─ Saves the job to the database with scheduled_for = Tuesday
└─ Returns 201 Created instantly

Background Worker (Runs every minute):
├─ Checks DB: "Any jobs scheduled for right now?"
├─ Finds Tuesday job. Calls SendGrid API.
└─ Marks job as 'completed'.
```

### The Big Picture

```text
┌────────────┐     ┌─────────────┐     ┌──────────────┐
│  Client    │ ──> │ Main API    │ ──> │ DB (Queue)   │
└────────────┘     └─────────────┘     └──────┬───────┘
                                              │ (Pulls jobs)
                                              V
┌────────────┐     ┌─────────────┐     ┌──────────────┐
│  Inbox     │ <── │ SendGrid    │ <── │ Background   │
└────────────┘     └─────────────┘     │ Worker       │
                                       └──────────────┘
```

---

## 🏗️ Architecture: Design Before Coding

### Step 1: The Producer-Consumer Pattern

**Question: Why split the app into two parts (Main API and Worker)?**
- The **Producer (Main API)** takes web traffic. It needs to be lightning fast. It just puts tasks into a box (the database) and hangs up the phone.
- The **Consumer (Worker)** doesn't take web traffic. It constantly checks the box for new tasks and executes them. If the Worker crashes while sending an email, the Main API stays perfectly online.

### Step 2: Architecture Diagram

```text
1. Client POSTs /api/schedule-email { to: "x@y.com", body: "Hi", send_at: "2024-11-01T09:00:00Z" }
2. Main API saves to DB with status = "pending". Returns 201.

3. Worker Script (Running independently):
   a. SELECT * FROM Emails WHERE status = 'pending' AND send_at <= NOW()
   b. UPDATE Emails SET status = 'processing'
   c. Call SendGrid API
   d. IF success -> UPDATE Emails SET status = 'completed'
   e. IF error -> UPDATE Emails SET status = 'failed', increment retries
```

---

## 🗄️ Database: Design, Don't Code

### Schema Design (SQL)

```text
Table: EmailJobs
- id: UUID
- to_address: VARCHAR
- subject: VARCHAR
- body: TEXT
- send_at: TIMESTAMP (UTC)
- status: VARCHAR (Enum: 'pending', 'processing', 'completed', 'failed')
- retries: INT (Default 0)
```

### Design Questions

1. **Why the 'processing' status?**
   If you have two Worker scripts running at the same time, you don't want them both to pull the same email and send it twice. When Worker A grabs the job, it immediately marks it as 'processing' so Worker B ignores it.

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

## 🧠 Implementation: Pseudocode First

```text
// --- FILE 1: Main API ---
FUNCTION schedule_email(request, response):
    send_at_time = request.body.send_at
    
    // Default to 'now' if no date provided
    IF send_at_time is NULL:
        send_at_time = NOW()
        
    DB.insert("EmailJobs", {
        to_address: request.body.to,
        subject: request.body.subject,
        body: request.body.body,
        send_at: send_at_time,
        status: "pending"
    })
    
    RETURN 201 "Scheduled successfully"


// --- FILE 2: Background Worker Script ---
FUNCTION process_emails():
    // 1. Fetch Due Jobs (Atomic lock if supported by DB, e.g., FOR UPDATE SKIP LOCKED in Postgres)
    jobs = DB.query("SELECT * FROM EmailJobs WHERE status = 'pending' AND send_at <= NOW()")
    
    FOR job IN jobs:
        DB.update("EmailJobs", job.id, { status: "processing" })
        
        TRY:
            // 2. Call External Email Provider (SendGrid/Resend)
            HTTP.POST("https://api.sendgrid.com/...", { to: job.to_address, body: job.body })
            
            // 3. Mark Complete
            DB.update("EmailJobs", job.id, { status: "completed" })
            
        CATCH Error:
            // 4. Handle Failure
            IF job.retries < 3:
                DB.update("EmailJobs", job.id, { status: "pending", retries: job.retries + 1 })
            ELSE:
                DB.update("EmailJobs", job.id, { status: "failed" })

// Run the worker every 30 seconds
setInterval(process_emails, 30000)
```

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Not Handling Failures Gracefully
**What's wrong:** The SendGrid API goes down for 5 minutes. The `TRY` block crashes, the job stays stuck in 'processing' forever, and the email never sends.
**Why it's bad:** Your queue gets permanently stuck.
**How to fix:** Ensure the `CATCH` block reverts the status back to 'pending' (with a retry limit) so the worker tries again later.

### ❌ Mistake 2: Storing Plain Text Passwords in the Email Body
**What's wrong:** `body: "Your new password is: Password123!"`.
**Why it's bad:** Email is fundamentally unencrypted as it travels across the internet. Never send passwords or sensitive PI data in an email payload.

---

## 🧪 Testing: How to Verify

### Test 1: Future Scheduling
- Schedule an email for 2 minutes from now.
- Ensure your worker script doesn't pick it up immediately.
- Wait 2 minutes. The worker should automatically pick it up and process it.

### Test 2: Retry Logic Simulation
- Temporarily change your API Key to a fake string (so SendGrid rejects the request).
- Schedule an email.
- Watch your worker's logs. It should try, fail, increase retries to 1, try again later, increase to 2, and eventually mark it as 'failed'.

---

## 🛠️ Debugging: When Things Break

### Problem: Users receive the same email twice.
**Root Cause:** The worker takes 5 seconds to send the email. But your loop runs every 2 seconds. The second loop starts, sees the email is still "pending", and sends it again!
**Solution:** Ensure you immediately mark the job as 'processing' *before* making the HTTP call to the email provider, or use proper database-level row locking.

---

## 📚 Resources

- **Queues**: Read about "Message Queues" (RabbitMQ, Redis BullMQ) vs "Database Queues".
- **Database Locks**: Look up `SELECT ... FOR UPDATE SKIP LOCKED` (PostgreSQL/MySQL).
- **Email APIs**: Read the Resend or Postmark API documentation for Node/Python.

---

## ✅ Before Submission

- [ ] Does the Main API return instantly without waiting for the email to send?
- [ ] Does the Worker script correctly isolate failed jobs after 3 retries?
- [ ] Are you preventing double-sends by updating the job status to 'processing' first?
- [ ] Are your `send_at` times stored securely in UTC to prevent timezone bugs?

---

**Build this and learn: Producer-Consumer architecture, background jobs, external integrations, and retry logic.**
