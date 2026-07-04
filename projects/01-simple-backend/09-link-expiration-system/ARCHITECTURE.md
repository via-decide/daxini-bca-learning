# Link Expiration System: Learn By Building

**"Build a secure file/resource sharing API that automatically deletes access after a specific time limit or view count is reached."**

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
