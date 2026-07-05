# 💻 Code Snippet Storage API: Learn By Building

**"Build a pastebin-like API where developers can upload text (code snippets), optionally set them to self-destruct after viewing, and retrieve them with a unique ID."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. User uploads a Python script.
2. The server gives them a short ID: `aBcD12`.
3. The user shares the link `your-api.com/snippet/aBcD12`.
4. Someone clicks it, the server reads the Python script from the DB and returns it.
5. (Advanced) The user checked a box: "Burn after reading". When the friend clicks the link, the server returns the code, and immediately DELETES the code from the database.

**What data do you need for each?**

After thinking, here's the data model:

```
Snippets (The Core Entity)
├─ id (String - A short, random unique ID like 'aBcD12')
├─ content (TEXT - The actual code)
├─ language (String - e.g. "python", "javascript", used for syntax highlighting)
├─ is_burn_after_reading (Boolean)
└─ created_at (Timestamp)
```

*(Note: We don't necessarily need a Users table. Pastebin allows anonymous uploads).*

---

### Step 2: The "Burn After Reading" Problem

**Question: How do you guarantee a snippet is read exactly once?**

**Bad Idea:**
```javascript
app.get('/api/snippets/:id', async (req, res) => {
  const snippet = await db.query("SELECT * FROM snippets WHERE id = ?", id);
  res.json(snippet);
  
  if (snippet.is_burn_after_reading) {
    // We try to delete it after sending the response
    await db.query("DELETE FROM snippets WHERE id = ?", id);
  }
});
```
*Why it's bad:* If two people click the link at the *exact same millisecond*, the `SELECT` query runs twice before the `DELETE` query has a chance to execute. Both people see the private message. This is called a **Race Condition**.

**Good Idea (Atomic Operations):**
Use a database transaction or a single atomic query to delete and return the data simultaneously, ensuring it only happens once. (Or delete it first, and if successful, return the data).

```javascript
// A safer approach: Delete first, checking how many rows were affected
const result = await db.query("DELETE FROM snippets WHERE id = ? RETURNING *", id);

if (result.deletedCount === 0) {
  return res.status(404).json({ error: "Snippet not found or already burned" });
}

res.json(result.deletedData);
```

---

### Step 3: Security & Abuse Prevention

A public pastebin is a magnet for abuse. People will try to upload massive files or use your database to store illegal content.

**Defenses:**
1. **Size Limits:** The API MUST reject `content` that is larger than 100KB.
2. **Rate Limiting:** A single IP address should not be able to create more than 10 snippets per minute.

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ <textarea> for code                  │  │
│  │ Checkbox: "Burn after reading"       │  │
│  │ Syntax Highlighting Display          │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP POST /api/snippets
        HTTP GET /api/snippets/:id
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. Rate Limiter Middleware           │  │
│  │ 2. Generate Random Short ID (nanoid) │  │
│  │ 3. Save Code to DB                   │  │
│  │ 4. Read Logic (Handle Burn requests) │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (SQLite/PostgreSQL)        │
│  - Persistent storage for code             │
└────────────────────────────────────────────┘
```
