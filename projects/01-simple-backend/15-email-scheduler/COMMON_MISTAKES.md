# ✉️ Email Scheduler API: Learn By Building

**"Build a background job system that accepts email content, schedules it for a specific time, and uses cron jobs or a worker queue to deliver it reliably."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Relying on `setTimeout` for Long-Term Scheduling

**Wrong:**
```javascript
app.post('/api/emails/schedule', (req, res) => {
  const delayMs = new Date(req.body.scheduled_for) - new Date();
  
  // NEVER DO THIS for background jobs!
  setTimeout(() => {
    sendEmail(req.body);
  }, delayMs);
  
  res.json({ message: "Scheduled" });
});
```
*Why it's bad:* If the user schedules an email for 3 days from now, and your server restarts tomorrow (due to a crash or a deployment), the `setTimeout` is destroyed. The email is lost forever.

**Right:**
Save the email to the database with a `scheduled_for` timestamp. Have a completely separate cron job (or `setInterval`) run every 1 minute to check the database for emails whose `scheduled_for` time has passed.

### ❌ Mistake 2: Missing the 'Processing' State

**Wrong:**
```javascript
// Background Worker
const emails = db.query("SELECT * FROM scheduled_emails WHERE status = 'pending' AND scheduled_for <= NOW()");

for (let email of emails) {
  // Sending email takes 2 seconds over the network...
  await sendEmail(email);
  // Mark as sent
  db.update("scheduled_emails", email.id, { status: 'sent' });
}
```
*Why it's bad:* If you have 500 emails, it will take 1000 seconds to send them. If the cron job runs again 1 minute later, it will select the exact same 500 emails because they are still marked as 'pending'! It will send duplicates.

**Right:**
```javascript
// Step 1: CLAIM the emails instantly (Transaction)
db.query("UPDATE scheduled_emails SET status = 'processing' WHERE status = 'pending' AND scheduled_for <= NOW()");

// Step 2: FETCH the claimed emails
const emails = db.query("SELECT * FROM scheduled_emails WHERE status = 'processing'");

// Step 3: Send them slowly
for (let email of emails) {
  await sendEmail(email);
  db.update("scheduled_emails", email.id, { status: 'sent' });
}
```

### ❌ Mistake 3: Throwing Uncaught Errors in the Worker

**Wrong:**
```javascript
setInterval(async () => {
  const emails = db.query("SELECT * FROM scheduled_emails WHERE status = 'processing'");
  for (let email of emails) {
    // If this throws an error (e.g. SMTP server down), the loop breaks!
    await sendEmail(email);
    db.update("scheduled_emails", email.id, { status: 'sent' });
  }
}, 60000);
```
*Why it's bad:* If the first email fails, the loop throws an exception and crashes. The remaining emails are never processed.

**Right:**
```javascript
setInterval(async () => {
  const emails = db.query("SELECT * FROM scheduled_emails WHERE status = 'processing'");
  for (let email of emails) {
    try {
      await sendEmail(email);
      db.update("scheduled_emails", email.id, { status: 'sent' });
    } catch (error) {
      // Log the error, update the DB, and CONTINUE the loop
      db.update("scheduled_emails", email.id, { status: 'failed', last_error: error.message });
    }
  }
}, 60000);
```

### ❌ Mistake 4: Not Handling Timezones Properly

**Wrong:**
The user is in India (IST, UTC+5:30) and schedules an email for "12:00 PM". The frontend sends `"2026-10-01 12:00:00"`. The backend saves it. When does it send? Who knows.

**Right:**
Always require the frontend to send dates in full ISO 8601 UTC format (e.g., `"2026-10-01T06:30:00Z"`). The backend only ever compares this to `NOW()` in UTC. Timezones are solely a frontend UI concern.

---
