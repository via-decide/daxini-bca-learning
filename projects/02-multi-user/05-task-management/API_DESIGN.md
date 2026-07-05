# 📋 Task Management System (Trello Clone): API Design

**"Build a collaborative Kanban board where users can create workspaces, invite team members, and drag-and-drop tasks across custom columns."**

---

## 🔗 API Endpoints

### Authentication

```
POST   /api/auth/register     → Create new user account
POST   /api/auth/login         → Login, receive JWT token
GET    /api/auth/me            → Get current user profile (requires token)
```

### Boards

```
GET    /api/boards             → List all boards for current user
POST   /api/boards             → Create a new board (auto-creates default columns)
GET    /api/boards/:id         → Get board details (columns + cards)
PATCH  /api/boards/:id         → Update board title/description/color
DELETE /api/boards/:id         → Delete board (admin only, cascades)
PATCH  /api/boards/:id/archive → Archive/unarchive board
```

### Board Members

```
GET    /api/boards/:id/members        → List all members of a board
POST   /api/boards/:id/members        → Invite user by email (admin only)
PATCH  /api/boards/:id/members/:uid   → Change member role (admin only)
DELETE /api/boards/:id/members/:uid   → Remove member (admin only)
```

### Columns

```
POST   /api/boards/:id/columns        → Create a new column
PATCH  /api/columns/:id               → Update column title
PATCH  /api/columns/:id/move          → Reorder column (update position)
DELETE /api/columns/:id               → Delete column (cascades cards)
```

### Cards

```
POST   /api/columns/:id/cards         → Create a new card in a column
GET    /api/cards/:id                  → Get card details
PATCH  /api/cards/:id                  → Update card (title, description, due_date, label)
PATCH  /api/cards/:id/move             → Move card to different column + position
PATCH  /api/cards/:id/assign           → Assign card to a user
DELETE /api/cards/:id                  → Delete card
```

### Activity Log

```
GET    /api/boards/:id/activity       → Get activity log for a board (paginated)
```

---

## 🔒 Authorization Matrix

```
Endpoint                    │ Admin │ Editor │ Viewer │ Non-Member
────────────────────────────┼───────┼────────┼────────┼───────────
GET  /boards/:id            │  ✅   │   ✅   │   ✅   │    ❌
POST /boards/:id/columns    │  ✅   │   ✅   │   ❌   │    ❌
POST /columns/:id/cards     │  ✅   │   ✅   │   ❌   │    ❌
PATCH /cards/:id/move       │  ✅   │   ✅   │   ❌   │    ❌
POST /boards/:id/members    │  ✅   │   ❌   │   ❌   │    ❌
DELETE /boards/:id          │  ✅   │   ❌   │   ❌   │    ❌
GET  /boards/:id/activity   │  ✅   │   ✅   │   ✅   │    ❌
```

---

## 📦 Request/Response Examples

### Create Board

**Request:**
```json
POST /api/boards
Authorization: Bearer <jwt_token>
{
  "title": "Sprint 23",
  "description": "Q3 feature sprint"
}
```

**Response (201):**
```json
{
  "id": "uuid-board-1",
  "title": "Sprint 23",
  "description": "Q3 feature sprint",
  "columns": [
    { "id": "uuid-col-1", "title": "To Do", "position": "a", "cards": [] },
    { "id": "uuid-col-2", "title": "In Progress", "position": "n", "cards": [] },
    { "id": "uuid-col-3", "title": "Done", "position": "z", "cards": [] }
  ]
}
```

### Move Card

**Request:**
```json
PATCH /api/cards/uuid-card-5/move
Authorization: Bearer <jwt_token>
{
  "column_id": "uuid-col-2",
  "position": "b"
}
```

**Response (200):**
```json
{
  "id": "uuid-card-5",
  "column_id": "uuid-col-2",
  "position": "b",
  "title": "Fix login bug"
}
```

### Error Responses

```json
// 401 Unauthorized
{ "error": "Invalid credentials" }

// 403 Forbidden
{ "error": "Only board admins can invite members" }

// 404 Not Found
{ "error": "Board not found" }

// 400 Bad Request
{ "error": "Title is required" }
```

---
