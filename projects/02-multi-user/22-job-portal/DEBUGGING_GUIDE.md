# 💼 Job Portal API: Learn By Building

**"Build a multi-user API where Employers post job listings, Candidates submit applications (with resumes), and Employers track the application status through a hiring pipeline."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Spam Protection (Idempotency)

```
1. Create a Job Posting.
2. Login as a Candidate.
3. Call `POST /api/jobs/:id/apply`. (Success: 201 Created).
4. Call `POST /api/jobs/:id/apply` again with the exact same payload.
5. Expected: The server MUST reject it (409 Conflict). The database `UNIQUE (job_id, candidate_id)` constraint must block the duplicate insertion.
```

### Scenario 2: Deep Ownership Validation

```
1. Employer A posts Job 1.
2. Employer B posts Job 2.
3. Candidate C applies to Job 1 (Application ID: 99).
4. Login as Employer B.
5. Call `PUT /api/applications/99/status` to move the candidate to "interviewing".
6. Expected: The server MUST reject it (403 Forbidden). Employer B does not own Job 1. The SQL `JOIN` checking `companies.employer_id` must fail.
```

### Scenario 3: State Machine Validation

```
1. Login as an Employer and find a pending application.
2. Call `PUT /api/applications/:id/status` with `{"status": "pizza"}`.
3. Expected: The server MUST reject it (400 Bad Request). The database `CHECK (status IN (...))` constraint, or your Javascript validation, must block invalid pipeline states.
```

### Scenario 4: The Closed Job

```
1. Employer A posts Job 1.
2. Employer A sets Job 1 `status = 'closed'`.
3. Candidate calls `POST /api/jobs/1/apply`.
4. Expected: The server MUST reject it (400 Bad Request) because you cannot apply to a closed job.
```

---
