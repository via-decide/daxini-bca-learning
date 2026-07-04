# Email Scheduler API: Learn By Building

**"Build a background worker system that queues up emails to be sent at a specific time in the future, and gracefully handles retries if the email provider crashes."**

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
