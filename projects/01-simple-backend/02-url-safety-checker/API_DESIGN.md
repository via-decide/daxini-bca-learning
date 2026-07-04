# URL Safety Checker: Learn By Building

**"Build a security tool that scans URLs for phishing, malware, and malicious redirects."**

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
