# 📄 SaaS Resume Builder API: API Design

**"Build a multi-user API where Users create multiple versions of their resumes with distinct sections (Education, Experience), and generate public shareable links that track view counts."**

---

## 🔗 API Endpoints

**Authenticated User Operations (Requires JWT):**
```
GET    /api/resumes            → List all my resumes
POST   /api/resumes            → Create a new resume (accepts nested JSON)
GET    /api/resumes/:id        → View a specific resume (to load into the editor)
PUT    /api/resumes/:id        → Update a specific resume
PUT    /api/resumes/:id/publish → Toggle public visibility and generate slug
```

**Public Operations (No Auth Required):**
```
GET    /p/:slug                → Fetch the public resume data (Increments view_count!)
```

---

## 📦 Request/Response Examples

### 1. Create a Full Resume (User)

The frontend sends a massive nested object. The backend handles splitting it into tables.

**Request:**
```json
POST /api/resumes
{
  "title": "Software Engineer 2026",
  "experiences": [
    {
      "company": "TechCorp",
      "role": "Junior Dev",
      "start_date": "2024-01-01",
      "end_date": "2026-01-01",
      "description": "Built cool things."
    }
  ],
  "educations": [
    {
      "institution": "State University",
      "degree": "B.S. Computer Science",
      "graduation_year": 2023
    }
  ]
}
```

**Response (201):**
```json
{
  "message": "Resume created successfully",
  "resume_id": "res-123",
  "view_count": 0,
  "is_published": false
}
```

### 2. Publish Resume (User)

**Request:**
```json
PUT /api/resumes/res-123/publish
{
  "is_published": true
}
```

**Response (200):**
```json
{
  "message": "Resume published",
  "public_url": "https://api.resumebuilder.com/p/ursula-smith-swe-987"
}
```

### 3. View Public Resume (Public/Recruiter)

No authentication required. The backend automatically increments the `view_count`.

**Request:**
```http
GET /p/ursula-smith-swe-987 HTTP/1.1
```

**Response (200):**
```json
{
  "title": "Software Engineer 2026",
  "owner_name": "Ursula Smith",
  "experiences": [
    {
      "company": "TechCorp",
      "role": "Junior Dev",
      "start_date": "2024-01-01",
      "end_date": "2026-01-01",
      "description": "Built cool things."
    }
  ],
  "educations": [
    {
      "institution": "State University",
      "degree": "B.S. Computer Science",
      "graduation_year": 2023
    }
  ]
}
```

---

## ⚠️ Error Responses

```json
// 404 Not Found (Recruiter tries to view a link that is unpublished or doesn't exist)
{ "error": "This resume is not available." }

// 400 Bad Request (User submits an experience without a company name)
{ "error": "Validation failed: 'experiences[0].company' is required." }

// 403 Forbidden (User tries to edit a resume belonging to someone else)
{ "error": "You do not have permission to modify this document." }
```
