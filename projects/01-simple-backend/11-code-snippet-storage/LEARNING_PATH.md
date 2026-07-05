# 💻 Code Snippet Storage API: Learn By Building

**"Build a pastebin-like API where developers can upload text (code snippets), optionally set them to self-destruct after viewing, and retrieve them with a unique ID."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **URL Security** - Why Auto-Incrementing IDs are dangerous for public links, and how to use cryptographically secure random IDs (`nanoid`).  
✅ **Rate Limiting** - Protecting your server from spam and DDoS attacks using middleware.  
✅ **Race Conditions** - Understanding concurrency issues in databases (The "Burn After Reading" problem).  
✅ **Payload Limits** - Securing your server against memory-exhaustion attacks by limiting JSON body sizes.

---

## 📋 Project Overview

### The Problem

Developers often need to share code, logs, or error messages with colleagues. Copying 500 lines of code into Slack is messy. Pastebins solve this by giving you a short URL. However, sometimes that code contains secrets (API keys, passwords). You need a way to share it so that only the FIRST person who clicks the link can see it, and it is permanently wiped from the internet immediately after.

**Your job:** Build a secure, rate-limited, self-destructing text API.

### Who Uses It

```
Developer A:
├─ POSTs sensitive code with "burn_after_reading" = true
└─ Gets link: /api/snippets/xY12z

Developer B:
├─ Clicks link
└─ Sees code. Code is instantly deleted from DB.

Hacker C:
├─ Finds the link in a chat log 5 minutes later
└─ Clicks link -> Gets 404 Not Found.
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. The Rate Limiter & Body Parser

```javascript
// 1. Limit the body size so nobody can upload a 5GB text file
app.use(express.json({ limit: '100kb' }));

// 2. Add Rate Limiting
const rateLimiter = createRateLimiter({
  window: 1 minute,
  max_requests: 10
});
```

### 2. Creating a Snippet

```pseudocode
POST /api/snippets (middleware: rateLimiter):
  Step 1: Validate
    content = request.body.content
    if !content: return 400 "Content required"
    
  Step 2: Generate Secure ID
    // Generate an 8-character random string (e.g., aBcD12xY)
    short_id = generateNanoid(8)
    
  Step 3: Insert to DB
    database.insert("snippets", {
      id: short_id,
      content: content,
      language: request.body.language || "plaintext",
      is_burn: request.body.is_burn_after_reading || false
    })
    
  Step 4: Return URL
    return 201 { url: `http://localhost:3000/api/snippets/${short_id}` }
```

### 3. Fetching and Burning

```pseudocode
GET /api/snippets/:id:
  Step 1: Start Database Transaction
    // Transactions lock the row so two requests can't read it at the exact same time
    db.beginTransaction()
    
  Step 2: Fetch
    snippet = db.query("SELECT * FROM snippets WHERE id = ?", id)
    
    if !snippet: 
      db.commit()
      return 404 "Not found"
      
  Step 3: Burn Logic
    if snippet.is_burn:
      db.query("DELETE FROM snippets WHERE id = ?", id)
      
  Step 4: End Transaction
    db.commit()
    
  Step 5: Return Content
    return 200 snippet
```

---

## ✅ Before Submission

- [ ] Users can upload text and receive a unique short ID (not an integer!).
- [ ] Users can fetch the text using the ID.
- [ ] If `is_burn_after_reading` is true, the snippet is deleted from the database immediately upon the first fetch.
- [ ] The API uses `express-rate-limit` (or similar) to prevent spam.
- [ ] The API rejects payloads larger than 100KB.
- [ ] Code is on GitHub.

**Success:** You have built a secure, anonymous sharing tool!
