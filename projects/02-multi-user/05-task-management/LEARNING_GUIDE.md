# Task Management System (Trello Clone): Learn By Building

**"Build a collaborative Kanban board where users can create workspaces, invite team members, and drag-and-drop tasks across custom columns."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Many-to-Many Relationships** - Linking Users to Boards via a membership table.
✅ **Ordering and Sorting** - Managing the exact order of items in a list (e.g., placing Card B between Card A and Card C).
✅ **Granular Permissions** - Workspace Admin vs Board Editor vs Board Viewer.
✅ **Nested Data Retrieval** - Fetching Boards -> Columns -> Cards in a structured, efficient way.

---

## 📋 Project Overview

### The Problem
If you build a standard "To-Do" app, every user just sees their own tasks. But in a team environment (like Jira or Trello), multiple users need access to the same project board. Bob might be an Admin on the "Marketing Board", but only a Viewer on the "Engineering Board". Additionally, tasks in a Kanban board aren't just thrown into a pile—they have a specific horizontal position (which column) and a specific vertical position (where in the list).

### Who Uses It
```
Team Leader (Admin):
├─ Creates a new Board ("Q3 Roadmap").
├─ Invites team members by email.
└─ Creates Columns: "To Do", "In Progress", "Done".

Team Member (Editor):
├─ Creates a new Card: "Write blog post".
├─ Moves Card from "To Do" to "In Progress".
└─ Assigns themselves to the Card.
```

---

## 🏗️ Architecture: Design Before Coding

### Step 1: The Sorting Problem

**Question: If I have 3 cards [A, B, C] and I drag Card C between A and B, how do I save that in the database?**
- Bad Idea: Update the `position` integer of every single card in the list (e.g., `A=1, C=2, B=3`). If the list has 1,000 cards, dragging one card causes 1,000 database updates!
- **Good Idea (Lexicographical Sorting):** Give cards string-based positions. `A = 'a'`, `B = 'c'`. If you drag C between them, give C the position `'b'`. You only update ONE card's database row! (Look up "fractional indexing" or "lexicographical ordering").

### Step 2: Database Architecture

```text
Users
├─ id (UUID)
├─ email
└─ name

Boards
├─ id (UUID)
└─ title (VARCHAR)

Board_Members (Many-to-Many table)
├─ board_id (FK -> Boards)
├─ user_id (FK -> Users)
└─ role (ENUM: 'admin', 'editor', 'viewer')

Columns
├─ id (UUID)
├─ board_id (FK -> Boards)
├─ title (VARCHAR)
└─ position (VARCHAR or FLOAT)

Cards
├─ id (UUID)
├─ column_id (FK -> Columns)
├─ title (VARCHAR)
├─ description (TEXT)
└─ position (VARCHAR or FLOAT)
```

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

## 🧠 Implementation: Pseudocode First

### 1. The Permissions Middleware
```text
FUNCTION require_board_role(allowed_roles):
    RETURN FUNCTION(request, response, next):
        board_id = request.params.board_id
        user_id = request.user.id
        
        // Check if user is a member of this board
        membership = DB.query("SELECT role FROM Board_Members WHERE board_id = ? AND user_id = ?", [board_id, user_id])
        
        IF membership is NULL:
            RETURN 403 "You don't have access to this board"
            
        IF membership.role NOT IN allowed_roles:
            RETURN 403 "You don't have permission to do this"
            
        next()
```

### 2. Fetching the Nested Data efficiently
```text
// Bad: Fetching board, then looping to fetch columns, then looping to fetch cards (N+1 Query Problem).
// Good: Fetch all flat data, then nest it in code.

FUNCTION get_board(request, response):
    board_id = request.params.board_id
    
    board = DB.query("SELECT * FROM Boards WHERE id = ?", [board_id])
    columns = DB.query("SELECT * FROM Columns WHERE board_id = ? ORDER BY position ASC", [board_id])
    
    // Get ALL cards for ALL columns in one query
    column_ids = columns.map(c => c.id)
    cards = DB.query("SELECT * FROM Cards WHERE column_id IN (?) ORDER BY position ASC", [column_ids])
    
    // Nest the data in memory (Fast!)
    FOR col IN columns:
        col.cards = cards.filter(card => card.column_id == col.id)
        
    board.columns = columns
    
    RETURN 200 board
```

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: The N+1 Query Problem
**What's wrong:** Querying the DB for the Board (1 query). Then querying the DB for all Columns (1 query). Then, inside a loop, querying the DB for the Cards in Column 1, then Column 2, then Column 3...
**Why it's bad:** If you have 50 columns, that's 52 database queries for a single API call! The server will choke.
**How to fix:** Use `IN()` clauses to fetch all cards at once, then organize them into arrays in your backend code.

### ❌ Mistake 2: Missing Orphan Cleanup (Cascading Deletes)
**What's wrong:** A user deletes a Column, but the Cards inside that column stay in the database.
**Why it's bad:** The cards are now "orphans". They take up space and might cause bugs if queried later.
**How to fix:** Ensure your foreign keys are set up with `ON DELETE CASCADE`, or manually delete child cards before deleting the parent column.

---

## 🧪 Testing: How to Verify

### Test 1: Workspace Privacy
- Create a board with User A.
- Login as User B. Try to fetch the board via `/api/boards/:id`. Ensure it returns `403 Forbidden`.

### Test 2: Role Restrictions
- User A invites User B to the board as a 'viewer'.
- User B tries to hit `PUT /api/cards/:id/move`. Ensure it returns `403 Forbidden` (only Editors/Admins can move cards).

---

## 📚 Resources

- **Positioning**: Read about "Lexicographical sorting" or "Fractional indexing" for drag-and-drop lists.
- **Many-to-Many**: SQL tutorials on junction/join tables.
- **N+1 Query**: Research the "N+1 query problem" in web development.

---

## ✅ Before Submission

- [ ] Does the system correctly block users from viewing boards they haven't been invited to?
- [ ] Are cards accurately sorted by a `position` field rather than just creation date?
- [ ] Do you use a junction table (`Board_Members`) to handle team invites?
- [ ] Are you avoiding the N+1 query problem when loading a full board?

---

**Build this and learn: Advanced data relationships, lexicographical sorting, and granular team permissions.**
