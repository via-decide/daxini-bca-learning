# 🎓 College Management System API: Learn By Building

**"Build a multi-user API where Admins manage course catalogs, Professors grade students, and Students enroll in courses up to a maximum credit limit."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Credit Limit Validation

```
1. Set the maximum allowed credits per student to 15.
2. Student Sam enrolls in 12 credits of courses successfully.
3. Sam attempts to enroll in a 4-credit course (Total would be 16).
4. Expected: The API MUST reject the enrollment (403 Forbidden). The Database Transaction should correctly `SUM()` the existing credits, add 4, see it exceeds 15, and `ROLLBACK`.
```

### Scenario 2: The Capacity Race Condition

```
1. Admin creates a Yoga course with a `capacity` of 1.
2. Open two Postman tabs. Log in as Student A and Student B.
3. Both students send `POST /api/courses/yoga-id/enroll` at the exact same millisecond.
4. Expected: One student gets a 201 Created. The other MUST get a 400 Bad Request ("Course full"). The transaction must lock the table or row to prevent 2 students from taking the last seat.
```

### Scenario 3: Professor Authorization Check

```
1. Professor Pete teaches Math101.
2. Professor Mary teaches Science101.
3. Student Sam is enrolled in both.
4. Login as Pete.
5. Attempt to send `PUT /api/enrollments/<Sam's Science101 ID>/grade`.
6. Expected: The server MUST return 403 Forbidden. The SQL `JOIN` must verify that Pete is the `professor_id` on the `Courses` table linked to that specific enrollment.
```

### Scenario 4: GPA Calculation

```
1. Student Sam takes Math (4 credits) and gets an 'A' (4.0).
2. Student Sam takes Gym (2 credits) and gets a 'C' (2.0).
3. Call `GET /api/students/me/transcript`.
4. Expected: The GPA should not be 3.0 (the simple average of 4.0 and 2.0). It MUST be a *weighted* average based on credits: `((4 * 4) + (2 * 2)) / 6 = 20 / 6 = 3.33`.
```

---
