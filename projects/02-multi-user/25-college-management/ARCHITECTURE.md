# College Management System (Canvas/Blackboard Clone)

## 🏗️ Architecture: Design Before Coding

**The Problem:**
Professors teach Courses. Students enroll in Courses. Students submit Assignments. Professors grade them. 

**The Solution:**
A multi-layered relational model. The `Enrollments` table connects Students to Courses. The `Submissions` table connects Students to specific `Assignments`.

**Database Architecture:**
```text
Courses
├─ id
├─ professor_id
└─ title

Enrollments
├─ course_id
├─ student_id
└─ final_grade (VARCHAR)

Assignments
├─ id
├─ course_id
├─ title
└─ max_points (INT)

Submissions
├─ assignment_id
├─ student_id
├─ file_url
└─ score (INT, Nullable until graded)
```
