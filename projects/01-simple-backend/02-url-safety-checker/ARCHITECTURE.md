# URL Safety Checker: Learn By Building

**"Build a security tool that scans URLs for phishing, malware, and malicious redirects."**

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
