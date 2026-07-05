Here is the rewritten content for 02 Url Safety Checker:

# URL Safety Checker: Learn By Building

**"Build a security tool that scans URLs for phishing, malware, and malicious redirects."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. User submits URL for scanning
2. System checks if URL is already scanned in last 24 hours
3. System queries Google Safe Browsing API
4. System saves result to cache with a 24-hour expiration

**What data do you need for each?**

After thinking, here's the data model:

```
urls (for scanning)
├─ id
├─ url_string (unique)
├─ submitted_at
└─ scanned_at

caches (recent scan results)
├─ id
├─ url_id (links to urls)
├─ result (safe/malware/phishing)
├─ expiration_date
└─ created_at

blacklists (custom blocked domains)
├─ id
├─ domain_name (unique)
└─ reason_for_block

results (scan results with metadata)
├─ id
├─ url_id (links to urls)
├─ result (safe/malware/phishing)
├─ timestamp
└─ notes
```

---

### Step 2: Architecture Diagram

```
          +---------------+
          |  Client      |
          +---------------+
                  |
                  | POST URL
                  v
          +---------------+
          |  API Server   |
          +---------------+
                  |
                  | Validate URL format (Regex)
                  | Check Local Blacklist Database
                  | Check Cache (Was this scanned in last 24h?)
                  | If miss -> Call External API (Google Safe Browsing)
                  | Save result to Cache
                  | Return Safety Report to Client
          +---------------+
```

---

### Step 3: Data Flow

1. User enters `http://free-iphone-giveaway.tk`
2. Backend validates it's a real URL structure.
3. Backend checks `scans_cache` table. Not found.
4. Backend sends URL to Google API.
5. Google replies: `{"threatType": "MALWARE"}`.
6. Backend saves result to cache with a 24-hour expiration.
7. User sees a big red "UNSAFE" warning.

---

I hope this rewritten content meets your requirements!