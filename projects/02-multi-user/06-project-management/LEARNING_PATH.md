# 👔 Project Management System: Learn By Building

**"Build a multi-user project board (like Jira or Trello) where Managers create projects, Assignees move tasks across columns, and Watchers receive updates, requiring complex multi-table relationships."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Deep Relational Hierarchies** - Managing data with 3 levels of depth (Projects -> Tickets -> Comments).  
✅ **Cascading Deletes** - Configuring the database to automatically clean up child records when a parent is deleted.  
✅ **State Machines** - Enforcing strict lifecycle statuses on records (`to_do` -> `in_progress` -> `done`).  
✅ **Data Shaping** - Grouping flat database rows into nested JSON objects (like Kanban columns) to make frontend development easier.

---

## 📋 Project Overview

### The Problem

A Project Management tool is the ultimate test of relational database skills. It is not just a single list of items. It is a hierarchy. 
A company has multiple projects. Each project has hundreds of tickets. Each ticket has dozens of comments. 

If a manager decides to delete a defunct project, the database must instantly and safely wipe out thousands of related rows without crashing. Furthermore, when fetching a project, the API needs to organize all that data into a clean structure that a React frontend can easily render into a Kanban board.

**Your job:** Build a deeply relational system that enforces state transitions and uses cascading operations.

### Who Uses It

```
Project Owner (Admin):
├─ POST /api/projects
└─ DELETE /api/projects (Wipes out all tickets/comments automatically)

Team Member:
├─ POST /api/projects/:id/tickets (Creates a ticket)
├─ PUT /api/tickets/:id (Moves a ticket to a new column)
└─ POST /api/tickets/:id/comments (Leaves a note)
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. The Kanban Fetch (Data Shaping)

When the frontend loads the board, it wants everything organized by column.

```pseudocode
GET /api/projects/:id:
  middlewares: [authenticateUser] // User must be logged in
  
  // 1. Get the Project info
  project = db.query("SELECT * FROM projects WHERE id = ?", req.params.id)
  if !project: return 404
  
  // 2. Get ALL tickets for this project, AND join the assignee name so the UI can show avatars
  tickets = db.query(`
    SELECT tickets.*, users.full_name as assignee_name 
    FROM tickets 
    LEFT JOIN users ON tickets.assignee_id = users.id
    WHERE tickets.project_id = ?
  `, req.params.id)
  
  // 3. Shape the Data (The important part!)
  kanban_board = {
    to_do: [],
    in_progress: [],
    review: [],
    done: []
  }
  
  // Sort them into their respective buckets
  for ticket in tickets:
    kanban_board[ticket.status].push({
      id: ticket.id,
      title: ticket.title,
      assignee: ticket.assignee_name
    })
    
  // Return a beautifully structured JSON response
  return 200 {
    id: project.id,
    name: project.name,
    columns: kanban_board
  }
```

### 2. Moving a Ticket (State Transitions)

```pseudocode
PUT /api/tickets/:id:
  middlewares: [authenticateUser]
  
  new_status = request.body.status
  
  // Validate the transition (Optional, but good practice. e.g. Can't jump from to_do straight to done)
  valid_statuses = ['to_do', 'in_progress', 'review', 'done']
  if !valid_statuses.includes(new_status):
    return 400 "Invalid status"
    
  // Update the database
  db.query(`
    UPDATE tickets 
    SET status = ?, updated_at = CURRENT_TIMESTAMP 
    WHERE id = ?
  `, [new_status, request.params.id])
  
  return 200 "Ticket updated"
```

### 3. Deleting a Project (The Power of SQL)

Because we set up `ON DELETE CASCADE` in the `DATABASE.sql` file, this endpoint is incredibly simple, yet incredibly powerful.

```pseudocode
DELETE /api/projects/:id:
  middlewares: [authenticateUser]
  
  // Authorization Check: Only the owner can delete it
  project = db.query("SELECT owner_id FROM projects WHERE id = ?", req.params.id)
  if project.owner_id != req.user.id:
    return 403 "Only the owner can delete this project"
    
  // THIS SINGLE COMMAND will delete the project, AND all its tickets, AND all their comments.
  // Instantly. Safely.
  db.query("DELETE FROM projects WHERE id = ?", req.params.id)
  
  return 200 "Project and all associated data deleted successfully."
```

---

## ✅ Before Submission

- [ ] System supports Users, Projects, Tickets, and Comments (4-table schema).
- [ ] Foreign keys use `ON DELETE CASCADE` so deleting a project cleans up tickets and comments.
- [ ] Ticket statuses are strictly enforced (`to_do`, `in_progress`, `review`, `done`).
- [ ] The `GET /api/projects/:id` endpoint returns tickets grouped by status (shaped for a Kanban board).
- [ ] Only the owner of a project can delete it.
- [ ] Code is on GitHub.

**Success:** You have built a robust relational backend!
