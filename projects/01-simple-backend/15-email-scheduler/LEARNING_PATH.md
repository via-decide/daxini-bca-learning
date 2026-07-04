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


## ✅ Before Submission

- [ ] Does the Main API return instantly without waiting for the email to send?
- [ ] Does the Worker script correctly isolate failed jobs after 3 retries?
- [ ] Are you preventing double-sends by updating the job status to 'processing' first?
- [ ] Are your `send_at` times stored securely in UTC to prevent timezone bugs?

---

**Build this and learn: Producer-Consumer architecture, background jobs, external integrations, and retry logic.**
