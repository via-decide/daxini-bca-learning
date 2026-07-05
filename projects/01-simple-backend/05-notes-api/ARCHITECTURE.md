# 📝 Notes API: Learn By Building

**"Build a robust API for a note-taking application (like Google Keep or Evernote) that allows users to create, search, label, and securely store notes."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. User logs in.
2. User creates a note: "Grocery List" with content "Milk, Bread, Eggs".
3. User attaches two tags/labels to it: "Personal" and "Shopping".
4. User archives the note (doesn't delete it, just hides it from the main view).
5. User searches for the word "Bread" and finds the note.

**What data do you need for each?**

After thinking, here's the data model:

```
Users
├─ id (UUID)
├─ email (unique)
├─ password_hash
└─ created_at

Notes (The core entity)
├─ id (UUID)
├─ user_id (links to Users)
├─ title
├─ content (TEXT)
├─ is_archived (boolean)
├─ is_pinned (boolean)
├─ color (e.g. '#FFFFFF' for Google Keep style UI)
├─ created_at
└─ updated_at

Tags (Labels that a user creates)
├─ id (UUID)
├─ user_id (links to Users)
└─ name (e.g. "Work", "Personal")

Note_Tags (The Many-to-Many bridge)
├─ note_id (links to Notes)
└─ tag_id (links to Tags)
```

---

### Step 2: The Many-to-Many Relationship

**Question: Why do we need the `Note_Tags` table?**

**Bad Idea (Comma Separated Strings):**
```sql
-- Trying to put tags in the notes table
INSERT INTO notes (title, tags) VALUES ("Groceries", "Personal,Shopping");
```
*Why it's bad:* If the user wants to rename the "Shopping" tag to "Errands", you have to do a horrible string-replace query across thousands of notes. If the user wants to search for notes with the "Shopping" tag, you have to use slow `LIKE '%Shopping%'` queries.

**Good Idea (Junction Table):**
A Note can have Many Tags. A Tag can belong to Many Notes.
This is called a Many-to-Many relationship. You MUST use a third table (`note_tags`) to connect them.

```sql
-- 1. Create Note "Groceries" (ID: 100)
-- 2. Create Tag "Shopping" (ID: 50)
-- 3. Link them:
INSERT INTO note_tags (note_id, tag_id) VALUES (100, 50);
```

---

### Step 3: Database Architecture

```
┌──────────────────────────────────────────┐
│              Database                    │
├──────────────────────────────────────────┤
│                                          │
│  users ─────────┐                        │
│                 │                        │
│                 ├──► tags ─────────┐     │
│                 │                  │     │
│                 │                  ▼     │
│                 ├──► notes ───► note_tags│
│                                          │
└──────────────────────────────────────────┘

Relationships:
- users.id → notes.user_id (One-to-Many)
- users.id → tags.user_id (One-to-Many)
- notes.id → note_tags.note_id (One-to-Many)
- tags.id → note_tags.tag_id (One-to-Many)
```

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Note Editor (Title, Body, Tags)      │  │
│  │ Masonry Grid View (Like Google Keep) │  │
│  │ Search Bar                           │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP Requests + JWT
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ API Layer                            │  │
│  │  - CRUD for Notes                    │  │
│  │  - CRUD for Tags                     │  │
│  │  - Attach/Detach Tag from Note       │  │
│  │  - Full Text Search Endpoint         │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        SQL Queries (JOINs)
              │
              ▼
┌────────────────────────────────────────────┐
│        Database (SQLite/PostgreSQL)        │
│  - Persistent storage                      │
│  - Full-Text Search capability (FTS5)      │
└────────────────────────────────────────────┘
```
