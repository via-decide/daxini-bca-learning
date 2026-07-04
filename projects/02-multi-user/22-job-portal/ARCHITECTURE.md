# Job Portal (LinkedIn Jobs Clone)

## 🏗️ Architecture: Design Before Coding

**The Problem:**
Companies post Jobs. Users apply to Jobs. The company needs to move the application through a pipeline (Applied -> Interviewing -> Hired -> Rejected).

**The Solution:**
A classic Applicant Tracking System (ATS) structure. Three main entities connected by a stateful join table.

**Database Architecture:**
```text
Companies
├─ id
└─ name

Jobs
├─ id
├─ company_id
├─ title
└─ description

Applications
├─ id
├─ job_id
├─ applicant_id (User)
├─ resume_url
└─ status (ENUM: Pending, Interview, Hired, Rejected)
```
