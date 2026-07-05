# 📋 Task Management System (Trello Clone): Learn By Building

**"Build a collaborative Kanban board where users can create workspaces, invite team members, and drag-and-drop tasks across custom columns."**

---


## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. User creates a new board called "Sprint 23"
2. User invites a teammate by email to collaborate
3. User creates columns: "To Do", "In Progress", "Done"
4. User drags a card from "To Do" to "In Progress"
5. User assigns a card to a specific team member
6. User adds a due date and label to a card
7. Admin removes a member from the board

**What data do you need for each?**

After thinking, here's the data model:

```
Users (for login)
├─ id (UUID)
├─ email (unique)
├─ password (hashed)
├─ name
├─ avatar_url
└─ created_at

Boards (workspaces/projects)
├─ id (UUID)
├─ title
├─ description
├─ background_color
├─ owner_id (links to Users)
├─ is_archived
└─ created_at

Board_Members (who can access which board)
├─ id
├─ board_id (links to Boards)
├─ user_id (links to Users)
├─ role (admin/editor/viewer)
└─ joined_at

Columns (lists within a board)
├─ id (UUID)
├─ board_id (links to Boards)
├─ title
├─ position (VARCHAR — lexicographic sorting)
└─ created_at

Cards (tasks within a column)
├─ id (UUID)
├─ column_id (links to Columns)
├─ title
├─ description (TEXT — supports markdown)
├─ position (VARCHAR — lexicographic sorting)
├─ assigned_to (links to Users, nullable)
├─ due_date (nullable)
├─ label_color (nullable)
├─ is_archived
└─ created_at

Activity_Log (audit trail)
├─ id
├─ board_id
├─ user_id (who did it)
├─ card_id (nullable)
├─ action (created/moved/assigned/archived)
├─ details (JSON — old/new values)
└─ created_at
```

---

### Step 2: The Sorting Problem (Critical Architecture Decision)

**Question: If I have 3 cards [A, B, C] and I drag Card C between A and B, how do I save that in the database?**

**Bad Idea (Integer Positions):**
```
Before: A=1, B=2, C=3
After drag C between A and B: A=1, C=2, B=3
Problem: Must UPDATE positions of B AND C. If list has 1,000 cards → 1,000 updates!
```

**Good Idea (Lexicographic / Fractional Indexing):**
```
Before: A='a', B='c', C='e'
Drag C between A and B: C='b' (only 1 update!)

More complex example:
  A='a', B='b' — no room between them!
  Solution: Use longer strings. Insert between 'a' and 'b' → 'an'
  
  The position space is infinite because strings can grow.
```

**Why this matters:** Real Kanban boards have hundreds of cards. Users drag constantly. Integer repositioning creates O(n) database writes per drag. Lexicographic sorting creates O(1) writes.

---

### Step 3: Database Architecture

```
┌──────────────────────────────────────────┐
│              Database                    │
├──────────────────────────────────────────┤
│                                          │
│  users ─────────┐                        │
│                 │                        │
│                 ├──► board_members       │
│                 │       │                │
│                 │       └──► boards      │
│                 │              │          │
│                 │              ├──► columns
│                 │              │      │   │
│                 │              │      └──► cards
│                 │              │          │
│                 │              └──► activity_log
│                 │                        │
│                 └──► cards.assigned_to   │
│                                          │
└──────────────────────────────────────────┘

Relationships:
- users.id → board_members.user_id (one user, many boards)
- boards.id → board_members.board_id (one board, many members)
- users.id → boards.owner_id (one user owns many boards)
- boards.id → columns.board_id (one board, many columns)
- columns.id → cards.column_id (one column, many cards)
- users.id → cards.assigned_to (one user, many assigned cards)
- boards.id → activity_log.board_id (one board, many log entries)
```

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML)             │
│  ┌──────────────────────────────────────┐  │
│  │ Login / Register Screen              │  │
│  │ Board List (dashboard)               │  │
│  │ Board View (columns + cards)         │  │
│  │ Card Detail Modal                    │  │
│  │ Drag-and-Drop Engine                 │  │
│  │ Member Management Panel              │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP Requests
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ Authentication Layer                 │  │
│  │  - Login (password check)            │  │
│  │  - JWT token generation              │  │
│  │  - Token verification middleware     │  │
│  ├──────────────────────────────────────┤  │
│  │ Authorization Layer                  │  │
│  │  - Board membership check            │  │
│  │  - Role verification (admin/editor)  │  │
│  │  - Owner-only operations             │  │
│  ├──────────────────────────────────────┤  │
│  │ API Endpoints                        │  │
│  │  - Boards CRUD                       │  │
│  │  - Columns CRUD + reorder            │  │
│  │  - Cards CRUD + move + reorder       │  │
│  │  - Members invite/remove/role        │  │
│  │  - Activity log read                 │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        SQL Queries
              │
              ▼
┌────────────────────────────────────────────┐
│        Database (SQLite/PostgreSQL)        │
│  - Persistent data storage                 │
│  - Foreign key constraints                 │
│  - Indexes on position columns             │
│  - Cascade deletes for board cleanup       │
└────────────────────────────────────────────┘
```

---

### Step 5: Drag-and-Drop Architecture

```
User drags Card X from Column A to Column B (between Card Y and Card Z):

  Frontend:
    1. Capture drag event (HTML5 Drag API or library)
    2. Identify: source_column, target_column, card_id
    3. Identify: card_above (Y) and card_below (Z) in target
    4. Calculate new position: midpoint('Y.position', 'Z.position')
    5. Optimistic UI update (move card immediately)
    6. Send API request

  API Request:
    PATCH /api/cards/:id/move
    Body: {
      column_id: "target_column_id",
      position: "calculated_position"
    }

  Backend:
    1. Verify user has editor/admin role on this board
    2. Verify card exists and belongs to a board the user can access
    3. Update card's column_id and position
    4. Log activity: "User moved 'Card X' from 'To Do' to 'In Progress'"
    5. Return updated card

  If API fails:
    Frontend rolls back the optimistic update (put card back)
```

---
