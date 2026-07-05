# Collaborative Text Editor (Google Docs Clone)

## 🏗️ Architecture: Design Before Coding

**The Problem:**
If two users edit the exact same document at the exact same time, User A's save might overwrite User B's save, resulting in lost data.

**The Solution:**
Operational Transformation (OT) or Conflict-free Replicated Data Types (CRDT). For a learning project, a simplified version of OT via WebSockets will be used, broadcasting keystrokes or diffs instead of the whole document.

**Database Architecture:**
```text
Documents
├─ id
├─ title
├─ content (TEXT - periodic snapshots)
└─ last_updated

Document_Versions
├─ id
├─ document_id
├─ patch_data (JSON)
└─ created_at
```\n