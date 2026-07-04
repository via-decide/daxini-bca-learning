# Job Portal (LinkedIn Jobs Clone)

## 🏗️ Architecture: Design Before Coding

**The Problem:**
Employers post jobs. Candidates apply. Jobs have complex filters (Remote vs On-site, Salary ranges). Candidates need to upload PDF resumes.

**The Solution:**
Filter ranges using standard inequality queries. For PDFs, NEVER store files in the database. Upload files to a blob storage (AWS S3, or local disk for dev) and store the URL string in the database.

**Database Architecture:**
```text
Jobs
├─ id
├─ company_id
├─ title
├─ is_remote (BOOLEAN)
├─ min_salary (INT)
└─ max_salary (INT)

Applications
├─ id
├─ job_id
├─ candidate_id
├─ resume_url (VARCHAR)
└─ status (ENUM: Pending, Rejected, Interview)
```
