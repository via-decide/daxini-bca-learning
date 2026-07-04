# Task Management System (Trello Clone): Learn By Building

**"Build a collaborative Kanban board where users can create workspaces, invite team members, and drag-and-drop tasks across custom columns."**

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
