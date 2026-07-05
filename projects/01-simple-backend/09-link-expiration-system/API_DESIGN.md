# 🔗 Link Expiration System: API Design

**"Build a secure link-sharing API that generates unique URLs that automatically expire after a certain number of clicks or a specific time limit."**

---

## 🔗 API Endpoints

```
POST   /api/links                → Create a new secure, expiring link
GET    /s/:id                    → The public redirect endpoint
GET    /api/links/:id/stats      → (Optional) View how many clicks a link has
```

---

## 📦 Request/Response Examples

### 1. Create a Link (Click Limited)

**Request:**
```json
POST /api/links
{
  "target_url": "https://drive.google.com/file/d/secret_document",
  "max_clicks": 10
}
```

**Response (201):**
```json
{
  "message": "Link created successfully",
  "link": {
    "id": "j9F2kL",
    "short_url": "http://localhost:3000/s/j9F2kL",
    "target_url": "https://drive.google.com/...",
    "max_clicks": 10,
    "expires_at": null
  }
}
```

### 2. Create a Link (Time Limited)

**Request:**
```json
POST /api/links
{
  "target_url": "https://zoom.us/j/123456789",
  "expires_at": "2026-10-01T17:00:00Z"
}
```

**Response (201):**
```json
{
  "message": "Link created successfully",
  "link": {
    "id": "m4V8pQ",
    "short_url": "http://localhost:3000/s/m4V8pQ",
    "target_url": "https://zoom.us/...",
    "max_clicks": null,
    "expires_at": "2026-10-01T17:00:00Z"
  }
}
```

### 3. The Redirect Request (What the browser does)

**Request:**
```http
GET /s/m4V8pQ HTTP/1.1
```

**Response (302 Found):**
```http
HTTP/1.1 302 Found
Location: https://zoom.us/j/123456789
```
*(The user never sees this JSON or text; their browser instantly loads the Zoom page).*

---

## ⚠️ Error Responses

If a user clicks an expired link, they should NOT get raw JSON. They should get a friendly HTML page, or an API error if it's an API request.

**Request:**
```http
GET /s/m4V8pQ HTTP/1.1
```

**Response (410 Gone):**
```http
HTTP/1.1 410 Gone
Content-Type: application/json

{
  "error": "This link has expired."
}
```
