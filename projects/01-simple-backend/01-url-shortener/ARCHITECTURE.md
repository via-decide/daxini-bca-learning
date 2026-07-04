# 🔗 URL Shortener: Learn By Building

**"Build a system that makes long URLs short. Understand every part."**

---


## 🏗️ Architecture: Design Before Coding

### Step 1: Think About Data

**Question 1: What information must you store?**

Think about this before reading below:
- What makes a short URL unique?
- Do you need to know who created it?
- Do you need to count clicks?
- Should URLs expire?

**After thinking, here's what you need:**

| Data | Why? |
|------|------|
| shortCode | The unique identifier (abc123) |
| longUrl | Where to redirect |
| clicks | Analytics: how popular? |
| createdAt | When was this created? |
| expiresAt | (Optional) When should it die? |

### Step 2: Architecture Diagram

Draw this yourself first, then compare:

```
┌────────────────────────────────────────────┐
│            Frontend (Browser)              │
│  ┌──────────────────────────────────────┐  │
│  │   Form: Enter Long URL               │  │
│  │   Button: Shorten                    │  │
│  │   Display: Short URL + Copy          │  │
│  │   Stats: View analytics              │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
                    │
         HTTP POST /api/shorten
         HTTP GET /:shortCode
                    │
                    ▼
┌────────────────────────────────────────────┐
│          Backend (Node.js Server)          │
│  ┌──────────────────────────────────────┐  │
│  │ POST /api/shorten                    │  │
│  │   → Validate URL                     │  │
│  │   → Generate short code              │  │
│  │   → Save to database                 │  │
│  │   → Return short URL                 │  │
│  └──────────────────────────────────────┘  │
│  ┌──────────────────────────────────────┐  │
│  │ GET /:shortCode                      │  │
│  │   → Lookup in database               │  │
│  │   → Increment clicks                 │  │
│  │   → Redirect (HTTP 302)              │  │
│  └──────────────────────────────────────┘  │
│  ┌──────────────────────────────────────┐  │
│  │ GET /api/stats/:shortCode            │  │
│  │   → Return analytics                 │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
                    │
                    ▼
┌────────────────────────────────────────────┐
│           Database (SQLite)                │
│  ┌──────────────────────────────────────┐  │
│  │  urls table:                         │  │
│  │  - id (primary key)                  │  │
│  │  - shortCode (unique)                │  │
│  │  - longUrl (text)                    │  │
│  │  - clicks (count)                    │  │
│  │  - createdAt (timestamp)             │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
```

### Step 3: Data Flow

Trace what happens when user enters a URL:

```
User Input: "https://wikipedia.org/wiki/AI"
     │
     ▼
Frontend validates (is it a URL?)
     │
     ▼ YES
Submit to server
     │
     ▼
Server receives request
     │
     ▼
Server validates (is it really a URL?)
     │
     ▼ YES
Generate unique short code (how?)
     │
     ▼
Check if code already exists (UNIQUE constraint)
     │
     ▼ NO
Insert into database
     │
     ▼
Return short URL to frontend
     │
     ▼
Display to user + copy button
```

**Questions to answer:**
- What happens if validation fails?
- What if code already exists?
- What if database is down?

---
