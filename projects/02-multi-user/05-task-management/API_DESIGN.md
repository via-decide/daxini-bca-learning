# Task Management System (Trello Clone): Learn By Building

**"Build a collaborative Kanban board where users can create workspaces, invite team members, and drag-and-drop tasks across custom columns."**

---


## 🔌 API Design: Plan Before Coding

### Endpoint 1: Fetch Board Data
**GET `/api/boards/:id`**
- **Auth**: Requires JWT. Must check `Board_Members` to ensure user has access.
- **Response**: A deeply nested JSON object.
```json
{
  "id": "board_1",
  "title": "Marketing",
  "columns": [
    {
      "id": "col_1",
      "title": "To Do",
      "cards": [ { "id": "card_1", "title": "Write blog" } ]
    }
  ]
}
```

### Endpoint 2: Move a Card
**PUT `/api/cards/:id/move`**
- **Body**: `{ "new_column_id": "col_2", "new_position": "b" }`
- **Logic**: Update the card's column and position.

---
