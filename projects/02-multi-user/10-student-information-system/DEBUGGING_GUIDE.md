# 🎓 Student Information System: Learn By Building

**"Build a multi-user university backend where Admins manage courses, Professors assign grades, and Students view their academic transcripts."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Professor Validation Test

```
1. Create Course 1 taught by Professor Smith.
2. Create Course 2 taught by Professor Jones.
3. Enroll Student Alice in Course 1.
4. Login as Professor Jones.
5. Attempt to `PUT /api/enrollments/:id` to assign Alice an 'A' for Course 1.
6. Expected: Server MUST reject it with a 403 Forbidden. Professor Jones is trying to grade a student in a class he doesn't teach!
```

### Scenario 2: Double Enrollment Constraint

```
1. Enroll Student Alice in "Intro to DBs" for "Fall 2026".
2. Attempt to enroll Alice in "Intro to DBs" for "Fall 2026" again.
3. Expected: Server MUST reject with a 409 Conflict (The `UNIQUE` DB constraint should catch this).
4. Attempt to enroll Alice in "Intro to DBs" for "Spring 2027".
5. Expected: Server should ALLOW it (retaking a class in a different semester).
```

### Scenario 3: GPA Accuracy (The Math Test)

```
1. Create a 4-credit course and assign Alice an 'A' (4.0).
2. Create a 3-credit course and assign Alice a 'C' (2.0).
3. Create a 3-credit course and assign Alice a 'B' (3.0).
4. Create a 4-credit course, but leave the grade `NULL` (in progress).
5. GET `/api/student/transcript`.
6. Calculate Expected GPA manually: 
   (4 * 4.0) + (3 * 2.0) + (3 * 3.0) = 16 + 6 + 9 = 31 total grade points.
   Total credits graded: 4 + 3 + 3 = 10.
   GPA = 31 / 10 = 3.1.
7. Expected: The API should return `cumulative_gpa: 3.1`. The in-progress course MUST be ignored in the calculation.
```

### Scenario 4: Role-Based Routing

```
1. Login as a Student.
2. Attempt to `POST /api/courses` to create a new class.
3. Expected: Server MUST reject with 403 Forbidden.
```

---
