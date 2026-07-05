# 🎓 Student Information System: Learn By Building

**"Build a multi-user university backend where Admins manage courses, Professors assign grades, and Students view their academic transcripts."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Many-to-Many Relationships** - Using a Junction Table (`enrollments`) to connect two tables (`users` and `courses`) that have a many-to-many relationship.  
✅ **Deep Authorization** - Validating not just that a user is a 'Professor', but that they are the *specific* Professor authorized to modify a specific row.  
✅ **SQL Conditional Math (`CASE`)** - Using SQL to dynamically convert text strings ('A', 'B') into mathematical weights (4.0, 3.0) during aggregation queries.  

---

## 📋 Project Overview

### The Problem

A university system is the classic example of a heavily relational, heavily restricted database. 
Data is deeply interconnected: Students take many courses, Courses have many students. This requires a Junction Table.

Furthermore, authorization is complex. A Professor isn't just an admin. They have localized authority. They can grade students in *their* classes, but if they try to change a grade in a class taught by someone else, the database must fiercely reject them.

**Your job:** Build a deeply relational database schema and secure it with strict role-based and ownership-based validation logic.

### Who Uses It

```
Admin:
├─ POST /api/courses (Creates a class, assigns a professor)

Professor:
├─ GET /api/courses/:id/roster (Sees who is in their class)
└─ PUT /api/enrollments/:id (Assigns a grade)

Student:
├─ POST /api/enrollments (Registers for a class)
└─ GET /api/student/transcript (Views their GPA)
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. The Junction Table (Enrollment)

```pseudocode
POST /api/enrollments:
  middlewares: [authenticateUser, requireRole(['student'])]
  
  course_id = request.body.course_id
  semester = request.body.semester
  
  // 1. Verify the course actually exists
  course = db.query("SELECT id FROM courses WHERE id = ?", course_id)
  if !course: return 404 "Course not found"
  
  // 2. Insert into the Junction Table
  try:
    db.query(`
      INSERT INTO enrollments (id, student_id, course_id, semester)
      VALUES (UUID(), ?, ?, ?)
    `, [req.user.id, course_id, semester])
    
    return 201 "Enrolled successfully!"
  catch (error):
    // Our DB UNIQUE constraint (student_id, course_id, semester) will block duplicates
    return 409 "You are already enrolled in this class for this semester."
```

### 2. Deep Authorization (Grading)

This is the most critical security check in the application.

```pseudocode
PUT /api/enrollments/:id:
  middlewares: [authenticateUser, requireRole(['professor'])]
  
  new_grade = request.body.grade // e.g., 'A'
  enrollment_id = request.params.id
  
  // 1. We must verify this Professor teaches this specific course!
  // We join enrollments to courses to check the professor_id.
  enrollment = db.query(`
    SELECT c.professor_id 
    FROM enrollments e
    JOIN courses c ON e.course_id = c.id
    WHERE e.id = ?
  `, enrollment_id)
  
  if !enrollment: return 404 "Enrollment not found"
  
  // 2. THE SECURITY CHECK
  if enrollment.professor_id != req.user.id:
    return 403 "Forbidden: You do not teach this course."
    
  // 3. Update the grade
  db.query("UPDATE enrollments SET grade = ? WHERE id = ?", [new_grade, enrollment_id])
  
  return 200 "Grade saved"
```

### 3. The Transcript (Complex Aggregation)

```pseudocode
GET /api/student/transcript:
  middlewares: [authenticateUser, requireRole(['student'])]
  
  // Query 1: Get the list of all courses taken
  history = db.query(`
    SELECT 
      c.name as course_name, 
      c.credits, 
      e.semester, 
      e.grade,
      p.full_name as professor_name
    FROM enrollments e
    JOIN courses c ON e.course_id = c.id
    JOIN users p ON c.professor_id = p.id
    WHERE e.student_id = ?
    ORDER BY e.semester DESC
  `, req.user.id)
  
  // Query 2: Let SQL calculate the GPA
  // (Syntax may vary slightly by database engine)
  stats = db.query(`
    SELECT 
      SUM(c.credits) as total_credits,
      SUM(
        CASE 
          WHEN e.grade = 'A' THEN 4.0 
          WHEN e.grade = 'B' THEN 3.0 
          WHEN e.grade = 'C' THEN 2.0 
          WHEN e.grade = 'D' THEN 1.0 
          ELSE 0.0 
        END * c.credits
      ) / SUM(c.credits) as gpa
    FROM enrollments e
    JOIN courses c ON e.course_id = c.id
    WHERE e.student_id = ? AND e.grade IS NOT NULL
  `, req.user.id)
  
  return 200 {
    academic_summary: {
      total_credits_earned: stats.total_credits,
      cumulative_gpa: stats.gpa
    },
    course_history: history
  }
```

---

## ✅ Before Submission

- [ ] System supports Admins, Professors, and Students via JWT Roles.
- [ ] Database uses a Many-to-Many Junction table (`enrollments`) to link students to courses.
- [ ] Deep Authorization is implemented: A professor can only grade students in *their* assigned courses.
- [ ] The Transcript endpoint calculates GPA accurately using weighted credits, ignoring `NULL` (in-progress) grades.
- [ ] Code is on GitHub.

**Success:** You have built a highly relational university backend!
