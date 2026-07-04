# Notes API: Learn By Building

**"Build a markdown-ready notes API that focuses on full-text search and tagging systems."**

---


## 🧪 Testing: How to Verify

### Test 1: The Transaction Rollback
- Modify your code temporarily to throw an error right after the `notes` table insert, but before the `tags` are saved.
- Make a POST request.
- Check the database. The note should NOT be in the `notes` table because the transaction rolled back.

### Test 2: Full-Text Search Accuracy
- Create a note with the word "PostgreSQL".
- Search for "postgres".
- If you implemented proper full-text search (using Postgres `tsvector` or MySQL `FULLTEXT`), it should find the note using stemming. If you just used `LIKE`, it will fail.

---


## 🛠️ Debugging: When Things Break

### Problem: SQL duplicate key error when adding tags
**Root Cause:** Two notes try to create the tag "urgent" at the exact same time, causing a race condition on the unique `name` constraint in the `tags` table.
**Solution:** Use "Upsert" logic. In Postgres, this is `ON CONFLICT DO NOTHING`. In MySQL, it's `INSERT IGNORE`.

---
