# Student Information System (SIS)

## 🏗️ Architecture: Design Before Coding

**The Problem:**
A university has thousands of students, hundreds of courses, and professors. A student takes many courses, and a course has many students. We need to calculate GPAs dynamically.

**The Solution:**
Use a pure Many-to-Many join table (`Enrollments`) to map Students to Courses. Ensure grades are stored as discrete values (A, B, C) and converted to GPA via a mapping function, not stored directly as raw decimals.

**Database Architecture:**
```text
Students
├─ id
└─ name

Courses
├─ id
├─ name
└─ credits (INT)

Enrollments (The Join Table)
├─ student_id
├─ course_id
├─ semester (VARCHAR)
└─ grade (VARCHAR: 'A', 'B+', etc)
```
