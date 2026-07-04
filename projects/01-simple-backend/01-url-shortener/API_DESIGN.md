# 🔗 URL Shortener: Learn By Building

**"Build a system that makes long URLs short. Understand every part."**

---


## 🔌 API Design: Plan Before Coding

### Endpoint 1: Create Short URL

**Think about this:**
- What should user send?
- What should server return?
- What can go wrong?

**After thinking, here's the spec:**

```
Endpoint: POST /api/shorten
Purpose: Create a short URL

REQUEST:
{
  "longUrl": "https://wikipedia.org/wiki/AI",
  "customCode": "ai" (optional)
}

RESPONSE (Success - 200):
{
  "shortCode": "ai",
  "shortUrl": "http://localhost:3000/ai",
  "longUrl": "https://wikipedia.org/wiki/AI"
}

RESPONSE (Error - 400):
{
  "error": "Invalid URL format"
}

RESPONSE (Error - 400):
{
  "error": "Custom code already exists"
}

RESPONSE (Error - 500):
{
  "error": "Database error"
}
```

### Endpoint 2: Redirect

```
Endpoint: GET /:shortCode
Purpose: Redirect to original URL

REQUEST:
GET /ai

RESPONSE (Success - 302 Redirect):
Location: https://wikipedia.org/wiki/AI
(+ increment clicks in database)

RESPONSE (Error - 404):
{
  "error": "URL not found"
}
```

### Endpoint 3: Get Stats (Optional but good to include)

```
Endpoint: GET /api/stats/:shortCode
Purpose: Get analytics for a URL

REQUEST:
GET /api/stats/ai

RESPONSE (Success - 200):
{
  "shortCode": "ai",
  "longUrl": "https://wikipedia.org/wiki/AI",
  "clicks": 42,
  "createdAt": "2026-01-15T10:30:00Z"
}

RESPONSE (Error - 404):
{
  "error": "URL not found"
}
```

---
