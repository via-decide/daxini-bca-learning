# 🔗 URL Shortener: Learn By Building

**"Build a system that takes long, ugly URLs and turns them into short, shareable links, tracking how many times they are clicked."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. A user pastes `https://www.verylongdomain.com/article/12345?ref=twitter`
2. The system gives them back `https://short.ly/aB3x9`
3. Someone clicks `https://short.ly/aB3x9`
4. The system looks up `aB3x9` and redirects them to the original URL.
5. The system records that the link was clicked.
6. The creator checks their dashboard to see how many clicks they got.

**What data do you need for each?**

After thinking, here's the data model:

```
Users (for login/dashboard)
├─ id (UUID)
├─ email (unique)
├─ password_hash
└─ created_at

Urls (the core mapping)
├─ id (UUID)
├─ user_id (links to Users, nullable for anonymous creation)
├─ original_url (the long one)
├─ short_code (the short identifier: "aB3x9")
├─ clicks (integer, total count)
└─ created_at

Click_Analytics (detailed tracking)
├─ id
├─ url_id (links to Urls)
├─ ip_address (optional/hashed)
├─ user_agent (Browser/OS details)
├─ referrer (Where they clicked from)
└─ clicked_at (timestamp)
```

---

### Step 2: The Collision Problem (How to generate the short code)

**Question: How do you guarantee the short code is unique?**

**Option A (Random Generation):**
```javascript
function generateCode() {
  return Math.random().toString(36).substring(2, 8); // e.g., 'x7b21q'
}
// Try to insert into DB. If it fails (unique constraint), generate again.
```
- Pros: Easy to write.
- Cons: As the database gets full, collisions happen constantly. You waste database queries retrying.

**Option B (Base62 Encoding an Auto-Incrementing ID):**
```text
Database row ID: 10000 -> Base62 Encode -> '2Bi'
Database row ID: 10001 -> Base62 Encode -> '2Bj'
```
- Pros: Guaranteed unique. Mathematically impossible to collide. Fastest.
- Cons: URLs are predictable. A competitor can easily guess links or know exactly how many URLs you've shortened.

**Option C (Nanoid / UUID + Hashing):**
```javascript
const { nanoid } = require('nanoid');
const shortCode = nanoid(7); // Generates URL-safe, secure string e.g., 'V1StGXR8_Z5jdHi6B-myT'
```
- Pros: Non-predictable, highly collision-resistant at 7+ characters.
- Cons: Very slight chance of collision requires handling.

**Decision:** We use a short (6-7 char) Nanoid string with a Unique Index on the database. If a collision happens, we retry once.

---

### Step 3: Database Architecture

```
┌──────────────────────────────────────────┐
│              Database                    │
├──────────────────────────────────────────┤
│                                          │
│  users ─────────┐                        │
│                 │                        │
│                 ├──► urls ──────────┐    │
│                 │       │           │    │
│                 │       ▼           ▼    │
│                 │ click_analytics ◄─┘    │
│                                          │
└──────────────────────────────────────────┘

Relationships:
- users.id → urls.user_id (one user, many URLs)
- urls.id → click_analytics.url_id (one URL, many click events)
```

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML)             │
│  ┌──────────────────────────────────────┐  │
│  │ Homepage (Paste URL bar)             │  │
│  │ User Dashboard (List of URLs)        │  │
│  │ Analytics View (Charts/Graphs)       │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP Requests
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ API Layer                            │  │
│  │  - POST /api/shorten                 │  │
│  │  - GET /api/urls (Dashboard)         │  │
│  ├──────────────────────────────────────┤  │
│  │ Redirect Layer (The crucial part!)   │  │
│  │  - GET /:shortCode                   │  │
│  │  - Look up DB, send 301/302 Redirect │  │
│  │  - Fire & Forget Analytics insert    │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        SQL Queries
              │
              ▼
┌────────────────────────────────────────────┐
│        Database (SQLite/PostgreSQL)        │
│  - Persistent data storage                 │
│  - UNIQUE constraint on short_code         │
│  - Indexes for fast lookups                │
└────────────────────────────────────────────┘
```

---

### Step 5: The "Fast Redirect" Requirement

When someone clicks a short link, they expect to land on the destination immediately. 
If your backend does this:
1. Wait to fetch URL from DB (100ms)
2. Wait to insert into `click_analytics` DB (100ms)
3. Wait to update `urls.clicks + 1` DB (100ms)
4. Send Redirect

**The user waits 300ms!** That's too slow.

**Solution: Asynchronous Analytics:**
1. Wait to fetch URL from DB (100ms)
2. Send Redirect to user IMMEDIATELY.
3. In the background (without `await`), insert into analytics and update clicks.
