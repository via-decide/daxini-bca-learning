# Email Scheduler API: Learn By Building

**"Build a background worker system that queues up emails to be sent at a specific time in the future, and gracefully handles retries if the email provider crashes."**

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
