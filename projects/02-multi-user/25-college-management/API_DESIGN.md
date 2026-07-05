# 🎓 College Management System API: API Design

**"Build a multi-user API where Admins manage course catalogs, Professors grade students, and Students enroll in courses up to a maximum credit limit."**

---

## 🔗 API Endpoints

*(All routes require Authentication via JWT)*

**Admin Operations (Requires 'admin' role):**
```
POST   /api/courses             → Create a new course in the catalog
PUT    /api/courses/:id         → Update course (e.g., assign a professor)
```

**Professor Operations (Requires 'professor' role):**
```
GET    /api/courses/my-classes  → View courses I am assigned to teach
GET    /api/courses/:id/roster  → View enrolled students (Must own the course)
PUT    /api/enrollments/:id/grade → Assign a grade to a student (Must own the course)
```

**Student Operations (Requires 'student' role):**
```
GET    /api/courses             → Search the course catalog
POST   /api/courses/:id/enroll  → Enroll in a class (Validates limits/capacity)
GET    /api/students/me/transcript → View grades and GPA
```

---

## 📦 Request/Response Examples

### 1. Enroll in a Course (Student)

This endpoint validates capacity, credit limits, and prevents double enrollment.

**Request:**
```json
POST /api/courses/crs-123/enroll
{}
```

**Response (201):**
```json
{
  "message": "Successfully enrolled in CS101",
  "enrollment_id": "enr-999"
}
```

### 2. View Course Roster (Professor)

**Request:**
```http
GET /api/courses/crs-123/roster HTTP/1.1
```

**Response (200):**
```json
{
  "course_code": "CS101",
  "capacity_filled": "25/30",
  "students": [
    {
      "enrollment_id": "enr-999",
      "student_name": "Sam Student",
      "grade": null
    }
  ]
}
```

### 3. Assign Grade (Professor)

**Request:**
```json
PUT /api/enrollments/enr-999/grade
{
  "grade": "A"
}
```

**Response (200):**
```json
{
  "message": "Grade saved successfully."
}
```

### 4. View Transcript & GPA (Student)

The backend calculates the GPA dynamically using an aggregation query.

**Request:**
```http
GET /api/students/me/transcript HTTP/1.1
```

**Response (200):**
```json
{
  "student_name": "Sam Student",
  "total_credits_earned": 12,
  "cumulative_gpa": 3.75,
  "courses": [
    {
      "course_code": "CS101",
      "credits": 4,
      "grade": "A"
    }
  ]
}
```

---

## ⚠️ Error Responses

```json
// 400 Bad Request (Student tries to enroll, but course is full)
{ "error": "This course has reached maximum capacity." }

// 403 Forbidden (Student tries to take 18 credits when limit is 15)
{ "error": "Enrollment blocked: This course exceeds your 15-credit limit." }

// 403 Forbidden (Professor tries to grade a student in a class they don't teach)
{ "error": "You are not authorized to assign grades for this course." }
```
