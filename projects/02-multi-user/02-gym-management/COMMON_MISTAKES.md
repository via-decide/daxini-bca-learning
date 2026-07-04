# 💪 Gym Management System: Learn By Building

**"Build a complete system for managing gyms. Understand databases, roles, and complex workflows."**

---


## ⚠️ Common Mistakes

### ❌ Mistake 1: No Transaction for Related Records

**Wrong:**
```javascript
// If this crashes between two inserts:
db.insert("users", userData);
// Server crashes here
db.insert("members", memberData);
// Result: user exists but no member
```

**Right:**
```javascript
// All or nothing
db.transaction(() => {
  db.insert("users", userData);
  db.insert("members", memberData);
});
```

### ❌ Mistake 2: Trusting Role from Frontend

**Wrong:**
```javascript
if (req.body.role === "admin") { // User can send admin!
  // Give admin access
}
```

**Right:**
```javascript
if (req.user.role === "admin") { // Get from JWT token
  // Give admin access
}
```

### ❌ Mistake 3: Not Checking Membership Expiration

**Wrong:**
```javascript
// Just let member access
app.post('/api/workouts', (req, res) => {
  // Log workout without checking membership
});
```

**Right:**
```javascript
app.post('/api/workouts', (req, res) => {
  // Check membership first
  const membership = db.query(
    "SELECT * FROM memberships WHERE member_id = ? AND status = 'active' AND end_date > today"
  );
  if (!membership) {
    return res.status(403).json({ error: 'Membership expired' });
  }
  // Log workout
});
```

### ❌ Mistake 4: Allowing Anyone to View Any Member

**Wrong:**
```javascript
app.get('/api/members/:id', (req, res) => {
  // Return member info without checking permissions
  const member = db.query('SELECT * FROM members WHERE id = ?');
  return res.json(member);
});
```

**Right:**
```javascript
app.get('/api/members/:id', (req, res) => {
  if (req.user.role !== 'admin' && req.user.id !== id) {
    return res.status(403).json({ error: 'Unauthorized' });
  }
  const member = db.query('SELECT * FROM members WHERE id = ?');
  return res.json(member);
});
```

---
