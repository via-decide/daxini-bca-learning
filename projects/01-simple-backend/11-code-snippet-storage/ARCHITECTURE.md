# Code Snippet Storage API: Learn By Building

**"Build a Pastebin-clone backend that allows developers to quickly save, format, and retrieve code snippets with syntax metadata."**

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
