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


## ✅ Before Submission

- [ ] Does a single GET response format the tags as an array within the note JSON?
- [ ] Are you using transactions for the POST endpoint?
- [ ] Does deleting a note clean up the junction table automatically?
- [ ] Is your search efficient, avoiding the N+1 query problem?

---

**Build this and learn: Advanced SQL joins, transactions, and robust data mapping.**
