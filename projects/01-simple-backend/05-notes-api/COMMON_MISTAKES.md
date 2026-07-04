# Notes API: Learn By Building

**"Build a markdown-ready notes API that focuses on full-text search and tagging systems."**

---


## ⚠️ Common Mistakes

### ❌ Mistake 1: N+1 Query Problem
**What's wrong:** Fetching 10 notes, and then running a loop that queries the database 10 separate times to get the tags for each note.
**Why it's bad:** It crushes database performance. Instead of 1 query, you are running 11 queries.
**How to fix:** Use a `SQL JOIN` to fetch the notes and tags in a single query, or use an ORM feature designed to eager-load relationships.

### ❌ Mistake 2: Missing Database Transactions
**What's wrong:** Creating a note, then the server crashes before it creates the tags.
**Why it's bad:** You have orphaned data in your database. A note exists but the tags that the user specified were lost.
**How to fix:** Wrap multi-step database writes in a Transaction (`BEGIN` ... `COMMIT`). If anything fails, it rolls back automatically.

---
