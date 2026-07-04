# Online Voting System

## 🏗️ Architecture: Design Before Coding

**The Problem:**
During a live poll, millions of users might vote in the same 5-minute window. You must prevent double-voting, and ensure the vote tally doesn't drop votes due to database race conditions.

**The Solution:**
Strict unique constraints on `(poll_id, user_id)`. Absolutely NO `SELECT count` -> `count + 1` -> `UPDATE count` logic in the application code.

**Database Architecture:**
```text
Polls
├─ id
└─ title

Poll_Options
├─ id
├─ poll_id
├─ option_text
└─ vote_count (INT)

User_Votes
├─ poll_id
├─ user_id
└─ option_id
```
