# 📄 SaaS Resume Builder API: Learn By Building

**"Build a multi-user API where Users create multiple versions of their resumes with distinct sections (Education, Experience), and generate public shareable links that track view counts."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Transaction Rollback (Incomplete Resume)

```
1. Create a `POST /api/resumes` route that handles a JSON payload with `experiences` and `educations`.
2. Inside your database transaction, INTENTIONALLY throw an error right after inserting the experiences, but before inserting the educations.
3. Send a valid POST request.
4. Check the Database.
5. Expected: The transaction MUST rollback. There should be NO new row in the `resumes` table, and NO new rows in `resume_experiences`. The entire resume creation must fail together.
```

### Scenario 2: Atomic View Counter (Concurrency Test)

```
1. User publishes a resume. `view_count` is 0.
2. Open Postman Runner, JMeter, or write a simple script to send 100 concurrent `GET /p/:slug` requests to the public link at the exact same time.
3. Expected: The `view_count` MUST be exactly 100 in the database. If it is 97 or 42, your SQL update is not atomic (you are likely calculating `view_count + 1` in Javascript instead of SQL).
```

### Scenario 3: Privacy Check (Unpublishing)

```
1. User publishes a resume.
2. Recruiter fetches `GET /p/:slug` successfully.
3. User calls `PUT /api/resumes/:id/publish` with `is_published: false`.
4. Recruiter fetches `GET /p/:slug` again.
5. Expected: Server MUST return 404 Not Found or 403 Forbidden. The data must not leak once unpublished.
```

### Scenario 4: Deep Data Updates

```
1. User has a resume with Experience A.
2. User updates the resume via `PUT /api/resumes/:id` sending a payload that contains Experience B and Experience C (omitting Experience A).
3. Expected: The backend should delete Experience A from the database, and insert B and C, so the database exactly matches the frontend JSON state.
```

---
