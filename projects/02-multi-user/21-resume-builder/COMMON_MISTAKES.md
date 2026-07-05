# 📄 SaaS Resume Builder API: Learn By Building

**"Build a multi-user API where Users create multiple versions of their resumes with distinct sections (Education, Experience), and generate public shareable links that track view counts."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Not Using Atomic Updates for Analytics

**Wrong:**
```javascript
// A recruiter views the public link
app.get('/p/:slug', async (req, res) => {
  // Fetch current count
  const resume = await db.query("SELECT view_count FROM resumes WHERE public_slug = ?", req.params.slug);
  
  // Do math in JS
  const newCount = resume.view_count + 1;
  
  // Save it back
  await db.query("UPDATE resumes SET view_count = ? WHERE public_slug = ?", [newCount, req.params.slug]);
});
```
*Why it's bad:* If 50 recruiters click the link simultaneously, they all fetch `view_count = 10`. They all calculate `11`. They all save `11`. You missed 49 views.

**Right:**
Let the database handle the math internally so it locks the row automatically.
```javascript
await db.query("UPDATE resumes SET view_count = view_count + 1 WHERE public_slug = ?", req.params.slug);
```

### ❌ Mistake 2: Bad "Update" Logic for Nested Arrays

**Wrong:**
When a user edits their resume, trying to meticulously figure out which `experiences` were added, which were updated, and which were deleted using complex Javascript loops.

**Right (The "Nuke and Pave" strategy):**
Since Resume items don't have deep relational dependencies (nobody else links to your specific 2024 TechCorp job row), the safest and easiest way to handle a `PUT` request for the whole resume is:
1. Start Transaction
2. `DELETE FROM resume_experiences WHERE resume_id = ?`
3. Loop through the incoming JSON array and `INSERT` all of them as new rows.
4. Commit Transaction.
This ensures the database perfectly mirrors whatever the frontend just sent.

### ❌ Mistake 3: Leaking Private Data via Public Links

**Wrong:**
Returning the User's `email`, `password_hash`, or other internal database IDs when the public `GET /p/:slug` endpoint is hit.

**Right:**
Explicitly SELECT only the fields a recruiter should see.
```sql
SELECT r.title, u.full_name, r.view_count 
FROM resumes r JOIN users u ON r.user_id = u.id
```

---
