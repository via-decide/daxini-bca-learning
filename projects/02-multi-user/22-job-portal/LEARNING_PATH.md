# 💼 Job Portal API: Learn By Building

**"Build a multi-user API where Employers post job listings, Candidates submit applications (with resumes), and Employers track the application status through a hiring pipeline."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Deep Ownership Validation** - How to write SQL queries that traverse 3 or 4 tables (Applications -> Jobs -> Companies -> Users) to verify if a user has permission to edit a specific resource.  
✅ **Multi-Entity Unique Constraints** - Using `UNIQUE(job_id, candidate_id)` to prevent spam and duplicate actions across relationships.  
✅ **Hiring Pipelines (State Machines)** - Enforcing strict status flows (`pending` -> `reviewing` -> `interviewing` -> `hired/rejected`).

---

## 📋 Project Overview

### The Problem

A Job Portal is essentially a Matchmaking Database. The hardest part is Security and Ownership.

When an Employer clicks "Reject Candidate", the frontend sends `PUT /applications/123/status`. Your backend cannot simply trust this. It must ask: "Does Application 123 belong to a Job that belongs to a Company that belongs to this specific Employer?" This requires Deep JOINs.

Additionally, candidates will click the "Apply" button multiple times. You must prevent duplicate database entries using strict constraints.

**Your job:** Build an API that strictly enforces these ownership chains and flawlessly protects against spam applications.

### Who Uses It

```
Candidate:
├─ GET /api/jobs (Finds jobs)
├─ POST /api/jobs/:id/apply (Submits resume)
└─ GET /api/applications/me (Tracks their status)

Employer:
├─ POST /api/jobs (Creates listings)
├─ GET /api/jobs/:id/applicants (Views their pipeline)
└─ PUT /api/applications/:id/status (Moves candidates through the pipeline)
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. The Spam-Proof Application

We rely on the database to throw an error if the candidate has already applied.

```pseudocode
POST /api/jobs/:id/apply:
  middlewares: [authenticateUser, requireRole(['candidate'])]
  
  // 1. Verify the job is actually open
  job = db.query("SELECT status FROM job_postings WHERE id = ?", req.params.id)
  if (!job || job.status !== 'open') return 400 "Job is no longer open."
  
  // 2. Attempt the insertion
  try:
    db.query(`
      INSERT INTO applications (id, job_id, candidate_id, resume_link)
      VALUES (UUID(), ?, ?, ?)
    `, [req.params.id, req.user.id, request.body.resume_link])
    
    return 201 "Application submitted."
    
  catch (error):
    // The UNIQUE(job_id, candidate_id) constraint throws this error
    if isUniqueViolation(error):
      return 409 "You have already applied for this job."
```

### 2. Deep Ownership Validation (Updating Status)

When the employer wants to move a candidate to "interviewing", we must verify ownership up the chain.

```pseudocode
PUT /api/applications/:id/status:
  middlewares: [authenticateUser, requireRole(['employer'])]
  
  app_id = request.params.id
  new_status = request.body.status // e.g., 'interviewing'
  
  // The magic query: Update the application ONLY IF the employer owns it.
  // We use a subquery to find jobs owned by this employer.
  result = db.query(`
    UPDATE applications 
    SET status = ? 
    WHERE id = ? 
      AND job_id IN (
        SELECT j.id FROM job_postings j
        JOIN companies c ON j.company_id = c.id
        WHERE c.employer_id = ?
      )
  `, [new_status, app_id, req.user.id])
  
  if result.affectedRows === 0:
    // Either the app doesn't exist, OR the employer doesn't own it.
    return 403 "Forbidden. You do not own this job posting."
    
  return 200 "Status updated."
```

### 3. Fetching the Pipeline (Employer View)

Employers need to see everyone who applied to their specific job.

```pseudocode
GET /api/jobs/:id/applicants:
  middlewares: [authenticateUser, requireRole(['employer'])]
  
  job_id = request.params.id
  
  // 1. Verify ownership again!
  is_owner = db.query(`
    SELECT 1 FROM job_postings j
    JOIN companies c ON j.company_id = c.id
    WHERE j.id = ? AND c.employer_id = ?
  `, [job_id, req.user.id])
  
  if (!is_owner): return 403 "Forbidden"
  
  // 2. Fetch the applicants
  applicants = db.query(`
    SELECT a.id, u.full_name, u.email, a.resume_link, a.status, a.created_at
    FROM applications a
    JOIN users u ON a.candidate_id = u.id
    WHERE a.job_id = ?
    ORDER BY a.created_at DESC
  `, job_id)
  
  return 200 { applicants: applicants }
```

---

## ✅ Before Submission

- [ ] System handles two distinct roles: `employer` and `candidate`.
- [ ] Candidates cannot apply to the same job twice (Database constraint enforced).
- [ ] Employers can only view and update applications for jobs they created (Deep JOIN validation).
- [ ] Application state changes are restricted to valid pipeline steps (`pending`, `interviewing`, etc.).
- [ ] Code is on GitHub.

**Success:** You have built a secure B2B/B2C marketplace backend!
