# Time Tracking System (Toggl Clone)

## 🏗️ Architecture: Design Before Coding

**The Problem:**
Freelancers need to track exactly how many minutes they spend on a project to bill clients. They click "Start" when they begin, and "Stop" when they finish.

**The Solution:**
Store Time Entries as precise UTC timestamps. Calculate the duration dynamically. Handle edge cases like "user forgot to click stop and left it running for 4 days".

**Database Architecture:**
```text
Projects
├─ id
├─ name
└─ hourly_rate

Time_Entries
├─ id
├─ user_id
├─ project_id
├─ start_time (TIMESTAMP UTC)
├─ end_time (TIMESTAMP UTC, Nullable)
└─ description
```
