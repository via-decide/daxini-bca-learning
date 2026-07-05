# 🛡️ URL Safety Checker: Learn By Building

**"Build a security service that scans URLs against a database of known malicious domains to protect users from phishing and malware."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. A cybersecurity admin adds `malicious-phishing-site.com` to the blocklist.
2. An admin adds a reason: "Phishing attempt reported by users."
3. A user submits a URL to check: `https://malicious-phishing-site.com/login`.
4. The system needs to quickly match the domain against the blocklist.
5. The system records the safety check for analytics (e.g. tracking how many times a bad domain was queried).

**What data do you need for each?**

After thinking, here's the data model:

```
Users (Admins who manage the blocklist)
├─ id (UUID)
├─ email
├─ password_hash
└─ created_at

Blocked_Domains (The Core Threat Intelligence Database)
├─ id (UUID)
├─ domain (e.g. "malicious-site.com" — UNIQUE)
├─ threat_type (e.g. "phishing", "malware", "scam")
├─ added_by (links to Users)
├─ notes (why it was blocked)
└─ created_at

Scan_Logs (Analytics/Audit Trail)
├─ id
├─ submitted_url (The full URL checked)
├─ extracted_domain (The domain parsed from the URL)
├─ is_safe (boolean)
├─ matched_threat_type (nullable)
├─ ip_address (optional, who asked for the scan)
└─ scanned_at (timestamp)
```

---

### Step 2: The Parsing Dilemma (How to extract the domain)

**Question: If a user submits `https://www.badsite.com/login?user=123`, how do you match it against `badsite.com`?**

**Bad Idea (String Matching / LIKE queries):**
```sql
-- Checking if any blocked domain is inside the submitted URL string
SELECT * FROM blocked_domains WHERE 'https://www.badsite.com/login' LIKE '%' || domain || '%';
```
- Pros: Seems easy.
- Cons: VERY slow (cannot use indexes). Will cause false positives (e.g. `badsite.com` will match inside `notabadsite.com`).

**Good Idea (URL Parsing on Backend):**
```javascript
// Backend parses the incoming URL string safely
const parsed = new URL("https://www.badsite.com/login?user=123");
const hostname = parsed.hostname; // "www.badsite.com"

// Strip 'www.' if present to normalize
const cleanDomain = hostname.replace(/^www\./, ''); // "badsite.com"

// Now do an exact, lightning-fast database lookup
const isBlocked = db.query("SELECT * FROM blocked_domains WHERE domain = ?", cleanDomain);
```
- Pros: Accurate, predictable, and allows O(1) indexed database lookups.

**Decision:** The backend will strictly parse the URL using the native URL class, extract the normalized hostname, and perform an exact string match query.

---

### Step 3: Database Architecture

```
┌──────────────────────────────────────────┐
│              Database                    │
├──────────────────────────────────────────┤
│                                          │
│  users ─────────┐                        │
│                 │                        │
│                 ├──► blocked_domains     │
│                 │                        │
│                 │    scan_logs           │
│                                          │
└──────────────────────────────────────────┘

Relationships:
- users.id → blocked_domains.added_by (one admin, many blocked domains)
```

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML)             │
│  ┌──────────────────────────────────────┐  │
│  │ Public Scanner (Input box for URL)   │  │
│  │ Scan Result Page (Safe / Unsafe)     │  │
│  │ Admin Dashboard (Manage blocklist)   │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP Requests
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ Public API Layer                     │  │
│  │  - POST /api/scan (The safety check) │  │
│  ├──────────────────────────────────────┤  │
│  │ Admin API Layer (Requires Auth)      │  │
│  │  - CRUD for blocked domains          │  │
│  │  - View scan analytics               │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        SQL Queries
              │
              ▼
┌────────────────────────────────────────────┐
│        Database (SQLite/PostgreSQL)        │
│  - Persistent blocklist storage            │
│  - UNIQUE Index on domain                  │
└────────────────────────────────────────────┘
```

---

### Step 5: Advanced (Optional) - The Google Safe Browsing Integration

If you want to take this to the next level, checking your own small local database isn't enough to protect users.

You can modify the `/api/scan` endpoint to check **two** places:
1. Check your local `blocked_domains` database (Fast).
2. If it's safe locally, make an outbound HTTP request to the Google Safe Browsing API (or PhishTank API) to see if *they* know it's malicious.

*This teaches you how to aggregate data from 3rd party APIs.*