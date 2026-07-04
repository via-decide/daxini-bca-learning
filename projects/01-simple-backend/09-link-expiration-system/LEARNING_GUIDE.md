# Link Expiration System: Learn By Building

**"Build a secure file/resource sharing API that automatically deletes access after a specific time limit or view count is reached."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Cron Jobs / Background Tasks** - Running cleanup scripts on a schedule to delete expired data.
✅ **Conditional Access Logic** - Enforcing rules (like view limits and time limits) *before* serving content.
✅ **TTL (Time To Live)** - Implementing automated expiration mechanisms.
✅ **Data Soft Deletion** - Marking records as inactive instead of permanently deleting them immediately.

---

## 📋 Project Overview

### The Problem
When you share sensitive data (like a password reset link, a temporary coupon code, or a confidential document link), you don't want that link to stay active forever on the internet. You need a system that destroys the link either after 24 hours or exactly after it has been clicked once.

### Who Uses It
```
Security Systems / Password Managers:
├─ Generate: "Share this secret note. It destroys itself after 1 reading."
└─ Action: First person to click sees the note. Second person sees a 404.
```

### The Big Picture

```text
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  User A      │ ──> │ Your API     │ ──> │ Database     │
│  (Creator)   │     │ (Generator)  │     │ (Store link) │
└──────────────┘     └──────┬───────┘     └──────────────┘
                            │
┌──────────────┐            │             ┌──────────────┐
│  User B      │ <──(Secret)│ <──(Valid)─ │ Background   │
│  (Reader)    │ ──(Link)───┘             │ Cleanup Cron │
└──────────────┘                          └──────────────┘
```

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data

**Question: How do we know if a link is expired?**
- We need to store the `expires_at` timestamp.
- We need to store the `max_views` (e.g., 1).
- We need to store the `current_views`.

### Step 2: Architecture Diagram

```text
1. Creator POSTs { secret_message: "Hello", max_views: 1, expires_in_hours: 24 }
2. API generates a random UUID: 8f2c-49a3... and saves to DB.
3. API returns the short link to Creator.
4. Reader GETs /api/read/8f2c-49a3...
5. API checks DB:
   a. Is current_time > expires_at? -> Return 410 Gone
   b. Is current_views >= max_views? -> Return 410 Gone
6. IF valid -> Increment current_views by 1, Return secret_message.
```

### Step 3: Background Cleanup (The Cron Job)
If millions of links expire, they stay in your database forever, wasting space. You need a separate script that runs every night at 2:00 AM, finds all links where `expires_at < now()`, and permanently deletes them.

---

## 🗄️ Database: Design, Don't Code

### Schema Design (SQL or NoSQL)

```text
Table: Secrets
- id: UUID (Primary Key, e.g., "8f2c-49a3...")
- message: TEXT
- current_views: INT (Default 0)
- max_views: INT
- expires_at: TIMESTAMP
- created_at: TIMESTAMP
```

### Design Questions

1. **Why use UUIDs instead of auto-incrementing IDs (1, 2, 3)?**
   If you use sequential IDs, someone can guess `ID=4` if they were given `ID=3`. UUIDs are mathematically impossible to guess, providing security through obscurity.

2. **Why do we need a Background Cron Job if the API checks `expires_at` anyway?**
   Because if a link is *never* clicked, the API check never happens. The database will fill up with dead data. The Cron Job is the garbage collector.

---

## 🔌 API Design: Plan Before Coding

### Endpoint 1: Create Secret
**POST `/api/secrets`**
- **Body**:
```json
{
  "message": "My bank password is 1234",
  "max_views": 1,
  "expires_in_hours": 1
}
```
- **Response**: `201 Created`
```json
{
  "id": "8f2c...",
  "url": "http://localhost:3000/api/secrets/8f2c..."
}
```

### Endpoint 2: Read Secret
**GET `/api/secrets/:id`**
- **Response (Valid)**: `200 OK`
```json
{ "message": "My bank password is 1234" }
```
- **Response (Expired/Invalid)**: `410 Gone`
```json
{ "error": "This secret has expired or reached its view limit." }
```

---

## 🧠 Implementation: Pseudocode First

```text
FUNCTION read_secret(request, response):
    secret_id = request.params.id
    
    // 1. Fetch from Database
    record = DB.find(secret_id)
    IF record is NULL:
        RETURN 404 "Not Found"
        
    // 2. Enforce Expiration Rules
    IF current_time() > record.expires_at:
        RETURN 410 "Gone"
        
    IF record.current_views >= record.max_views:
        RETURN 410 "Gone"
        
    // 3. Update view count (Critical: Do this BEFORE returning data)
    record.current_views = record.current_views + 1
    DB.save(record)
    
    // 4. Return Data
    RETURN 200 { message: record.message }
    
FUNCTION cleanup_cron_job():
    // Runs every day at midnight
    DB.execute("DELETE FROM Secrets WHERE expires_at < NOW()")
```

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Race Conditions
**What's wrong:** Two people click a 1-view link at the exact same millisecond. Both read `current_views (0) < max_views (1)`, both get the secret, and both update the view count. 
**Why it's bad:** A single-view security link was viewed twice.
**How to fix:** Use atomic database transactions or atomic increment commands (e.g., `UPDATE Secrets SET current_views = current_views + 1 WHERE current_views < max_views AND id = ?`).

### ❌ Mistake 2: Returning the Secret on Error
**What's wrong:** Returning `{"error": "Expired", "message": "My bank..."}`.
**Why it's bad:** You just leaked the secret even though it expired.
**How to fix:** Ensure the message payload is completely omitted in error responses.

---

## 🧪 Testing: How to Verify

### Test 1: Single View Limit
- Create a secret with `max_views: 1`.
- Access the link. You should see the message.
- Refresh the page. You should get a `410 Gone` error.

### Test 2: Time Expiration Limit
- Create a secret with `expires_in_hours: -1` (set to expire 1 hour ago for testing).
- Access the link. It should immediately return `410 Gone` even if `current_views` is 0.

---

## 🛠️ Debugging: When Things Break

### Problem: Links expire instantly upon creation.
**Root Cause:** Timezone mismatches. Your server is creating the `expires_at` timestamp in UTC, but evaluating it against the server's local time, making it instantly appear expired.
**Solution:** Always use standardized UTC timestamps for all database entries and time comparisons.

---

## 📚 Resources

- **Background Jobs**: Research `node-cron` (Node.js), `celery` (Python), or standard Linux `crontab`.
- **Database Transactions**: Look up "Atomic Increments" and "Race Conditions".

---

## ✅ Before Submission

- [ ] Does a 1-view link permanently lock after the first view?
- [ ] Is the secret message completely hidden in error responses?
- [ ] Did you implement a script/cron that deletes old rows from the database?
- [ ] Are you using non-guessable UUIDs instead of sequential IDs?

---

**Build this and learn: Expiration logic, atomic database updates, and background cleanup tasks.**
