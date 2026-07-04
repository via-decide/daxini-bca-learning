# Code Snippet Storage API: Learn By Building

**"Build a Pastebin-clone backend that allows developers to quickly save, format, and retrieve code snippets with syntax metadata."**

---


## 🔌 API Design: Plan Before Coding

### Endpoint 1: Create Snippet
**POST `/api/snippets`**
- **Body**:
```json
{
  "language": "javascript",
  "code": "console.log('Hello');\n  return true;"
}
```
- **Response**: `201 Created`
```json
{
  "id": "k8M2p",
  "url": "http://localhost:3000/api/snippets/k8M2p"
}
```

### Endpoint 2: Get Snippet
**GET `/api/snippets/:id`**
- **Response**: `200 OK`
```json
{
  "id": "k8M2p",
  "language": "javascript",
  "code": "console.log('Hello');\n  return true;",
  "created_at": "2024-10-24T12:00:00Z"
}
```

### Endpoint 3: List Recent Snippets
**GET `/api/snippets/recent?limit=5`**
- **Response**: Array of snippets (excluding the huge `code` payload to save bandwidth).

---
