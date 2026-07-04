## 🛠️ Debugging & Verification

**Test 1: Enrollment Security**
- Student A is enrolled in Course 1. Student B is enrolled in Course 2.
- Student A tries to submit Assignment X (which belongs to Course 2). Must return `403 Forbidden`.

**Test 2: Grading Security**
- Ensure a Professor cannot grade a submission for a course taught by a different Professor.
