# 📋 Task Management System (Trello Clone): Learn By Building

**"Build a collaborative Kanban board where users can create workspaces, invite team members, and drag-and-drop tasks across custom columns."**

---


## 🧪 Testing Scenarios

### Scenario 1: User Creates a Board with Default Columns

```
1. User logs in
2. Clicks "Create Board"
3. Enters title: "Sprint 23" and optional description
4. Clicks "Create"
5. Expected: Board appears with 3 default columns ("To Do", "In Progress", "Done")
6. Verify: User is automatically added as "admin" in board_members
7. Verify: Activity log shows "created board"
```

### Scenario 2: Drag Card Between Columns

```
1. User creates a card "Fix login bug" in "To Do" column
2. User drags card to "In Progress" column
3. Expected: Card appears in "In Progress" immediately (optimistic UI)
4. Verify: Database shows card.column_id updated to "In Progress" column
5. Verify: card.position is lexicographically between neighboring cards
6. Verify: Activity log shows "moved 'Fix login bug' from 'To Do' to 'In Progress'"
7. Refresh page: Card should still be in "In Progress"
```

### Scenario 3: Invite Member and Verify Permissions

```
1. Board admin invites user@example.com as "editor"
2. Expected: Invited user sees the board in their dashboard
3. Editor creates a card: should succeed
4. Editor tries to delete the board: should be denied (403)
5. Admin changes user's role to "viewer"
6. Viewer tries to create a card: should be denied (403)
7. Viewer can still see all cards and columns
```

### Scenario 4: Unauthorized Access Attempts

```
1. User A creates a private board
2. User B (not invited) tries GET /api/boards/:id
3. Expected: 403 "You are not a member of this board"
4. User B tries POST /api/boards/:id/cards
5. Expected: 403 "Not authorized"
6. User B modifies JWT token payload to fake board access
7. Expected: Token invalid or membership check fails
```

### Scenario 5: Concurrent Card Reordering

```
1. Board has cards in "To Do": [A(pos:'a'), B(pos:'c'), C(pos:'e')]
2. User 1 drags C between A and B → C gets position 'b'
3. User 2 simultaneously drags B to the end → B gets position 'f'
4. Expected: Both operations succeed without conflict
5. Final order: A('a'), C('b'), B('f')
6. Verify: No position collisions
```

### Scenario 6: Board Archival

```
1. Admin archives a board
2. Expected: Board disappears from all members' dashboards
3. Verify: Cards and columns still exist in database (soft delete)
4. Admin unarchives the board
5. Expected: Board reappears with all data intact
6. Verify: Activity log shows archive/unarchive events
```

---
