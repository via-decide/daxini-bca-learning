# Task Management System (Trello Clone): Learn By Building

**"Build a collaborative Kanban board where users can create workspaces, invite team members, and drag-and-drop tasks across custom columns."**

---


## 🧪 Testing: How to Verify

### Test 1: Workspace Privacy
- Create a board with User A.
- Login as User B. Try to fetch the board via `/api/boards/:id`. Ensure it returns `403 Forbidden`.

### Test 2: Role Restrictions
- User A invites User B to the board as a 'viewer'.
- User B tries to hit `PUT /api/cards/:id/move`. Ensure it returns `403 Forbidden` (only Editors/Admins can move cards).

---


