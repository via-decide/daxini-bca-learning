# 🛡️ URL Safety Checker: API Design

**"Build a security service that scans URLs against a database of known malicious domains to protect users from phishing and malware."**

---

## 🔗 API Endpoints

### Authentication (Admin)

```
POST   /api/auth/login        → Login for admins to manage blocklist
```

### Public Scanner

```
POST   /api/scan                      → Submit a URL for a safety check
```

### Threat Intelligence Management (Requires JWT, Admin Only)

```
GET    /api/admin/domains             → List all blocked domains (with pagination/search)
POST   /api/admin/domains             → Add a new domain to the blocklist
DELETE /api/admin/domains/:domain     → Remove a domain from the blocklist
GET    /api/admin/scan-logs           → View recent scanning activity
```

---

## 📦 Request/Response Examples

### 1. Perform a Safety Scan (Public)

**Request:**
```json
POST /api/scan
{
  "url": "https://www.free-iphone-scam-site.com/login-now"
}
```

**Response (200) - Unsafe:**
```json
{
  "url": "https://www.free-iphone-scam-site.com/login-now",
  "domain": "free-iphone-scam-site.com",
  "is_safe": false,
  "threat_details": {
    "type": "phishing",
    "description": "Reported as credential harvesting site."
  }
}
```

**Response (200) - Safe:**
```json
{
  "url": "https://www.google.com/search?q=puppies",
  "domain": "google.com",
  "is_safe": true,
  "threat_details": null
}
```

### 2. Add Domain to Blocklist (Admin)

**Request:**
```json
POST /api/admin/domains
Authorization: Bearer <jwt_token>
{
  "domain": "bad-crypto-site.io",
  "threat_type": "scam",
  "notes": "Fake airdrop campaign"
}
```

**Response (201):**
```json
{
  "message": "Domain added to blocklist",
  "data": {
    "domain": "bad-crypto-site.io",
    "threat_type": "scam"
  }
}
```

---

## ⚠️ Error Responses

```json
// 400 Bad Request
{ "error": "Invalid URL provided. Must start with http:// or https://" }

// 409 Conflict (Admin trying to add a domain that is already blocked)
{ "error": "Domain 'bad-crypto-site.io' is already in the blocklist" }

// 401 Unauthorized (Trying to access admin endpoints)
{ "error": "Admin authentication required" }
```