## 🔌 API Design: Plan Before Coding

### 1. SSE Stream
**GET `/api/notifications/stream`**
- **Logic:** Keeps the HTTP connection open. When a new notification is created for `req.user.id`, the server writes `data: { JSON }` to the response stream.

### 2. Mark as Read
**PUT `/api/notifications/:id/read`**
- **Logic:** `UPDATE notifications SET is_read = true WHERE id = X AND user_id = req.user.id`.\n