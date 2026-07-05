# 📋 Task Management System (Trello Clone): Learn By Building

**"Build a collaborative Kanban board where users can create workspaces, invite team members, and drag-and-drop tasks across custom columns."**

---


## ⚠️ Common Mistakes

### ❌ Mistake 1: Using Integer Positions for Card Ordering

**Wrong:**
```javascript
// Moving a card requires updating EVERY card's position
const cards = db.query("SELECT * FROM cards WHERE column_id = ? ORDER BY position");
cards.forEach((card, index) => {
  db.update("cards", card.id, { position: index });
});
// Result: Dragging 1 card causes N database writes
```

**Right:**
```javascript
// Lexicographic positioning: only update the moved card
const abovePos = cardAbove ? cardAbove.position : '';
const belowPos = cardBelow ? cardBelow.position : 'z'.repeat(10);
const newPos = calculateMidpoint(abovePos, belowPos);

db.update("cards", cardId, { position: newPos, column_id: targetColumnId });
// Result: 1 database write, regardless of list size
```

### ❌ Mistake 2: Not Checking Board Membership Before Operations

**Wrong:**
```javascript
app.post('/api/boards/:id/cards', (req, res) => {
  // Anyone with a valid JWT can create cards on ANY board!
  const card = db.insert("cards", { ...req.body });
  res.json(card);
});
```

**Right:**
```javascript
app.post('/api/boards/:id/cards', (req, res) => {
  const membership = db.query(
    "SELECT role FROM board_members WHERE board_id = ? AND user_id = ?",
    req.params.id, req.user.id
  );
  if (!membership || membership.role === 'viewer') {
    return res.status(403).json({ error: 'Not authorized' });
  }
  const card = db.insert("cards", { ...req.body });
  res.json(card);
});
```

### ❌ Mistake 3: No Transaction When Creating Board + Default Columns

**Wrong:**
```javascript
// If server crashes between these calls:
const boardId = db.insert("boards", boardData);
// Server crashes here!
db.insert("columns", { board_id: boardId, title: "To Do" });
db.insert("columns", { board_id: boardId, title: "In Progress" });
// Result: Board exists with no columns — broken UI
```

**Right:**
```javascript
db.transaction(() => {
  const boardId = db.insert("boards", boardData);
  db.insert("board_members", { board_id: boardId, user_id: userId, role: "admin" });
  db.insert("columns", { board_id: boardId, title: "To Do", position: "a" });
  db.insert("columns", { board_id: boardId, title: "In Progress", position: "n" });
  db.insert("columns", { board_id: boardId, title: "Done", position: "z" });
});
// All or nothing: board + member + columns created atomically
```

### ❌ Mistake 4: Not Rolling Back Optimistic UI Updates

**Wrong:**
```javascript
// Move card in UI immediately
moveCardInUI(cardId, targetColumn);
// Send to server
fetch(`/api/cards/${cardId}/move`, { method: 'PATCH', body: data });
// Never check if it succeeded! Card appears moved but server rejected it.
```

**Right:**
```javascript
// Save previous state for rollback
const previousState = getCardState(cardId);
// Move card in UI immediately (optimistic)
moveCardInUI(cardId, targetColumn);
try {
  const res = await fetch(`/api/cards/${cardId}/move`, { method: 'PATCH', body: data });
  if (!res.ok) throw new Error('Move failed');
} catch (error) {
  // Rollback: put card back where it was
  restoreCardState(cardId, previousState);
  showError('Failed to move card. Please try again.');
}
```

### ❌ Mistake 5: Letting Viewers Modify Data Through API

**Wrong:**
```javascript
// Only check role on the frontend
if (userRole !== 'viewer') {
  showEditButton();
}
// But the API has no check — viewer can use Postman to edit cards!
```

**Right:**
```javascript
// Check role on BOTH frontend AND backend
// Frontend: hide edit buttons for viewers
// Backend: verify on every write endpoint
function requireEditor(req, res, next) {
  const membership = db.query(
    "SELECT role FROM board_members WHERE board_id = ? AND user_id = ?",
    req.params.boardId, req.user.id
  );
  if (!membership || membership.role === 'viewer') {
    return res.status(403).json({ error: 'Viewers cannot modify data' });
  }
  next();
}
```

---
