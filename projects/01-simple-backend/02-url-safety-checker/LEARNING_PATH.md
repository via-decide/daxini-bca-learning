# 🛡️ URL Safety Checker: Learn By Building

**"Build a security service that scans URLs against a database of known malicious domains to protect users from phishing and malware."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Data Normalization** - Preparing messy user input (URLs) into a consistent format (normalized domains) for reliable database storage and matching.  
✅ **URL Parsing** - Using native language features (like the `URL` class in Node/JS) instead of writing brittle regex.  
✅ **Database Indexing** - Why strict string matching with `UNIQUE INDEX` is infinitely better than `LIKE` queries for security tools.  
✅ **Fire-and-Forget Analytics** - Logging API usage without slowing down the core response time.  
✅ **Role-Based Access** - Creating a service where admins have write access, but public users only have read access.  
✅ **External API Integration (Optional)** - Making an outbound HTTP request to a third-party service (Google Safe Browsing) to augment your own local data.

---

## 📋 Project Overview

### The Problem

Phishing links are sent via SMS, email, and social media constantly. Security tools (like Discord's link warning or Chrome's red warning page) need a way to instantly check if a link is dangerous before the user clicks it.

**Your job:** Build the backend scanning engine that powers these security warnings.

### Who Uses It

```
The Cybersecurity Admin:
├─ Adds domains to the blocklist
├─ Removes False Positives
└─ Views analytics on what people are scanning

The Public (Or a browser extension):
├─ Submits a full URL string
└─ Gets an instant YES/NO safe response
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. Normalize the Domain (The Helper Function)

```javascript
function extractNormalizedDomain(rawUrl) {
  // If the user forgot http://, add it so the URL parser works
  let urlString = rawUrl;
  if (!urlString.startsWith('http://') && !urlString.startsWith('https://')) {
    urlString = 'http://' + urlString;
  }
  
  try {
    const parsed = new URL(urlString);
    let hostname = parsed.hostname.toLowerCase();
    
    // Strip "www." if it exists
    if (hostname.startsWith('www.')) {
      hostname = hostname.substring(4);
    }
    
    return hostname;
  } catch (error) {
    throw new Error("Invalid URL provided");
  }
}
```

### 2. The Core Scan Endpoint

```pseudocode
POST /api/scan(url):
  Step 1: Extract and Normalize
    try:
      domain = extractNormalizedDomain(url)
    catch error:
      return 400 "Invalid URL format"
      
  Step 2: Database Lookup (O(1) Indexed)
    threat = database.query("SELECT * FROM blocked_domains WHERE domain = ?", domain)
    
    is_safe = (threat == null)
    
  Step 3: Respond Instantly
    response_payload = {
      url: url,
      domain: domain,
      is_safe: is_safe,
      threat_details: threat ? { type: threat.threat_type } : null
    }
    HTTP_Response(200, response_payload)
    
  Step 4: Background Logging (Fire and Forget)
    database.insert("scan_logs", {
      submitted_url: url,
      extracted_domain: domain,
      is_safe: is_safe,
      matched_threat_type: threat ? threat.threat_type : null,
      ip_address: request.ip
    })
```

### 3. Add to Blocklist (Admin Only)

```pseudocode
POST /api/admin/domains(domain, threat_type, notes):
  Step 1: Authenticate
    Verify JWT -> Get user_id
    
  Step 2: Normalize Input
    // Even admins make mistakes, normalize their input too!
    clean_domain = extractNormalizedDomain(domain)
    
  Step 3: Save to Database
    try:
      database.insert("blocked_domains", {
        domain: clean_domain,
        threat_type,
        notes,
        added_by: user_id
      })
    catch constraint_error:
      return 409 "Domain already blocked"
      
  Step 4: Return Success
    return 201 "Added to blocklist"
```

---

## ✅ Before Submission

- [ ] API accepts a full URL and returns a safety boolean.
- [ ] Backend correctly parses URLs and ignores paths (e.g., `/login`).
- [ ] Backend normalizes domains by making them lowercase and stripping `www.`.
- [ ] Attempting to add a duplicate domain to the blocklist fails gracefully (409 Conflict).
- [ ] Analytics logs are saved to the database without slowing down the scan response.
- [ ] Admin endpoints are protected by JWT authentication.
- [ ] Code is on GitHub.

**Success:** A blazing-fast security microservice capable of processing thousands of link checks per second.
