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


## ✅ Before Submission

- [ ] Does the system correctly block users from viewing boards they haven't been invited to?
- [ ] Are cards accurately sorted by a `position` field rather than just creation date?
- [ ] Do you use a junction table (`Board_Members`) to handle team invites?
- [ ] Are you avoiding the N+1 query problem when loading a full board?

---

**Build this and learn: Advanced data relationships, lexicographical sorting, and granular team permissions.**
