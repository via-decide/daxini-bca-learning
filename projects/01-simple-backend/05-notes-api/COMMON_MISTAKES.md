# 📝 Notes API: Learn By Building

**"Build a robust API for a note-taking application (like Google Keep or Evernote) that allows users to create, search, label, and securely store notes."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Returning Duplicates from a SQL JOIN

**Wrong:**
```javascript
// GET /api/notes
const rows = await db.query(`
  SELECT notes.*, tags.name as tag_name 
  FROM notes 
  LEFT JOIN note_tags ON notes.id = note_tags.note_id
  LEFT JOIN tags ON note_tags.tag_id = tags.id
  WHERE notes.user_id = ?
`, req.user.id);

res.json(rows);
```
*Why it's bad:* If a single note has 3 tags ("Work", "Urgent", "Meeting"), the SQL database will return **3 rows** for that single note. The frontend will render 3 identical notes on the screen!

**Right:**
You must manually group the SQL rows in JavaScript before sending the JSON response.
```javascript
const notesMap = {};

rows.forEach(row => {
  if (!notesMap[row.id]) {
    // First time seeing this note
    notesMap[row.id] = { ...row, tags: [] };
    delete notesMap[row.id].tag_name; // clean up
  }
  // Add the tag to the array if it exists
  if (row.tag_name) {
    notesMap[row.id].tags.push(row.tag_name);
  }
});

// Convert the map back to an array
res.json(Object.values(notesMap));
```

### ❌ Mistake 2: Missing Ownership Checks on Junction Tables

**Wrong:**
```javascript
// POST /api/notes/:note_id/tags (Attach a tag)
const { tag_id } = req.body;
const note_id = req.params.note_id;

// Assuming the user owns the note...
await db.insert("note_tags", { note_id, tag_id });
```
*Why it's bad:* A hacker (User B) can pass the `tag_id` of User A's private tag. Now User A's private tag is attached to User B's note. User B just stole a piece of data.

**Right:**
Verify the tag belongs to the user making the request BEFORE linking it!
```javascript
const tag = await db.query("SELECT id FROM tags WHERE id = ? AND user_id = ?", [tag_id, req.user.id]);
if (!tag) return res.status(403).json({ error: "You do not own this tag" });

const note = await db.query("SELECT id FROM notes WHERE id = ? AND user_id = ?", [note_id, req.user.id]);
if (!note) return res.status(403).json({ error: "You do not own this note" });

// Safe to link
await db.insert("note_tags", { note_id, tag_id });
```

### ❌ Mistake 3: Overwriting the `updated_at` field manually

**Wrong:**
```javascript
// PUT /api/notes/:id
db.query("UPDATE notes SET title = ?, updated_at = ? WHERE id = ?", [title, new Date(), id]);
```
*Why it's bad:* Managing dates in JavaScript can lead to timezone issues.

**Right:**
Let the database engine handle the timestamp natively.
```javascript
db.query("UPDATE notes SET title = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?", [title, id]);
```

---
