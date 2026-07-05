# 👔 Project Management System: Learn By Building

**"Build a multi-user project board (like Jira or Trello) where Managers create projects, Assignees move tasks across columns, and Watchers receive updates, requiring complex multi-table relationships."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. A Manager creates a project called "Website Redesign".
2. The Manager creates a ticket: "Design the Logo", assigned to Alice.
3. Alice logs in, sees the ticket in "To Do", and moves it to "In Progress".
4. Bob (a watcher) leaves a comment on the ticket.

**What data do you need for each?**

After thinking, here's the data model:

```
Table: Users
├─ id (UUID)
├─ email (String)
├─ password_hash (String)
└─ full_name (String)

Table: Projects
├─ id (UUID)
├─ name (String)
├─ description (Text)
└─ owner_id (Foreign Key -> Users)

Table: Tickets
├─ id (UUID)
├─ project_id (Foreign Key -> Projects)
├─ title (String)
├─ description (Text)
├─ status (Enum: 'to_do', 'in_progress', 'review', 'done')
├─ assignee_id (Foreign Key -> Users) -- Who is doing the work
└─ reporter_id (Foreign Key -> Users) -- Who created the ticket

Table: Comments
├─ id (UUID)
├─ ticket_id (Foreign Key -> Tickets)
├─ user_id (Foreign Key -> Users)
└─ content (Text)
```

---

### Step 2: The Data Hierarchy

This system has a strict hierarchy. A Project has Many Tickets. A Ticket has Many Comments.

```
Project A
│
├── Ticket 1 (To Do)
│   ├── Comment 1 (Bob)
│   └── Comment 2 (Alice)
│
└── Ticket 2 (Done)
```

**Question: If a manager deletes Project A, what happens to Ticket 1 and its comments?**

If you just run `DELETE FROM projects WHERE id = A`, you will leave "Orphaned" tickets in your database. Ticket 1 will still exist, but its `project_id` will point to a project that no longer exists. This corrupts your database.

**Solution: Cascading Deletes**
When designing your database schema, you must configure Foreign Keys to `CASCADE`. This tells the database: "If the parent is deleted, automatically delete all children."

---

### Step 3: Audit Trails (Who did what?)

In a project management system, if a ticket gets moved to "Done" incorrectly, the manager needs to know *who* moved it.

You can't just update the row. You need an **Audit Trail**.

**Good Idea:** Add a `Ticket_History` table.
Every time someone calls `PUT /api/tickets/:id`, before you update the ticket, you insert a row into the history table:
*(Ticket 1, Changed Status, 'to_do' -> 'in_progress', changed_by: Alice, timestamp)*.

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Kanban Board View                    │  │
│  │ Ticket Detail Modal                  │  │
│  │ Activity Feed                        │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP requests with JWT (State changes)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. RBAC (Project-level permissions)  │  │
│  │ 2. Ticket State Machine              │  │
│  │ 3. Activity Logging (Audit Trail)    │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (PostgreSQL/MySQL)         │
│  - projects, tickets, comments tables      │
│  - ON DELETE CASCADE configured            │
└────────────────────────────────────────────┘
```
