# Code Snippet Storage API: Learn By Building

**"Build a Pastebin-clone backend that allows developers to quickly save, format, and retrieve code snippets with syntax metadata."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Text Blobs & Encodings** - Handling large, multi-line text payloads safely.
✅ **Metadata Tagging** - Storing and retrieving categorizations (like programming language type) alongside text.
✅ **Pagination** - Fetching a limited list of recent snippets instead of the entire database.
✅ **Basic Rate Limiting** - Preventing automated spam from flooding your database with junk text.
✅ **XSS Prevention (Concepts)** - Why you must never render user-provided code as raw HTML without sanitizing it.

---

## 📋 Project Overview

### The Problem
Developers frequently need to share logs, configurations, or short code blocks with team members. Slack sometimes formats code terribly. They need a simple tool where they can paste text, assign a language (like Python or JSON), and instantly get a shareable URL.

### Who Uses It
```
Developer (Frontend):
├─ Pastes: "def hello(): print('world')"
├─ Selects: Language = Python
└─ Receives: "https://api.yourapp.com/snippets/5a9c2"

Colleague (Frontend):
├─ Clicks link
└─ Receives the exact code, properly formatted, without broken whitespace.
```

### The Big Picture

```text
┌──────────────┐                 ┌──────────────┐
│  Developer   │ ──(POST code)─> │ Your Backend │
│  (Creator)   │                 │ (Storage API)│
└──────────────┘                 └──────┬───────┘
                                        │
┌──────────────┐                        V
│  Colleague   │ <──(GET code)── ┌──────────────┐
│  (Viewer)    │                 │ Database     │
└──────────────┘                 └──────────────┘
```

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data

**Question: What makes a code snippet different from a normal string?**
- It contains special characters (`<`, `>`, `\n`, `\t`, `"`).
- Whitespace is strictly meaningful (especially in Python or YAML).
- It can be very long (e.g., 500 lines of error logs).

### Step 2: Architecture Diagram

```text
1. Client POSTs /api/snippets { "language": "python", "code": "def foo():\n  pass" }
2. API validates the payload: Is code < 100KB? Is language in the allowed list?
3. API checks rate limit (Has this IP posted more than 10 times in 1 min?)
4. API generates a short alphanumeric ID (e.g., "aX9b2")
5. API saves to DB.
6. API returns the new URL.
```

### Step 3: Pagination
When a user asks for "Recent Snippets", your database might have 100,000 entries. Returning all of them crashes your server and the user's browser. You must implement pagination: returning small chunks (pages) of data (e.g., 10 at a time).

---

## 🗄️ Database: Design, Don't Code

### Schema Design (SQL or NoSQL)

```text
Table: Snippets
- id: VARCHAR (Primary Key, e.g., "aX9b2" - short ID)
- language: VARCHAR (e.g., "python", "json", "plain")
- code: TEXT (SQL) or String (NoSQL)
- created_at: TIMESTAMP
- ip_address: VARCHAR (For rate limiting/spam blocking - optional but recommended)
```

### Design Questions

1. **Why use a short ID (`aX9b2`) instead of a UUID (`8f2c-49a3...`)?**
   Pastebin links are meant to be short and easy to copy. A 5-character base62 string gives you ~916 million possible combinations. 
   *(Bonus task: Build a function that generates a 5-character random string).*

---

## 🔌 API Design: Plan Before Coding

### Endpoint 1: Create Snippet
**POST `/api/snippets`**
- **Body**:
```json
{
  "language": "javascript",
  "code": "console.log('Hello');\n  return true;"
}
```
- **Response**: `201 Created`
```json
{
  "id": "k8M2p",
  "url": "http://localhost:3000/api/snippets/k8M2p"
}
```

### Endpoint 2: Get Snippet
**GET `/api/snippets/:id`**
- **Response**: `200 OK`
```json
{
  "id": "k8M2p",
  "language": "javascript",
  "code": "console.log('Hello');\n  return true;",
  "created_at": "2024-10-24T12:00:00Z"
}
```

### Endpoint 3: List Recent Snippets
**GET `/api/snippets/recent?limit=5`**
- **Response**: Array of snippets (excluding the huge `code` payload to save bandwidth).

---

## 🧠 Implementation: Pseudocode First

```text
FUNCTION create_snippet(request, response):
    code = request.body.code
    language = request.body.language OR "plain"
    
    // 1. Validation
    IF code is empty:
        RETURN 400 "Code cannot be empty"
    IF length(code) > 100000: // 100KB max
        RETURN 400 "Payload too large"
        
    // 2. Generate Short ID
    snippet_id = generate_random_string(5)
    
    // 3. Save to DB
    DB.insert("Snippets", {
        id: snippet_id,
        language: lowercase(language),
        code: code,
        created_at: NOW()
    })
    
    RETURN 201 { id: snippet_id }

FUNCTION get_recent(request, response):
    limit_param = request.query.limit OR 10
    
    // Safety cap
    limit = min(integer(limit_param), 50) 
    
    // Fetch from DB (Exclude the actual 'code' column to keep response small)
    results = DB.query("SELECT id, language, created_at FROM Snippets ORDER BY created_at DESC LIMIT ?", limit)
    
    RETURN 200 results
```

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Not Validating Payload Size
**What's wrong:** Accepting a POST body without checking its size.
**Why it's bad:** A malicious user can send a 5GB text payload in a single request, crashing your application (OOM - Out of Memory) and filling your database instantly.
**How to fix:** Enforce a strict max length (e.g., 100KB) on the incoming string.

### ❌ Mistake 2: Stripping Whitespace
**What's wrong:** Calling `trim()` on every line of the code, or storing it in a way that removes tabs.
**Why it's bad:** Programming languages like Python rely strictly on indentation. If you remove tabs, the code breaks.
**How to fix:** Store the string exactly as received, preserving all `\n` and `\t` characters.

---

## 🧪 Testing: How to Verify

### Test 1: Whitespace Preservation
- Create a snippet with multiple tabs and newlines.
- Fetch the snippet back via GET.
- Ensure the tabs and newlines (`\n`) are completely unmodified.

### Test 2: Pagination / Limits
- Create 15 snippets.
- Request `/api/snippets/recent?limit=5`. Ensure it returns exactly 5 items.
- Request `/api/snippets/recent?limit=10000`. Ensure your API forcefully caps it (e.g., returns a maximum of 50) to prevent abuse.

---

## 🛠️ Debugging: When Things Break

### Problem: Code with quotes breaks the database insert.
**Root Cause:** You are manually constructing SQL strings like `INSERT INTO Snippets VALUES ('${code}')`. If the code contains `'`, it breaks the SQL syntax (and causes SQL Injection).
**Solution:** Always use **Parameterized Queries** (e.g., `execute("INSERT INTO Snippets (code) VALUES (?)", [code])`). The database driver will safely escape all characters automatically.

---

## 📚 Resources

- **Pagination**: "Offset vs Keyset pagination" (Research the difference).
- **SQL Injection**: OWASP SQL Injection Prevention Cheat Sheet.

---

## ✅ Before Submission

- [ ] Does the API preserve exact formatting (newlines, tabs, quotes) in the code?
- [ ] Is there a strict limit on the length of code you can upload?
- [ ] Does the "Recent" endpoint properly limit the number of results returned?
- [ ] Are you using parameterized database queries to prevent SQL injection?

---

**Build this and learn: Handling large text payloads, pagination, and protecting against injection attacks.**
