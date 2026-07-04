# Email Scheduler API: Learn By Building

**"Build a background worker system that queues up emails to be sent at a specific time in the future, and gracefully handles retries if the email provider crashes."**

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
