# Notes API: Learn By Building

**"Build a markdown-ready notes API that focuses on full-text search and tagging systems."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Many-to-Many Relationships** - How to link Notes and Tags using a junction table
✅ **Full-Text Search** - Implementing robust search capabilities beyond simple `LIKE '%word%'`
✅ **Data Serialization** - Formatting database rows into clean, structured JSON responses
✅ **Database Indexing** - Why searching thousands of text documents requires specialized indexes
✅ **Markdown Handling** - Storing and safely serving user-generated markdown content

---

## 📋 Project Overview

### The Problem
A basic To-Do list is flat. A Notes app requires categorization. Users want to tag a single note with "Work" and "Ideas", and they want to search through years of notes instantly. This requires understanding how to map complex relationships in a relational database and how to optimize queries so the app doesn't freeze during a search.

### Who Uses It
```
Web Frontend / Mobile App:
├─ Displays a list of tags in a sidebar
├─ Renders markdown notes securely
└─ Includes a fast, real-time search bar

Backend API (You):
├─ Handles complex JOIN queries to fetch a note and its tags
├─ Uses full-text indexing to search note contents
└─ Sanitizes input to prevent XSS (Cross-Site Scripting)
```

### The Big Picture

```text
┌──────────────┐     ┌──────────────┐     ┌───────────────┐
│  Search Box  │ ──> │ Backend API  │ ──> │ DB Full-Text  │
│  "Meeting"   │ <── │ (Controller) │ <── │ Search Engine │
└──────────────┘     └──────┬───────┘     └───────────────┘
                            │
                     ┌──────┴───────┐
                     │ Tag/Junction │
                     │  DB Queries  │
                     └──────────────┘
```

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data

**Question: What information must the system store?**
- Notes have a title and markdown content.
- Tags have a name (e.g., "urgent").
- A Note can have multiple Tags. A Tag can belong to multiple Notes.

**After thinking, here's the data model:**
- We need a `notes` table.
- We need a `tags` table.
- We need a `note_tags` (junction/mapping) table to connect them.

### Step 2: Architecture Diagram

```text
1. Client POSTs /notes with JSON: { title: "X", content: "Y", tags: ["A", "B"] }
2. API validates data.
3. API starts a Database Transaction.
4. API inserts into `notes`. Gets Note ID.
5. API checks `tags` for "A" and "B". Creates them if they don't exist.
6. API inserts into `note_tags` linking Note ID to Tag IDs.
7. API commits Transaction.
8. API returns 201 Created.
```

### Step 3: Data Flow (Search)
1. User searches `?q=docker`.
2. Backend runs a full-text query against the `notes.content` column.
3. Backend fetches the associated tags for each matching note.
4. Backend formats the nested JSON and returns it.

---

## 🗄️ Database: Design, Don't Code

### Schema Design (Think Before SQL)

```sql
CREATE TABLE notes (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL, -- Markdown content
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tags (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) UNIQUE NOT NULL
);

-- The Junction Table
CREATE TABLE note_tags (
  note_id INTEGER REFERENCES notes(id) ON DELETE CASCADE,
  tag_id INTEGER REFERENCES tags(id) ON DELETE CASCADE,
  PRIMARY KEY (note_id, tag_id)
);
```

### Design Questions

1. **Why do we need a `note_tags` table?**
   Relational databases cannot cleanly store an array of tags inside a single `notes` row if you want to efficiently query "Show me all notes with the tag 'Work'". The junction table solves the Many-to-Many problem perfectly.

2. **What does `ON DELETE CASCADE` do?**
   If you delete a note, the database automatically deletes all the linkage rows in `note_tags` for that specific note. It keeps your database clean without requiring extra delete queries in your backend code.

---

## 🔌 API Design: Plan Before Coding

### Endpoint 1: Create Note with Tags
**POST `/api/notes`**
- **Request**: `{ "title": "Dev Setup", "content": "# Install Node\n...", "tags": ["coding", "setup"] }`
- **Response**: `201 Created`

### Endpoint 2: Get Note Details
**GET `/api/notes/:id`**
- **Response**: `200 OK`
```json
{
  "id": 1,
  "title": "Dev Setup",
  "content": "# Install Node\n...",
  "tags": [
    { "id": 5, "name": "coding" },
    { "id": 8, "name": "setup" }
  ]
}
```

### Endpoint 3: Search Notes
**GET `/api/notes/search?q=install&tag=coding`**
- **Response**: `200 OK` (Returns paginated list of matching notes).

---

## 🧠 Implementation: Pseudocode First

```text
FUNCTION create_note(request):
    title = request.body.title
    content = request.body.content
    tags_array = request.body.tags // ["coding", "setup"]
    
    // Start Transaction
    Database.begin_transaction()
    
    TRY:
        // 1. Insert Note
        note_id = Database.insert("notes", { title, content })
        
        // 2. Handle Tags
        FOR tag_name IN tags_array:
            // Insert tag if it doesn't exist, get ID
            tag_id = Database.execute("
                INSERT INTO tags (name) VALUES (:name) 
                ON CONFLICT (name) DO UPDATE SET name=name 
                RETURNING id", { name: tag_name })
                
            // 3. Link them
            Database.insert("note_tags", { note_id, tag_id })
            
        Database.commit()
        RETURN { success: true, id: note_id }
        
    CATCH Error:
        Database.rollback()
        RETURN { error: "Failed to create note" }
```

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: N+1 Query Problem
**What's wrong:** Fetching 10 notes, and then running a loop that queries the database 10 separate times to get the tags for each note.
**Why it's bad:** It crushes database performance. Instead of 1 query, you are running 11 queries.
**How to fix:** Use a `SQL JOIN` to fetch the notes and tags in a single query, or use an ORM feature designed to eager-load relationships.

### ❌ Mistake 2: Missing Database Transactions
**What's wrong:** Creating a note, then the server crashes before it creates the tags.
**Why it's bad:** You have orphaned data in your database. A note exists but the tags that the user specified were lost.
**How to fix:** Wrap multi-step database writes in a Transaction (`BEGIN` ... `COMMIT`). If anything fails, it rolls back automatically.

---

## 🧪 Testing: How to Verify

### Test 1: The Transaction Rollback
- Modify your code temporarily to throw an error right after the `notes` table insert, but before the `tags` are saved.
- Make a POST request.
- Check the database. The note should NOT be in the `notes` table because the transaction rolled back.

### Test 2: Full-Text Search Accuracy
- Create a note with the word "PostgreSQL".
- Search for "postgres".
- If you implemented proper full-text search (using Postgres `tsvector` or MySQL `FULLTEXT`), it should find the note using stemming. If you just used `LIKE`, it will fail.

---

## 🛠️ Debugging: When Things Break

### Problem: SQL duplicate key error when adding tags
**Root Cause:** Two notes try to create the tag "urgent" at the exact same time, causing a race condition on the unique `name` constraint in the `tags` table.
**Solution:** Use "Upsert" logic. In Postgres, this is `ON CONFLICT DO NOTHING`. In MySQL, it's `INSERT IGNORE`.

---

## 📚 Resources

- **Many-to-Many Relationships**: Database Design Guides
- **Database Transactions**: ACID Properties Explained
- **Full Text Search**: Postgres Full Text Search guide (or equivalent for your DB)

---

## ✅ Before Submission

- [ ] Does a single GET response format the tags as an array within the note JSON?
- [ ] Are you using transactions for the POST endpoint?
- [ ] Does deleting a note clean up the junction table automatically?
- [ ] Is your search efficient, avoiding the N+1 query problem?

---

**Build this and learn: Advanced SQL joins, transactions, and robust data mapping.**
