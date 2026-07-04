## 🔌 API Design: Plan Before Coding

### 1. Assign Ticket
**PUT `/api/tickets/:id/assign`**
- **Body**: `{ "agent_id": "123" }`
- **Logic**: Ensure `assignee_id` is currently NULL (preventing two agents claiming the same ticket concurrently).

### 2. Add Comment
**POST `/api/tickets/:id/comments`**
- **Logic**: Insert the comment. If the user is an Agent, automatically update the Ticket status to "Pending Customer Reply".
