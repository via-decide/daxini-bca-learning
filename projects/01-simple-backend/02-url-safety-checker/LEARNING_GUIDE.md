# URL Safety Checker: Learn By Building

**"Build a security tool that scans URLs for phishing, malware, and malicious redirects."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **External API Integration** - How to securely call third-party APIs (like Google Safe Browsing)
✅ **Caching Strategies** - How to avoid rate limits by caching frequent requests
✅ **Regex & Data Validation** - How to ensure inputs are actually valid URLs
✅ **Web Scraping Basics** - How to fetch meta-tags to preview a link before clicking
✅ **Security Mindset** - Understanding homograph attacks and common phishing techniques

---

## 📋 Project Overview

### The Problem
People click suspicious links in emails and SMS messages every day. Attackers use URL shorteners, redirects, and typosquatting (like `g00gle.com`) to hide malicious destinations. Users need a safe way to "unfurl" and scan a link before they actually visit it.

### Who Uses It
```
End User:
├─ Receives a suspicious SMS link
├─ Pastes it into your web app
└─ Sees a report: "Warning: Known Phishing Site"

System Admin:
├─ Maintains the local blacklist of known bad domains
└─ Monitors the rate limits of external scanning APIs
```

### The Big Picture

```text
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  User Input  │ ──> │ Backend API  │ ──> │ Local Cache  │
│ (Suspicious  │     │ (Controller) │     │ (Redis/DB)   │
│  Link)       │     └──────┬───────┘     └──────────────┘
└──────────────┘            │
                            │ (If not cached)
                            V
                     ┌──────────────┐
                     │ Google Safe  │
                     │ Browsing API │
                     └──────────────┘
```

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data

**Question: What information must the system store?**
- Do we need to query Google for the exact same URL if 1,000 people check it today?
- How do we store a list of custom blocked domains?
- Should we track who submitted what?

**After thinking, here's the data model:**
- We need a caching table for recent URL scans to save API quota.
- We need a custom blacklist table for domains we explicitly block.
- We don't need complex user accounts for a basic utility app.

### Step 2: Architecture Diagram

```text
1. Client POSTs URL -> API Server
2. Server validates URL format (Regex)
3. Server checks Local Blacklist Database
4. Server checks Cache (Was this scanned in last 24h?)
5. If miss -> Server calls External API (Google Safe Browsing)
6. Server saves result to Cache
7. Server returns Safety Report to Client
```

### Step 3: Data Flow
1. User enters `http://free-iphone-giveaway.tk`
2. Backend validates it's a real URL structure.
3. Backend checks `scans_cache` table. Not found.
4. Backend sends URL to Google API.
5. Google replies: `{"threatType": "MALWARE"}`.
6. Backend saves result to cache with a 24-hour expiration.
7. User sees a big red "UNSAFE" warning.

---

## 🗄️ Database: Design, Don't Code

### Schema Design (Think Before SQL)

```sql
-- Scans Cache
CREATE TABLE scans_cache (
  id INTEGER PRIMARY KEY,
  url_hash TEXT UNIQUE, -- Hashed URL for fast indexing
  original_url TEXT,
  is_safe BOOLEAN,
  threat_type TEXT,
  scanned_at DATETIME,
  expires_at DATETIME
);

-- Custom Blacklist
CREATE TABLE custom_blacklist (
  id INTEGER PRIMARY KEY,
  domain TEXT UNIQUE,
  reason TEXT,
  added_at DATETIME
);
```

### Design Questions

1. **Why store a `url_hash` instead of indexing the `original_url` directly?**
   URLs can be incredibly long (up to 2048 characters). Indexing a standard SHA-256 hash (64 chars) makes database lookups much faster and more efficient.

2. **Why do we need an `expires_at` column?**
   A safe site today might get hacked and become a malicious site tomorrow. You shouldn't cache a "Safe" result forever.

---

## 🔌 API Design: Plan Before Coding

### Endpoint 1: Scan URL

**POST `/api/scan`**
- **Purpose**: Submit a URL for safety analysis.
- **Request**: `{ "url": "https://example.com" }`
- **Response (Safe)**: `{ "safe": true, "cached": true, "threats": [] }`
- **Response (Unsafe)**: `{ "safe": false, "cached": false, "threats": ["MALWARE", "SOCIAL_ENGINEERING"] }`

### Endpoint 2: Add to Blacklist (Admin)

**POST `/api/admin/blacklist`**
- **Purpose**: Manually add a domain to the local blocklist.
- **Request**: `{ "domain": "badguy.com", "reason": "Phishing" }`
- **Response**: `201 Created`

---

## 🧠 Implementation: Pseudocode First

```text
FUNCTION check_url_safety(target_url):
    // 1. Basic Validation
    IF NOT is_valid_url_format(target_url):
        RETURN ERROR "Invalid URL format"
        
    // 2. Extract Domain & Check Local Blacklist
    domain = extract_domain(target_url)
    IF Database.exists("custom_blacklist", domain):
        RETURN { safe: false, reason: "Local Blacklist" }
        
    // 3. Check Cache
    url_hash = sha256(target_url)
    cache_record = Database.query("scans_cache WHERE url_hash = ?", url_hash)
    
    IF cache_record AND cache_record.expires_at > NOW():
        RETURN cache_record.result
        
    // 4. External API Call
    api_response = GoogleSafeBrowsing.lookup(target_url)
    
    // 5. Parse and Cache Result
    is_safe = (api_response.threats.length == 0)
    
    Database.insert("scans_cache", {
        url_hash: url_hash,
        original_url: target_url,
        is_safe: is_safe,
        threat_type: api_response.threats,
        scanned_at: NOW(),
        expires_at: NOW() + 24_HOURS
    })
    
    RETURN { safe: is_safe, threats: api_response.threats }
```

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Not Validating the URL First
**What's wrong:** Passing user input directly to the external API without checking if it's a real URL.
**Why it's bad:** Attackers can send malformed strings or SQL injection payloads. The external API will throw errors, or worse, your app crashes.
**How to fix:** Always run the input through a strict URL parser (like Node's `new URL(input)`) before doing anything else.

### ❌ Mistake 2: Missing Timeout Handling
**What's wrong:** Waiting indefinitely for the Google API to respond.
**Why it's bad:** If the external API goes down, your server keeps connections open waiting for a response until it runs out of memory and crashes.
**How to fix:** Set a strict timeout (e.g., 3000ms) on external HTTP requests.

---

## 🧪 Testing: How to Verify

### Test 1: Known Bad URLs
- Find a test malware URL (Google provides safe testing URLs for this purpose).
- Submit it to your API.
- Verify it returns `safe: false`.

### Test 2: Cache Hit Verification
- Submit a safe URL (`https://github.com`).
- Turn off your internet connection.
- Submit the same URL again.
- It should succeed immediately because it pulled from the local database cache.

---

## 🛠️ Debugging: When Things Break

### Problem: API returns "Rate Limit Exceeded" (429)
**Root Causes:**
1. You aren't caching results, so you're hitting the external API for every request.
2. A single user is spamming your endpoint.
**Solution:** Check your database cache logic. Implement IP-based rate limiting on your own `/api/scan` endpoint.

---

## 📚 Resources

- **API Documentation**: Google Safe Browsing API
- **URL Parsing**: MDN Web Docs - URL API
- **Regex**: Regex101 (for validating custom URL patterns)

---

## ✅ Before Submission

- [ ] Does the app validate URL formatting?
- [ ] Is the external API key hidden in a `.env` file?
- [ ] Does caching work correctly?
- [ ] Can it detect homograph attacks (e.g., using a Cyrillic 'a' in apple.com)?

---

**Build this and learn: Secure API consumption, intelligent caching, and defensive programming.**
