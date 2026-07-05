# 💼 Job Portal API: API Design

**"Build a multi-user API where Employers post job listings, Candidates submit applications (with resumes), and Employers track the application status through a hiring pipeline."**

---

## 🔗 API Endpoints

*(Routes require Authentication via JWT unless marked Public)*

**Public / Candidate Operations:**
```
GET    /api/jobs               → (Public) Search open job listings
POST   /api/jobs/:id/apply     → (Candidate) Submit an application for a job
GET    /api/applications/me    → (Candidate) View status of my submitted applications
```

**Employer Operations (Requires 'employer' role):**
```
POST   /api/companies          → Create my company profile
POST   /api/jobs               → Post a new job listing
GET    /api/jobs/:id/applicants→ View all candidates who applied to this job
PUT    /api/applications/:id/status → Move a candidate through the hiring pipeline
```

---

## 📦 Request/Response Examples

### 1. Search Jobs (Public)

**Request:**
```http
GET /api/jobs?search=Engineer HTTP/1.1
```

**Response (200):**
```json
{
  "results": [
    {
      "job_id": "job-123",
      "company": "SpaceX",
      "title": "Rocket Engineer",
      "salary_range": "$120k - $150k",
      "posted_at": "2026-10-15T08:00:00Z"
    }
  ]
}
```

### 2. Apply for a Job (Candidate)

**Request:**
```json
POST /api/jobs/job-123/apply
{
  "resume_link": "https://resumes.com/chris-engineer.pdf",
  "cover_letter": "I love rockets."
}
```

**Response (201):**
```json
{
  "message": "Application submitted successfully",
  "application": {
    "id": "app-999",
    "status": "pending"
  }
}
```

### 3. Update Pipeline Status (Employer)

The employer reviews the resume and decides to interview Chris.

**Request:**
```json
PUT /api/applications/app-999/status
{
  "status": "interviewing"
}
```

**Response (200):**
```json
{
  "message": "Candidate moved to interviewing phase."
}
```

---

## ⚠️ Error Responses

```json
// 409 Conflict (Candidate clicks Apply twice)
{ "error": "You have already applied for this position." }

// 403 Forbidden (Employer tries to view applicants for a job posted by a different company)
{ "error": "You do not have permission to view this job's pipeline." }

// 400 Bad Request (Employer tries to set status to 'sleeping')
{ "error": "Invalid status. Allowed values: pending, reviewing, interviewing, rejected, hired." }
```
