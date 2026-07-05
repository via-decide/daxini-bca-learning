# 🔗 URL Shortener: API Design

**"Build a system that takes long, ugly URLs and turns them into short, shareable links, tracking how many times they are clicked."**

---

## 🔗 API Endpoints

### Authentication (Optional)

```
POST   /api/auth/register     → Create account
POST   /api/auth/login        → Login, get JWT token
```

### URL Management

```
POST   /api/shorten                   → Create a short URL (accepts optional JWT)
GET    /api/urls                      → List all URLs created by logged-in user
DELETE /api/urls/:id                  → Delete a URL (and its analytics)
GET    /api/urls/:id/analytics        → Get detailed click stats for a URL
```

### The Redirect Endpoint (CRITICAL)

```
GET    /:shortCode                    → The actual redirect endpoint (e.g. yourdomain.com/x7b21q)
```

---

## 📦 Request/Response Examples

### 1. Create a Short URL

**Request:**
```json
POST /api/shorten
{
  "original_url": "https://www.example.com/very/long/path?marketing_tag=summer2026"
}
```
*(Optionally include `Authorization: Bearer <jwt_token>` to link it to an account)*

**Response (201):**
```json
{
  "message": "URL shortened successfully",
  "data": {
    "id": "uuid-url-1",
    "original_url": "https://www.example.com/very/long/path?marketing_tag=summer2026",
    "short_code": "V1StGXR",
    "short_url": "https://short.ly/V1StGXR"
  }
}
```

### 2. The Redirect Endpoint (Browser Action)

**Request:**
```http
GET /V1StGXR HTTP/1.1
Host: short.ly
User-Agent: Mozilla/5.0...
```

**Response (HTTP 302 Found or 301 Moved Permanently):**
```http
HTTP/1.1 302 Found
Location: https://www.example.com/very/long/path?marketing_tag=summer2026
```
*(No JSON is returned here, just the HTTP Location header instructing the browser to redirect!)*

### 3. Analytics Dashboard

**Request:**
```json
GET /api/urls/uuid-url-1/analytics
Authorization: Bearer <jwt_token>
```

**Response (200):**
```json
{
  "short_code": "V1StGXR",
  "original_url": "https://www.example.com/...",
  "total_clicks": 142,
  "recent_clicks": [
    {
      "timestamp": "2026-10-01T14:30:00Z",
      "referrer": "https://twitter.com",
      "browser": "Chrome",
      "os": "Windows"
    },
    {
      "timestamp": "2026-10-01T14:32:00Z",
      "referrer": "Direct",
      "browser": "Safari",
      "os": "iOS"
    }
  ]
}
```

---

## ⚠️ Error Responses

```json
// 400 Bad Request
{ "error": "Invalid URL format provided" }

// 404 Not Found (User clicked a short link that doesn't exist)
{ "error": "Link not found or has been disabled" }

// 429 Too Many Requests
{ "error": "Rate limit exceeded. Please try again in 1 hour." }
```