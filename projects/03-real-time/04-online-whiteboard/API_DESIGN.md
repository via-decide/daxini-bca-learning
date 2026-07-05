## 🔌 API Design: Plan Before Coding

### 1. WebSocket Drawing Event
- **Client Emits:** `draw_element(boardId, elementData)`
- **Server Logic:** 
  1. Broadcasts `draw_element` to others.
  2. Upserts the element into the `board_elements` table.

### 2. Fetch Board State
**GET `/api/boards/:id/elements`**
- **Logic:** `SELECT * FROM board_elements WHERE board_id = X ORDER BY z_index ASC`. The client loops through these and renders them on the canvas on initial load.\n