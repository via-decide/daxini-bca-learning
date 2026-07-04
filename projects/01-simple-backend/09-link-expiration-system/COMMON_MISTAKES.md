# Link Expiration System: Learn By Building

**"Build a secure file/resource sharing API that automatically deletes access after a specific time limit or view count is reached."**

---


## ⚠️ Common Mistakes

### ❌ Mistake 1: Race Conditions
**What's wrong:** Two people click a 1-view link at the exact same millisecond. Both read `current_views (0) < max_views (1)`, both get the secret, and both update the view count. 
**Why it's bad:** A single-view security link was viewed twice.
**How to fix:** Use atomic database transactions or atomic increment commands (e.g., `UPDATE Secrets SET current_views = current_views + 1 WHERE current_views < max_views AND id = ?`).

### ❌ Mistake 2: Returning the Secret on Error
**What's wrong:** Returning `{"error": "Expired", "message": "My bank..."}`.
**Why it's bad:** You just leaked the secret even though it expired.
**How to fix:** Ensure the message payload is completely omitted in error responses.

---
