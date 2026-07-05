# 📝 Form Builder API (Typeform Clone): API Design

**"Build a dynamic form engine where users can define custom questions, share links, and collect structured responses."**

---

## 🔗 API Endpoints

### Authentication

```
POST   /api/auth/register     → Create account
POST   /api/auth/login        → Login, get JWT token
```

### Form Builder (Requires JWT Authentication)

```
GET    /api/forms             → List all forms for logged-in user
POST   /api/forms             → Create new empty form
GET    /api/forms/:id         → Get form builder details (includes unpublished changes)
PATCH  /api/forms/:id         → Update title, description, or publish status
DELETE /api/forms/:id         → Delete form completely
```

### Questions (Requires JWT Authentication)

```
POST   /api/forms/:id/questions      → Add a new question
PATCH  /api/questions/:id            → Update question text, type, options
DELETE /api/questions/:id            → Remove question
```

### Public Access (No Authentication Needed)

```
GET    /api/published-forms/:id      → Get form details to render it (only if is_published=true)
POST   /api/published-forms/:id/submit → Submit a response payload
```

### Analytics (Requires JWT Authentication)

```
GET    /api/forms/:id/submissions    → List all submissions with their answers
```

---

## 📦 Request/Response Examples

### 1. Create a Question

**Request:**
```json
POST /api/forms/uuid-form-1/questions
Authorization: Bearer <jwt_token>
{
  "question_text": "How did you hear about us?",
  "type": "radio",
  "options": ["Google", "Twitter", "Friend"],
  "is_required": true,
  "position": 1
}
```

**Response (201):**
```json
{
  "id": "uuid-q-1",
  "form_id": "uuid-form-1",
  "question_text": "How did you hear about us?",
  "type": "radio",
  "options": ["Google", "Twitter", "Friend"],
  "is_required": true,
  "position": 1
}
```

### 2. Submit Answers (Public)

**Request:**
```json
POST /api/published-forms/uuid-form-1/submit
{
  "answers": [
    {
      "question_id": "uuid-q-1",
      "value": "Twitter"
    },
    {
      "question_id": "uuid-q-2",
      "value": "The product is great, but needs dark mode."
    }
  ]
}
```

**Response (201):**
```json
{
  "message": "Submission successful",
  "submission_id": "uuid-sub-1"
}
```

### 3. Fetch Submissions (Creator)

**Request:**
```json
GET /api/forms/uuid-form-1/submissions
Authorization: Bearer <jwt_token>
```

**Response (200):**
```json
{
  "form_title": "Customer Feedback",
  "total_submissions": 1,
  "submissions": [
    {
      "id": "uuid-sub-1",
      "submitted_at": "2026-08-01T14:30:00Z",
      "answers": [
        {
          "question": "How did you hear about us?",
          "value": "Twitter"
        },
        {
          "question": "Any feedback?",
          "value": "The product is great, but needs dark mode."
        }
      ]
    }
  ]
}
```

---

## ⚠️ Error Responses

```json
// 400 Bad Request (Validation failure)
{ "error": "Question 'How did you hear about us?' is required but missing." }

// 403 Forbidden (Form is not published)
{ "error": "This form is currently closed for submissions." }

// 404 Not Found (Invalid ID or not belonging to user)
{ "error": "Form not found" }
```
