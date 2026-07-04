# File Sharing API: Learn By Building

**"Build a backend service that accepts file uploads via multipart form data, saves them to disk, and generates unique download links."**

---


## 🔌 API Design: Plan Before Coding

### Endpoint 1: Upload File
**POST `/api/upload`**
- **Content-Type**: `multipart/form-data`
- **Body**: File payload attached to field name `file`.
- **Response**: `201 Created`
```json
{
  "id": "7f8b9...",
  "url": "http://localhost:3000/api/download/7f8b9..."
}
```

### Endpoint 2: Download File
**GET `/api/download/:id`**
- **Purpose**: Download the specific file.
- **Response**: Binary File Stream (`200 OK`)

---
