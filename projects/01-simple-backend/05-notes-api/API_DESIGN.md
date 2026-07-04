# Notes API: Learn By Building

**"Build a markdown-ready notes API that focuses on full-text search and tagging systems."**

---


## 🔌 API Design: Plan Before Coding

### Endpoint 1: Create Note with Tags
**POST `/api/notes`**
- **Request**: `{ "title": "Dev Setup", "content": "# Install Node\n...", "tags": ["coding", "setup"] }`
- **Response**: `201 Created`

### Endpoint 2: Get Note Details
**GET `/api/notes/:id`**
- **Response**: `200 OK`
```json
{
  "id": 1,
  "title": "Dev Setup",
  "content": "# Install Node\n...",
  "tags": [
    { "id": 5, "name": "coding" },
    { "id": 8, "name": "setup" }
  ]
}
```

### Endpoint 3: Search Notes
**GET `/api/notes/search?q=install&tag=coding`**
- **Response**: `200 OK` (Returns paginated list of matching notes).

---
