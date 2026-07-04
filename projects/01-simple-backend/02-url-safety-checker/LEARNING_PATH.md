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


## ✅ Before Submission

- [ ] Does the app validate URL formatting?
- [ ] Is the external API key hidden in a `.env` file?
- [ ] Does caching work correctly?
- [ ] Can it detect homograph attacks (e.g., using a Cyrillic 'a' in apple.com)?

---

**Build this and learn: Secure API consumption, intelligent caching, and defensive programming.**
