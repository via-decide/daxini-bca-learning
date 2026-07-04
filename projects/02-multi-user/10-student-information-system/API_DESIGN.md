## 🔌 API Design: Plan Before Coding

### 1. Enroll Student
**POST `/api/enrollments`**
- **Logic**: Ensure the student isn't already taking the same course in the same semester. Ensure the course isn't full.

### 2. Get Student Transcript (Calculate GPA)
**GET `/api/students/:id/transcript`**
- **Logic**: 
  1. Fetch all enrollments for student.
  2. In code, map grade 'A' to 4.0, 'B' to 3.0, etc.
  3. GPA = Sum(GradeValue * Credits) / Sum(Credits).
