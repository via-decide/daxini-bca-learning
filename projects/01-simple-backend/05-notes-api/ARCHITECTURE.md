# Notes API: Learn By Building

**"Build a markdown-ready notes API that focuses on full-text search and tagging systems."**

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
