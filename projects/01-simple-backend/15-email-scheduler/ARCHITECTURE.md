# ✉️ Email Scheduler API: Learn By Building

**"Build a background job system that accepts email content, schedules it for a specific time, and uses cron jobs or a worker queue to deliver it reliably."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. User logs in to their dashboard.
2. User drafts an email: "Happy New Year!" and schedules it for Jan 1st at 12:00 AM.
3. User decides to cancel the scheduled email before it goes out.
4. The system attempts to send the email, but the SMTP server fails. It needs to retry later.
5. The email is sent successfully, and the system records exactly when it happened.

**What data do you need for each?**

After thinking, here's the data model:

```
Users (for login)
├─ id (UUID)
├─ email (unique)
├─ password_hash
└─ created_at

Contacts (address book)
├─ id (UUID)
├─ user_id (links to Users)
├─ email
├─ name
└─ created_at

Scheduled_Emails (the core queue)
├─ id (UUID)
├─ user_id (links to Users)
├─ recipient_email
├─ subject
├─ body_text
├─ body_html (optional)
├─ scheduled_for (timestamp)
├─ status (pending / processing / sent / failed / cancelled)
├─ attempt_count (integer)
├─ last_error (text)
├─ sent_at (timestamp, nullable)
└─ created_at
```

---

### Step 2: The Polling vs. Event-Driven Dilemma

**Question: How does the server know WHEN to send an email?**

**Option A (Cron Job / Polling):**
- A script runs every 1 minute (`* * * * *`).
- It asks the DB: `SELECT * FROM scheduled_emails WHERE status = 'pending' AND scheduled_for <= NOW()`
- Pros: Exceptionally easy to build and understand.
- Cons: If emails are scheduled for 10:05:00, they might not send until 10:05:59 depending on when the cron ticks.

**Option B (In-Memory Timers / Redis Delayed Queue):**
- When an email is scheduled, tell Redis to hold it, or use `setTimeout`.
- Pros: Millisecond precision.
- Cons: `setTimeout` clears if the server crashes. Redis requires learning a new infrastructure tool.

**Decision:** We will use **Polling (Cron Job + Database Queue)** because it teaches the fundamental concept of a "background worker" and persistent state. It is resilient to server crashes.

---

### Step 3: Database Architecture

```
┌──────────────────────────────────────────┐
│              Database                    │
├──────────────────────────────────────────┤
│                                          │
│  users ─────────┐                        │
│                 │                        │
│                 ├──► contacts            │
│                 │                        │
│                 └──► scheduled_emails    │
│                                          │
└──────────────────────────────────────────┘

Relationships:
- users.id → contacts.user_id (one user, many contacts)
- users.id → scheduled_emails.user_id (one user, many scheduled emails)
```

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML)             │
│  ┌──────────────────────────────────────┐  │
│  │ Dashboard (Upcoming & Past emails)   │  │
│  │ Composer (Subject, Body, Time picker)│  │
│  │ Address Book                         │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP Requests
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ Auth (JWT validation)                │  │
│  ├──────────────────────────────────────┤  │
│  │ API Endpoints                        │  │
│  │  - Schedule new email                │  │
│  │  - Cancel pending email              │  │
│  │  - List history                      │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │                 ▲
          Save Task             │
              ▼                 │ Look for Tasks
┌────────────────────────────────────────────┐
│        Database (SQLite/PostgreSQL)        │
│  - scheduled_emails table acts as a QUEUE│
└────────────────────────────────────────────┘
              ▲
        Claim Task & Update Status
              │
┌────────────────────────────────────────────┐
│       Background Worker (Cron/Interval)    │
│  ┌──────────────────────────────────────┐  │
│  │ Query: "Find pending emails <= NOW()"│  │
│  │ Mark them as "processing"            │  │
│  │ Send via Nodemailer/SendGrid         │  │
│  │ Mark as "sent" or "failed"           │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
```

---

### Step 5: The "Double Send" Concurrency Problem

If you have two servers running the background worker, both might query `SELECT * FROM scheduled_emails` at the exact same millisecond. 
Result: They both fetch the same email, both send it, and the customer gets the email twice!

**Solution:**
We use a two-step "Claim" process with a status update, or a database lock.
```sql
-- Step 1: Claim it (atomic update)
UPDATE scheduled_emails 
SET status = 'processing' 
WHERE status = 'pending' AND scheduled_for <= NOW()

-- Step 2: Now that they are claimed safely, fetch only the processing ones
SELECT * FROM scheduled_emails WHERE status = 'processing'
```
*(Note: In Postgres, this is done elegantly with `SELECT ... FOR UPDATE SKIP LOCKED`)*
