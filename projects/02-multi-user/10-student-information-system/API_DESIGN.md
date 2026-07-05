# 🎓 Student Information System: API Design

**"Build a multi-user university backend where Admins manage courses, Professors assign grades, and Students view their academic transcripts."**

---

## 🔗 API Endpoints

*(All routes require Authentication via JWT)*

**Admin Operations (Requires 'admin' role):**
```
POST   /api/courses            → Create a new course
POST   /api/users              → Register new Professors or Students
```

**Professor Operations (Requires 'professor' role):**
```
GET    /api/professor/courses  → View courses I am teaching
GET    /api/courses/:id/roster → View the list of students in my course
PUT    /api/enrollments/:id    → Assign a grade to a student
```

**Student Operations (Requires 'student' role):**
```
GET    /api/courses            → List all available courses
POST   /api/enrollments        → Enroll in a course
GET    /api/student/transcript → View grades and GPA
```

---

## 📦 Request/Response Examples

### 1. Enroll in a Course (Student)

**Request:**
```json
POST /api/enrollments
{
  "course_id": "course-101",
  "semester": "Fall 2026"
}
```

**Response (201):**
```json
{
  "message": "Successfully enrolled",
  "enrollment": {
    "id": "enroll-999",
    "student_id": "student-alice",
    "course_id": "course-101",
    "semester": "Fall 2026",
    "grade": null
  }
}
```

### 2. Grade a Student (Professor)

**Request:**
```json
PUT /api/enrollments/enroll-999
{
  "grade": "A"
}
```

**Response (200):**
```json
{
  "message": "Grade updated",
  "enrollment": {
    "id": "enroll-999",
    "grade": "A"
  }
}
```

### 3. Fetch Transcript (Student)

**Request:**
```http
GET /api/student/transcript HTTP/1.1
```

**Response (200):**
```json
{
  "student": {
    "id": "student-alice",
    "name": "Alice Johnson"
  },
  "academic_summary": {
    "total_credits_earned": 12,
    "cumulative_gpa": 3.75
  },
  "course_history": [
    {
      "course_name": "Intro to Programming",
      "credits": 4,
      "semester": "Fall 2026",
      "professor_name": "Dr. Smith",
      "grade": "A"
    },
    {
      "course_name": "Calculus I",
      "credits": 4,
      "semester": "Fall 2026",
      "professor_name": "Dr. Jones",
      "grade": "B"
    }
  ]
}
```
*(Notice how the backend does all the complex joining and mathematical aggregation. The frontend just displays the JSON).*

---

## ⚠️ Error Responses

```json
// 403 Forbidden (A Professor tries to grade a student who is not in THEIR class)
{ "error": "You do not have permission to grade this student." }

// 409 Conflict (A Student tries to enroll in the exact same course twice)
{ "error": "You are already enrolled in this course for this semester." }

// 400 Bad Request (Professor tries to assign a grade of 'Z')
{ "error": "Invalid grade. Must be A, B, C, D, or F." }
```
