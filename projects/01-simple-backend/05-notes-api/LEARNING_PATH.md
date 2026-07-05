# 📝 Notes API: Learn By Building

**"Build a robust API for a note-taking application (like Google Keep or Evernote) that allows users to create, search, label, and securely store notes."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Many-to-Many Relationships** - Designing and querying junction tables (`note_tags`).  
✅ **Data Shaping** - Converting flat SQL rows (from JOINs) into nested, structured JSON objects for the frontend.  
✅ **Cascading Deletes** - Leveraging the database engine to clean up relationships when a parent record is deleted.  
✅ **Advanced Search Queries** - Writing SQL `LIKE` queries or Full-Text Search to find notes by keyword.  
✅ **Strict Data Isolation** - Ensuring users cannot attach tags they don't own to notes they don't own.

---

## 📋 Project Overview

### The Problem

A To-Do list is simple (One-to-Many). A Notes App is complex because a note can have multiple labels, and a label can apply to multiple notes. This requires a Many-to-Many database architecture. Furthermore, the frontend expects nested JSON (a Note object containing an Array of Tags), which SQL does not natively output.

**Your job:** Build the backend data-fetching and organizing engine for a modern note-taking app.

### Who Uses It

```
The User:
├─ Logs in securely
├─ Creates color-coded notes
├─ Creates reusable tags ("Work", "Urgent")
├─ Links tags to notes
└─ Searches their thousands of notes for specific keywords
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. The Junction Table Concept

A junction table simply holds two IDs.

```text
Table: note_tags
| note_id | tag_id |
|---------|--------|
| note_A  | tag_1  |
| note_A  | tag_2  |
| note_B  | tag_1  |
```
*Translation: Note A has Tag 1 and Tag 2. Note B has Tag 1.*

### 2. Attaching a Tag (The Linking Endpoint)

```pseudocode
POST /api/notes/:id/tags(tag_id):
  Step 1: Authenticate
    user_id = request.user.id
    
  Step 2: Verify Note Ownership
    note = database.query("SELECT id FROM notes WHERE id = ? AND user_id = ?", id, user_id)
    if !note: return 404
    
  Step 3: Verify Tag Ownership
    tag = database.query("SELECT id FROM tags WHERE id = ? AND user_id = ?", tag_id, user_id)
    if !tag: return 404
    
  Step 4: Create the Link
    try:
      database.insert("note_tags", { note_id: id, tag_id: tag_id })
    catch constraint_error:
      // They tried to attach it twice. Ignore or return error.
      return 409 "Tag already attached"
      
  Step 5: Success
    return 200 "Attached"
```

### 3. Fetching Notes & Shaping Data (The Hard Part)

```pseudocode
GET /api/notes?search=recipe:
  Step 1: The Massive JOIN Query
    // We join 3 tables together
    query = `
      SELECT 
        n.id as note_id, n.title, n.content, n.color,
        t.id as tag_id, t.name as tag_name
      FROM notes n
      LEFT JOIN note_tags nt ON n.id = nt.note_id
      LEFT JOIN tags t ON nt.tag_id = t.id
      WHERE n.user_id = ? AND (n.title LIKE ? OR n.content LIKE ?)
    `
    rows = database.execute(query, user_id, "%recipe%", "%recipe%")
    
  Step 2: Shape the Data
    // SQL returns a flat array of rows. We must group them by note_id.
    map = {}
    
    for row in rows:
      if not map[row.note_id]:
        // Initialize the note object
        map[row.note_id] = {
          id: row.note_id,
          title: row.title,
          content: row.content,
          tags: []
        }
        
      // If the row has a tag, push it into the array
      if row.tag_id:
        map[row.note_id].tags.push({ id: row.tag_id, name: row.tag_name })
        
  Step 3: Return the Array
    final_array = Object.values(map)
    return { notes: final_array }
```

---

## ✅ Before Submission

- [ ] Users can create notes and separate tags.
- [ ] Users can attach tags to notes (Many-to-Many).
- [ ] Deleting a Tag automatically removes it from all notes (Cascading).
- [ ] Deleting a Note automatically removes the linkage (Cascading).
- [ ] Fetching notes returns a nested JSON structure with tags inside the note object.
- [ ] Users cannot access or link other users' tags/notes.
- [ ] Code is on GitHub.

**Success:** You have mastered relational database design and data shaping, the two most important skills for a backend engineer.
