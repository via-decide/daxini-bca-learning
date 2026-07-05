# 📄 SaaS Resume Builder API: Learn By Building

**"Build a multi-user API where Users create multiple versions of their resumes with distinct sections (Education, Experience), and generate public shareable links that track view counts."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Deep JSON Parsing to Relational SQL** - How to take a complex, nested JSON object from a frontend POST request and shatter it safely across multiple SQL tables.  
✅ **Atomic Operations** - Using SQL math (`view_count = view_count + 1`) to guarantee perfect accuracy under heavy concurrent traffic.  
✅ **Public vs Private Routing** - Structuring an API where the owner has full CRUD access via JWT, but the public only has read-only access via a unique URL slug.

---

## 📋 Project Overview

### The Problem

A Resume is a single "Document" conceptually, but relationally, it is 1 Core Record, 5 Experience Records, and 2 Education Records. 

When the user clicks "Save", the frontend sends all of this at once. If your backend saves the Core Record, but crashes before saving the Experiences, you have corrupted data. You must use Database Transactions.

Furthermore, SaaS applications need public sharing. You must generate a URL slug, handle unauthenticated requests to that slug safely, and track analytics (views) without dropping counts when multiple people click simultaneously.

**Your job:** Build a robust, transactional API that maps JSON trees to SQL tables, and a high-performance public viewing endpoint.

### Who Uses It

```
User (Authenticated):
├─ POST /api/resumes (Creates the complex document)
├─ PUT /api/resumes/:id (Updates the document using Nuke & Pave)
└─ PUT /api/resumes/:id/publish (Generates the public link)

Public (Unauthenticated):
└─ GET /p/:slug (Views the resume, increments the counter)
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. Creating the Resume (The Multi-Table Transaction)

```pseudocode
POST /api/resumes:
  middlewares: [authenticateUser]
  
  // 1. Start the atomic block
  db.execute("BEGIN TRANSACTION")
  
  try:
    resume_id = UUID()
    
    // 2. Insert the Root Record
    db.query(`
      INSERT INTO resumes (id, user_id, title) VALUES (?, ?, ?)
    `, [resume_id, req.user.id, request.body.title])
    
    // 3. Insert Experiences (Loop)
    for exp in request.body.experiences:
      db.query(`
        INSERT INTO resume_experiences (id, resume_id, company, role, start_date)
        VALUES (UUID(), ?, ?, ?, ?)
      `, [resume_id, exp.company, exp.role, exp.start_date])
      
    // 4. Insert Educations (Loop)
    for edu in request.body.educations:
      db.query(`
        INSERT INTO resume_educations (id, resume_id, institution, degree)
        VALUES (UUID(), ?, ?, ?)
      `, [resume_id, edu.institution, edu.degree])
      
    // 5. Commit!
    db.execute("COMMIT")
    return 201 { id: resume_id }
    
  catch (error):
    // If ANY of the queries fail, we roll everything back.
    db.execute("ROLLBACK")
    return 500 "Failed to save resume."
```

### 2. The Public Endpoint (Atomic Increment & Fetch)

We need to do two things: Increment the counter, and return the data.

```pseudocode
GET /p/:slug:
  // No auth middleware!
  
  // 1. Find the Resume
  resume = db.query(`
    SELECT r.id, r.title, u.full_name, r.is_published 
    FROM resumes r JOIN users u ON r.user_id = u.id 
    WHERE r.public_slug = ?
  `, request.params.slug)
  
  if !resume or !resume.is_published:
    return 404 "Resume not found."
    
  // 2. Increment the View Count (Atomic!)
  // Note: We don't wait for this to finish to return the response.
  // Fire and forget, or await it.
  db.query(`
    UPDATE resumes 
    SET view_count = view_count + 1 
    WHERE id = ?
  `, resume.id)
  
  // 3. Fetch the nested data
  exps = db.query("SELECT * FROM resume_experiences WHERE resume_id = ?", resume.id)
  edus = db.query("SELECT * FROM resume_educations WHERE resume_id = ?", resume.id)
  
  // 4. Assemble the JSON payload
  return 200 {
    title: resume.title,
    owner: resume.full_name,
    experiences: exps,
    educations: edus
  }
```

---

## ✅ Before Submission

- [ ] Creating a resume saves data across multiple tables using a `BEGIN TRANSACTION` block.
- [ ] Updating a resume correctly syncs nested arrays (e.g., deleting an old job, adding a new one).
- [ ] Public endpoint `/p/:slug` does not require authentication and explicitly checks `is_published = true`.
- [ ] `view_count` is incremented using an atomic SQL query (`view_count = view_count + 1`).
- [ ] Code is on GitHub.

**Success:** You have built a production-ready SaaS document builder!
