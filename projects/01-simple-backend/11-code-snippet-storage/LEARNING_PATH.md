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


## ✅ Before Submission

- [ ] Does the API preserve exact formatting (newlines, tabs, quotes) in the code?
- [ ] Is there a strict limit on the length of code you can upload?
- [ ] Does the "Recent" endpoint properly limit the number of results returned?
- [ ] Are you using parameterized database queries to prevent SQL injection?

---

**Build this and learn: Handling large text payloads, pagination, and protecting against injection attacks.**
