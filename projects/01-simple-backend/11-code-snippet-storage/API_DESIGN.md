# 💻 Code Snippet Storage API: API Design

**"Build a pastebin-like API where developers can upload text (code snippets), optionally set them to self-destruct after viewing, and retrieve them with a unique ID."**

---

## 🔗 API Endpoints

```
POST   /api/snippets             → Create a new code snippet
GET    /api/snippets/:id         → Fetch a code snippet
```

---

## 📦 Request/Response Examples

### 1. Create a Snippet

**Request:**
```json
POST /api/snippets
{
  "content": "def hello_world():\n    print('Hello World')",
  "language": "python",
  "is_burn_after_reading": false
}
```

**Response (201):**
```json
{
  "message": "Snippet created",
  "snippet": {
    "id": "x8F9aZ",
    "url": "http://localhost:3000/api/snippets/x8F9aZ",
    "language": "python",
    "is_burn_after_reading": false,
    "created_at": "2026-10-01T10:00:00Z"
  }
}
```

### 2. Fetch a Standard Snippet

**Request:**
```http
GET /api/snippets/x8F9aZ HTTP/1.1
```

**Response (200):**
```json
{
  "id": "x8F9aZ",
  "content": "def hello_world():\n    print('Hello World')",
  "language": "python",
  "created_at": "2026-10-01T10:00:00Z"
}
```

### 3. Fetch a "Burn After Reading" Snippet

**Request:**
```http
GET /api/snippets/secret123 HTTP/1.1
```

**Response (200):**
```json
{
  "id": "secret123",
  "content": "My secret password is: 12345",
  "language": "plaintext",
  "warning": "This snippet has been permanently deleted from the database.",
  "created_at": "2026-10-01T10:05:00Z"
}
```
*(If you make the exact same request again 1 second later, you will get a 404 Not Found).*

---

## ⚠️ Error Responses

```json
// 404 Not Found (Invalid ID, or Snippet was already burned)
{ "error": "Snippet not found." }

// 400 Bad Request
{ "error": "Content is required and cannot exceed 100KB." }

// 429 Too Many Requests
{ "error": "You are creating snippets too quickly. Please try again in 1 minute." }
```
