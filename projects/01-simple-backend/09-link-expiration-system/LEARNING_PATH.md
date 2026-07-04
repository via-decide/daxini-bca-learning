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


## ✅ Before Submission

- [ ] Does a 1-view link permanently lock after the first view?
- [ ] Is the secret message completely hidden in error responses?
- [ ] Did you implement a script/cron that deletes old rows from the database?
- [ ] Are you using non-guessable UUIDs instead of sequential IDs?

---

**Build this and learn: Expiration logic, atomic database updates, and background cleanup tasks.**
