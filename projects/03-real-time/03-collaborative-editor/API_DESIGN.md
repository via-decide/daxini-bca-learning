## 🔌 API Design: Plan Before Coding

### 1. WebSocket Document Sync
- **Client Emits:** `document_edit(docId, delta)`
- **Server Logic:** 
  1. Applies the `delta` to the in-memory document state.
  2. Broadcasts the `delta` to all other connected clients.
  3. Every 10 seconds, flushes the in-memory state to the `documents` PostgreSQL table.

### 2. Cursor Position
- **Client Emits:** `cursor_move(docId, line, char, color)`
- **Server Logic:** Broadcasts directly to other clients without hitting the database.\n