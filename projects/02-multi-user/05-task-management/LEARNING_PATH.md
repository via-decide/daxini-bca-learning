# 📋 Task Management System (Trello Clone): Learn By Building

**"Build a collaborative Kanban board where users can create workspaces, invite team members, and drag-and-drop tasks across custom columns."**

---


## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Multi-User Collaboration** - Shared boards with role-based permissions  
✅ **Complex Data Models** - Users, boards, columns, cards, activity logs  
✅ **Many-to-Many Relationships** - Board members junction table  
✅ **Authentication** - Login, JWT tokens, password hashing  
✅ **Authorization** - Role-based access (admin/editor/viewer per board)  
✅ **Drag-and-Drop Logic** - Lexicographic ordering for efficient repositioning  
✅ **Optimistic UI Updates** - Update UI before server confirms  
✅ **Activity Logging** - Audit trail of all user actions  
✅ **Full-Stack Development** - Frontend + Backend + Database  

---


## 📋 Project Overview

### The Problem

Teams need to manage tasks visually:
- Boards (project workspaces with invited members)
- Columns (stages like "To Do", "In Progress", "Done")
- Cards (individual tasks with descriptions, assignees, due dates)
- Members (who can see and edit which boards)
- Activity (who moved what, when)

**Your job:** Build a system for all this.

### Who Uses It

```
Board Admin:
├─ Create/delete boards
├─ Invite members by email
├─ Set member roles (admin/editor/viewer)
├─ Remove members
├─ Create/delete/reorder columns
├─ Archive boards
└─ View activity log

Board Editor:
├─ Create/edit/delete cards
├─ Drag cards between columns
├─ Assign cards to members
├─ Set due dates and labels
├─ Add descriptions (markdown)
└─ View activity log

Board Viewer:
├─ View board, columns, cards
├─ View card details
└─ Cannot create, edit, or move anything
```

---


## 🧠 Implementation Strategy: Pseudocode

### Login Flow

```pseudocode
POST /api/auth/login(email, password):
  Step 1: Find user by email
    user = database.query("SELECT * FROM users WHERE email = ?")
    if user not found:
      return error 401 "Invalid credentials"
  
  Step 2: Compare passwords
    passwordMatch = bcryptjs.compare(password, user.password_hash)
    if not match:
      return error 401 "Invalid credentials"
  
  Step 3: Generate JWT token
    token = jwt.sign(
      { userId: user.id, name: user.name },
      secret_key,
      { expiresIn: "7d" }
    )
  
  Step 4: Return token and user info
    return {
      token: token,
      user: { id, name, email, avatar_url }
    }
```

### Create Board

```pseudocode
POST /api/boards(title, description):
  Step 1: Verify user is authenticated
    if not request.user:
      return error 401 "Not authenticated"
  
  Step 2: Validate input
    if not title:
      return error 400 "Title is required"
  
  Step 3: Create board with default columns (transaction)
    START TRANSACTION:
      board_id = database.insert("boards", {
        title, description,
        owner_id: request.user.id,
        background_color: "#1a1a2e"
      })
      
      // Auto-add creator as admin member
      database.insert("board_members", {
        board_id, user_id: request.user.id, role: "admin"
      })
      
      // Create default columns
      database.insert("columns", { board_id, title: "To Do", position: "a" })
      database.insert("columns", { board_id, title: "In Progress", position: "n" })
      database.insert("columns", { board_id, title: "Done", position: "z" })
    COMMIT
  
  Step 4: Return created board
    return { id: board_id, title, description }
```

### Move Card (Drag-and-Drop)

```pseudocode
PATCH /api/cards/:id/move(column_id, position):
  Step 1: Verify user has editor/admin role on this board
    card = database.query("SELECT * FROM cards WHERE id = ?")
    column = database.query("SELECT * FROM columns WHERE id = ?", card.column_id)
    membership = database.query(
      "SELECT role FROM board_members WHERE board_id = ? AND user_id = ?",
      column.board_id, request.user.id
    )
    if not membership or membership.role == "viewer":
      return error 403 "You don't have permission to move cards"
  
  Step 2: Validate target column belongs to the same board
    target_column = database.query("SELECT * FROM columns WHERE id = ?", column_id)
    if target_column.board_id != column.board_id:
      return error 400 "Cannot move card to a different board"
  
  Step 3: Update card position
    database.update("cards", card.id, {
      column_id: column_id,
      position: position
    })
  
  Step 4: Log the activity
    database.insert("activity_log", {
      board_id: column.board_id,
      user_id: request.user.id,
      card_id: card.id,
      action: "moved",
      details: JSON.stringify({
        from_column: column.title,
        to_column: target_column.title
      })
    })
  
  Step 5: Return updated card
    return { id: card.id, column_id, position }
```

### Invite Member to Board

```pseudocode
POST /api/boards/:id/members(email, role):
  Step 1: Verify requester is board admin
    membership = database.query(
      "SELECT role FROM board_members WHERE board_id = ? AND user_id = ?",
      board_id, request.user.id
    )
    if not membership or membership.role != "admin":
      return error 403 "Only admins can invite members"
  
  Step 2: Find user by email
    invitee = database.query("SELECT * FROM users WHERE email = ?", email)
    if not invitee:
      return error 404 "No user found with that email"
  
  Step 3: Check if already a member
    existing = database.query(
      "SELECT id FROM board_members WHERE board_id = ? AND user_id = ?",
      board_id, invitee.id
    )
    if existing:
      return error 400 "User is already a member of this board"
  
  Step 4: Add to board
    database.insert("board_members", {
      board_id, user_id: invitee.id, role: role || "editor"
    })
  
  Step 5: Log activity
    database.insert("activity_log", {
      board_id,
      user_id: request.user.id,
      action: "invited",
      details: JSON.stringify({ invited_user: invitee.name, role })
    })
  
  Step 6: Return success
    return { message: "Member invited", user: invitee.name, role }
```

---


## ✅ Before Submission

- [ ] Authentication works (login, register, JWT)
- [ ] Board CRUD works (create, read, update, delete)
- [ ] Column CRUD + reordering works
- [ ] Card CRUD + drag-and-drop between columns works
- [ ] Member invitation and role assignment works
- [ ] Viewer cannot edit, editor cannot delete board
- [ ] Activity log records all actions
- [ ] Lexicographic position sorting works correctly
- [ ] Optimistic UI update with rollback on failure
- [ ] Data persists across restarts
- [ ] Errors handled gracefully with proper HTTP codes
- [ ] Can demo 5 features
- [ ] Can explain the architecture and the sorting algorithm
- [ ] Code is on GitHub

**Success:** A working Kanban board that multiple users can collaborate on, and you understand every part.
