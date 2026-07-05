**URL Safety Checker: Learn By Building**

Build a security tool that scans URLs for phishing, malware, and malicious redirects.

**API Design: Plan Before Coding**

### System Architecture Diagram
```
  +---------------+
  |  Web Interface  |
  +---------------+
           |
           |  (HTTP)
           v
  +---------------+
  |  URL Scanner    |
  |  (Threat Analysis)|
  +---------------+
           |
           |  (Database)
           v
  +---------------+
  |  Blacklist     |
  |  (Domain-based) |
  +---------------+
```

### Endpoint 1: Scan URL

**POST /api/scan**
Purpose: Submit a URL for safety analysis.

Request:
```json
{
    "url": "https://example.com",
    "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
}
```
Response (Safe):
```json
{
    "safe": true,
    "cached": true,
    "threats": [],
    "analysis": {
        "phishing": false,
        "malware": false,
        "redirect": false
    }
}
```
Response (Unsafe):
```json
{
    "safe": false,
    "cached": false,
    "threats": ["MALWARE", "SOCIAL_ENGINEERING"],
    "analysis": {
        "phishing": true,
        "malware": true,
        "redirect": true
    }
}
```
### Endpoint 2: Add to Blacklist (Admin)

**POST /api/admin/blacklist**
Purpose: Manually add a domain to the local blocklist.

Request:
```json
{
    "domain": "badguy.com",
    "reason": "Phishing",
    "expiration": "2025-12-31T23:59:59Z"
}
```
Response:
```http
HTTP/1.1 201 Created
Location: /api/admin/blacklist/badguy.com
```

### Endpoint 3: Get Blacklist (Admin)

**GET /api/admin/blacklist**
Purpose: Retrieve the current blocklist.

Response:
```json
[
    {
        "domain": "badguy.com",
        "reason": "Phishing",
        "expiration": "2025-12-31T23:59:59Z"
    },
    ...
]
```

### Endpoint 4: Remove from Blacklist (Admin)

**DELETE /api/admin/blacklist/badguy.com**
Purpose: Manually remove a domain from the local blocklist.

Response:
```http
HTTP/1.1 204 No Content
```

### Database Schema

```
CREATE TABLE urls (
    id INTEGER PRIMARY KEY,
    url TEXT NOT NULL,
    scanned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    safe BOOLEAN NOT NULL,
    cached BOOLEAN NOT NULL,
    threats TEXT[]
);

CREATE TABLE blacklist (
    domain TEXT PRIMARY KEY,
    reason TEXT NOT NULL,
    expiration DATE NOT NULL
);

CREATE TABLE analysis (
    id INTEGER PRIMARY KEY,
    url_id INTEGER REFERENCES urls(id),
    phishing BOOLEAN NOT NULL,
    malware BOOLEAN NOT NULL,
    redirect BOOLEAN NOT NULL,
    scanned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### System Flow Diagram

```
  +---------------+
  |  Web Interface  |
  +---------------+
           |
           |  (HTTP)
           v
  +---------------+
  |  URL Scanner    |
  |  (Threat Analysis)|
  +---------------+
           |
           |  (Database)
           v
  +---------------+
  |  Blacklist     |
  |  (Domain-based) |
  +---------------+
           |
           |  (Cache)
           v
  +---------------+
  |  Cache Manager |
  +---------------+
```

### Edge Cases and Error Handling

* Handle invalid URLs or malformed requests.
* Implement rate limiting for the URL scanner to prevent abuse.
* Log and track errors, exceptions, and performance metrics.
* Provide detailed error messages for API clients.

**Why**

The URL Safety Checker is designed to provide a comprehensive security tool for scanning URLs. The system architecture diagram shows the high-level components and interactions between them. The endpoint descriptions outline the specific requests and responses for each API call. The database schema defines the relationships between the tables, and the system flow diagram illustrates the overall workflow.