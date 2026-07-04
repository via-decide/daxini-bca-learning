# Task Management System (Trello Clone): Learn By Building

**"Build a collaborative Kanban board where users can create workspaces, invite team members, and drag-and-drop tasks across custom columns."**

---


## ⚠️ Common Mistakes

### ❌ Mistake 1: The N+1 Query Problem
**What's wrong:** Querying the DB for the Board (1 query). Then querying the DB for all Columns (1 query). Then, inside a loop, querying the DB for the Cards in Column 1, then Column 2, then Column 3...
**Why it's bad:** If you have 50 columns, that's 52 database queries for a single API call! The server will choke.
**How to fix:** Use `IN()` clauses to fetch all cards at once, then organize them into arrays in your backend code.

### ❌ Mistake 2: Missing Orphan Cleanup (Cascading Deletes)
**What's wrong:** A user deletes a Column, but the Cards inside that column stay in the database.
**Why it's bad:** The cards are now "orphans". They take up space and might cause bugs if queried later.
**How to fix:** Ensure your foreign keys are set up with `ON DELETE CASCADE`, or manually delete child cards before deleting the parent column.

---
