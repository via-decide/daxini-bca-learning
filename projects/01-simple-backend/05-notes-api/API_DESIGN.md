# 📝 Notes API: API Design

**"Build a robust API for a note-taking application (like Google Keep or Evernote) that allows users to create, search, label, and securely store notes."**

---

## 🔗 API Endpoints

### Authentication (Public)

```
POST   /api/auth/register     → Create a new user account
POST   /api/auth/login        → Authenticate and return a JWT
```

### Notes Management (Requires JWT)

```
GET    /api/notes             → List all notes (supports ?search=xyz & ?tag=Work)
POST   /api/notes             → Create a new note
GET    /api/notes/:id         → Get a specific note
PUT    /api/notes/:id         → Update note content/title/color
PATCH  /api/notes/:id/archive → Toggle archive status
PATCH  /api/notes/:id/pin     → Toggle pin status
DELETE /api/notes/:id         → Move to trash / Delete
```

### Tags Management (Requires JWT)

```
GET    /api/tags                  → List all tags created by user
POST   /api/tags                  → Create a new tag
POST   /api/notes/:id/tags        → Attach a tag to a note
DELETE /api/notes/:id/tags/:tagId → Remove a tag from a note
```

---

## 📦 Request/Response Examples

### 1. Create a Note

**Request:**
```json
POST /api/notes
Authorization: Bearer <jwt_token>
{
  "title": "Meeting with Bob",
  "content": "Discuss the new API architecture. Don't forget to mention JWTs.",
  "color": "#FFCC00"
}
```

**Response (201):**
```json
{
  "message": "Note created",
  "note": {
    "id": "uuid-note-1",
    "title": "Meeting with Bob",
    "content": "Discuss the new API architecture...",
    "color": "#FFCC00",
    "is_pinned": false,
    "is_archived": false,
    "tags": [],
    "created_at": "2026-10-01T10:00:00Z"
  }
}
```

### 2. Attach Tag to Note

**Request:**
```json
POST /api/notes/uuid-note-1/tags
Authorization: Bearer <jwt_token>
{
  "tag_id": "uuid-tag-work"
}
```

**Response (200):**
```json
{
  "message": "Tag added to note",
  "note_id": "uuid-note-1",
  "tag": {
    "id": "uuid-tag-work",
    "name": "Work"
  }
}
```

### 3. Search Notes (The complex JOIN response)

**Request:**
```http
GET /api/notes?search=API&is_archived=false HTTP/1.1
Authorization: Bearer <jwt_token>
```

**Response (200):**
```json
{
  "notes": [
    {
      "id": "uuid-note-1",
      "title": "Meeting with Bob",
      "content": "Discuss the new API architecture...",
      "is_pinned": true,
      "tags": [
        { "id": "uuid-tag-work", "name": "Work" },
        { "id": "uuid-tag-urgent", "name": "Urgent" }
      ],
      "updated_at": "2026-10-01T10:05:00Z"
    }
  ],
  "meta": { "total_results": 1 }
}
```

---

## ⚠️ Error Responses

```json
// 404 Not Found (User trying to read someone else's note)
{ "error": "Note not found or unauthorized" }

// 409 Conflict (User trying to add a duplicate tag name like "Work" when it already exists)
{ "error": "A tag with this name already exists" }
```
