## 🔌 API Design: Plan Before Coding

### 1. WebSocket Events
- **Client Emits:** `join_room(roomId)`
- **Server Logic:** Adds the socket to the specified room channel.
- **Client Emits:** `send_message(roomId, messageContent)`
- **Server Logic:** Saves message to Database, then broadcasts `receive_message(messageData)` to all sockets in `roomId`.

### 2. Fetch Chat History (REST)
**GET `/api/rooms/:id/messages`**
- **Logic:** Retrieve the last 50 messages for a room from the `messages` table to populate the initial view.\n