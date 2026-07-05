# 💼 Job Portal API: Learn By Building

**"Build a multi-user API where Employers post job listings, Candidates submit applications (with resumes), and Employers track the application status through a hiring pipeline."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. Employer Elon creates a company profile for "SpaceX".
2. Elon posts a job listing for "Rocket Engineer".
3. Candidate Chris searches for "Engineer" and finds the job.
4. Chris applies by submitting a link to his resume.
5. Elon sees Chris's application in the "Pending" column and moves it to "Interviewing".

**What data do you need for each?**

After thinking, here's the data model:

```
Table: Users (Employers, Candidates)
├─ id (UUID)
├─ email (String)
├─ password_hash (String)
└─ role (Enum: 'employer', 'candidate')

Table: Companies
├─ id (UUID)
├─ employer_id (Foreign Key -> Users - Who owns this company profile?)
├─ name (String)
└─ description (String)

Table: Job_Postings
├─ id (UUID)
├─ company_id (Foreign Key -> Companies)
├─ title (String)
├─ description (String)
├─ salary_range (String)
└─ status (Enum: 'open', 'closed')

Table: Applications (The Transaction)
├─ id (UUID)
├─ job_id (Foreign Key -> Job_Postings)
├─ candidate_id (Foreign Key -> Users)
├─ resume_link (String)
└─ status (Enum: 'pending', 'reviewing', 'interviewing', 'rejected', 'hired')
```

---

### Step 2: Preventing Spam (The Application Constraint)

**Question: Chris really wants the Rocket Engineer job. He clicks "Apply" 50 times in a row. How do you prevent your database from filling up with 50 duplicate applications?**

**Bad Idea:** Trusting the frontend to disable the "Apply" button after one click. (Chris can just use Postman to bypass the frontend).

**Good Idea:** Enforce a Unique Constraint in the Database on `(job_id, candidate_id)`. This guarantees a candidate can only apply to a specific job exactly once.

---

### Step 3: Authorization (Who can see what?)

**Question: When an employer wants to view the applications for a job, how do you verify they actually own that job posting?**

**Bad Idea:** `SELECT * FROM applications WHERE job_id = ?` (If Employer Bob guesses the `job_id` of Elon's job, Bob can steal all the candidates).

**Good Idea:** You must perform a SQL `JOIN` up the chain to verify ownership.
`Applications -> Job_Postings -> Companies -> Employer_ID`.
If the `Employer_ID` doesn't match the currently logged-in user, return `403 Forbidden`.

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Candidate Board (Search & Apply)     │  │
│  │ Employer Kanban (Manage Pipeline)    │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP requests with JWT (RBAC)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. Role-Based Route Guards           │  │
│  │ 2. Deep Ownership Validation (JOINs) │  │
│  │ 3. State Machine (Pipeline Updates)  │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (PostgreSQL/MySQL)         │
│  - users, companies, jobs, applications    │
└────────────────────────────────────────────┘
```
