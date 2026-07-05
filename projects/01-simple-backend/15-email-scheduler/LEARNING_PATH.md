# ✉️ Email Scheduler API: Learn By Building

**"Build a background job system that accepts email content, schedules it for a specific time, and uses cron jobs or a worker queue to deliver it reliably."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Background Workers** - How to run tasks outside the normal HTTP Request/Response cycle.  
✅ **Job Queues** - Using a database table as a reliable task queue.  
✅ **State Machines** - Managing status transitions (pending → processing → sent/failed/cancelled).  
✅ **Concurrency Control** - Safely "claiming" tasks to prevent multiple workers from sending the same email.  
✅ **Error Handling & Resilience** - Ensuring a failure on one email doesn't crash the whole system.  
✅ **Timezones & Dates** - Safely handling UTC timestamps for scheduling.  
✅ **3rd-Party API Integration** - Connecting to SMTP servers (like Mailtrap or SendGrid) to actually dispatch emails.

---

## 📋 Project Overview

### The Problem

When a user signs up for an app, you want to send them a "Welcome" email immediately, but maybe a "Checking in" email 3 days later. If you do this in the main web thread, the user's browser will spin waiting for the SMTP server. If you use `setTimeout`, it gets erased when the server restarts.

**Your job:** Build a persistent scheduling engine that reliably sends emails exactly when requested, regardless of server reboots.

### Who Uses It

```
The User (via API Dashboard):
├─ Create contacts
├─ Schedule emails for future dates
├─ Cancel pending emails
└─ View history and success/failure logs

The Background Worker (Internal):
├─ Wakes up every 1 minute
├─ Finds emails due to be sent
├─ Claims them
├─ Sends them via SMTP
└─ Updates the database with the result
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. Schedule the Email (Web API)

```pseudocode
POST /api/emails/schedule(recipient_email, subject, body_text, scheduled_for):
  Step 1: Authenticate
    Verify JWT token -> get user_id
    
  Step 2: Validate Date
    if scheduled_for < NOW():
      return error 400 "Cannot schedule emails in the past"
      
  Step 3: Save to Queue
    email_id = database.insert("scheduled_emails", {
      user_id, recipient_email, subject, body_text, scheduled_for,
      status: 'pending'
    })
    
  Step 4: Return success
    // Notice we do NOT send the email here! We just saved it.
    return { id: email_id, status: 'pending' }
```

### 2. The Background Worker (Cron Script)

```pseudocode
// Run this block of code every 60 seconds
setInterval(async () => {
  
  // Step 1: CLAIM THE EMAILS (Concurrency protection)
  // This must be a single SQL UPDATE statement.
  affected_rows = database.execute(`
    UPDATE scheduled_emails 
    SET status = 'processing' 
    WHERE status = 'pending' AND scheduled_for <= NOW()
  `)
  
  if (affected_rows == 0) return; // Nothing to do
  
  // Step 2: FETCH THE CLAIMED EMAILS
  emails = database.query("SELECT * FROM scheduled_emails WHERE status = 'processing'")
  
  // Step 3: PROCESS EACH EMAIL SAFELY
  foreach email in emails:
    try:
      // Actually send it over the internet
      smtp_result = send_via_nodemailer(email.recipient_email, email.subject, email.body_text)
      
      // Mark as successful
      database.update("scheduled_emails", email.id, { 
        status: 'sent', 
        sent_at: NOW(),
        attempt_count: email.attempt_count + 1
      })
      
    catch (error):
      // Mark as failed, but don't crash the loop!
      database.update("scheduled_emails", email.id, { 
        status: 'failed', 
        last_error: error.message,
        attempt_count: email.attempt_count + 1
      })
      
}, 60000)
```

### 3. Cancel an Email (Web API)

```pseudocode
PATCH /api/emails/:id/cancel:
  Step 1: Fetch email
    email = database.query("SELECT * FROM scheduled_emails WHERE id = ? AND user_id = ?", id, req.user_id)
    if not email: return error 404
    
  Step 2: Check status
    if email.status != 'pending':
      return error 403 "Too late, email is already processing or sent"
      
  Step 3: Update status
    database.update("scheduled_emails", id, { status: 'cancelled' })
    return success
```

---

## ✅ Before Submission

- [ ] Authentication works (User can login)
- [ ] User can schedule an email for a future date
- [ ] API validates that the date is actually in the future
- [ ] User can cancel a 'pending' email
- [ ] Background worker script runs continuously using `setInterval` or `node-cron`
- [ ] Worker safely claims emails using an UPDATE statement to prevent duplicates
- [ ] Worker successfully dispatches emails using an SMTP tool (like Mailtrap)
- [ ] Worker updates DB status to 'sent' upon success
- [ ] Worker catches SMTP errors and updates DB status to 'failed' without crashing
- [ ] User can view the success/failure history in the API
- [ ] Code is on GitHub

**Success:** A robust, persistent queue that acts as the foundation for any asynchronous task system (not just emails!).
