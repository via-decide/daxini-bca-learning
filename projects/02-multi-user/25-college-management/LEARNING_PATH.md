# 🎓 College Management System API: Learn By Building

**"Build a multi-user API where Admins manage course catalogs, Professors grade students, and Students enroll in courses up to a maximum credit limit."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Multi-Constraint Validation** - Writing transactions that must verify multiple independent rules (Capacity Limits AND Credit Limits) before allowing an `INSERT`.  
✅ **Weighted SQL Aggregations** - Using `SUM()` and math functions across `JOIN`ed tables to dynamically calculate derived values (like a GPA) without storing them permanently.  
✅ **Deep Authorization** - Using `JOIN`s in an `UPDATE` statement to ensure a user only modifies records tied to their specific Foreign Key (Professor -> Course -> Enrollment).

---

## 📋 Project Overview

### The Problem

A University has strict academic rules. 
1. Students cannot enroll in a class if it is full. 
2. Students cannot enroll if it pushes them over a 15-credit limit.
3. Professors can only grade their own students.

When a student clicks "Enroll", your API cannot just insert a row. It must gather data from multiple tables, perform math, check two separate constraints, and if everything passes, insert the row safely under concurrent load. 

**Your job:** Build an API that handles multi-constraint transactions perfectly, protects academic integrity via strict role checks, and dynamically calculates a weighted GPA.

### Who Uses It

```
Admin:
├─ POST /api/courses (Builds the catalog)

Professor:
├─ GET /api/courses/my-classes (Views schedule)
└─ PUT /api/enrollments/:id/grade (Assigns grades securely)

Student:
├─ POST /api/courses/:id/enroll (Registers for class)
└─ GET /api/students/me/transcript (Checks GPA)
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. The Multi-Constraint Enrollment Transaction

This requires checking both the Course table (capacity) and the Student's existing enrollments (credits) in one transactional block.

```pseudocode
POST /api/courses/:id/enroll:
  middlewares: [authenticateUser, requireRole(['student'])]
  
  target_course_id = request.params.id
  MAX_CREDITS = 15
  
  db.execute("BEGIN TRANSACTION")
  
  try:
    // 1. Get the course details (Credits and Capacity)
    course = db.query("SELECT credits, capacity FROM courses WHERE id = ?", target_course_id)
    if (!course) throw new Error("Course not found.")
    
    // 2. Check Capacity (How many seats are taken?)
    current_seats = db.query(`
      SELECT COUNT(*) as taken FROM enrollments 
      WHERE course_id = ? AND status = 'enrolled'
    `, target_course_id)
    
    if (current_seats.taken >= course.capacity):
      throw new Error("Course is full.")
      
    // 3. Check Credit Limit (How many credits does the student currently have?)
    current_credits = db.query(`
      SELECT SUM(c.credits) as total 
      FROM enrollments e
      JOIN courses c ON e.course_id = c.id
      WHERE e.student_id = ? AND e.status = 'enrolled'
    `, req.user.id)
    
    // Note: COALESCE handles the case where they have 0 credits
    total = (current_credits.total || 0) + course.credits
    
    if (total > MAX_CREDITS):
      throw new Error(`Enrolling exceeds limit. You would have ${total}/${MAX_CREDITS} credits.`)
      
    // 4. Everything passed! Insert the enrollment.
    // The UNIQUE(student_id, course_id) constraint will throw if they are already enrolled.
    db.query(`
      INSERT INTO enrollments (id, student_id, course_id)
      VALUES (UUID(), ?, ?)
    `, [req.user.id, target_course_id])
    
    db.execute("COMMIT")
    return 201 "Enrolled successfully."
    
  catch (error):
    db.execute("ROLLBACK")
    return 400 error.message
```

### 2. Deep Authorization for Grading

A professor wants to grade an enrollment. We must ensure they teach the class.

```pseudocode
PUT /api/enrollments/:id/grade:
  middlewares: [authenticateUser, requireRole(['professor'])]
  
  target_enroll_id = request.params.id
  new_grade = request.body.grade // 'A', 'B', etc.
  
  // The UPDATE with a JOIN condition (Subquery)
  result = db.query(`
    UPDATE enrollments 
    SET grade = ?, status = 'completed'
    WHERE id = ? 
      AND course_id IN (
        SELECT id FROM courses WHERE professor_id = ?
      )
  `, [new_grade, target_enroll_id, req.user.id])
  
  if result.affectedRows === 0:
    return 403 "Forbidden. You do not teach this course."
    
  return 200 "Grade saved."
```

### 3. Calculating the Transcript GPA (Math in Code)

```pseudocode
GET /api/students/me/transcript:
  middlewares: [authenticateUser, requireRole(['student'])]
  
  // 1. Fetch completed courses
  completed = db.query(`
    SELECT c.course_code, c.credits, e.grade 
    FROM enrollments e
    JOIN courses c ON e.course_id = c.id
    WHERE e.student_id = ? AND e.status = 'completed'
  `, req.user.id)
  
  // 2. Map grades to points
  grade_map = { 'A': 4.0, 'B': 3.0, 'C': 2.0, 'D': 1.0, 'F': 0.0 }
  
  total_points = 0
  total_credits = 0
  
  for course in completed:
    if course.grade:
      total_credits += course.credits
      total_points += (grade_map[course.grade] * course.credits)
      
  gpa = total_credits > 0 ? (total_points / total_credits) : 0.0
  
  return 200 {
    cumulative_gpa: gpa,
    courses: completed
  }
```

---

## ✅ Before Submission

- [ ] System handles `admin`, `professor`, and `student` roles securely.
- [ ] Enrollment transaction checks both `capacity` and `credit limit`.
- [ ] Students cannot enroll in the exact same course twice (Unique constraint).
- [ ] Professors can only grade students in courses they are assigned to (Deep validation).
- [ ] GPA is calculated dynamically using a weighted average.
- [ ] Code is on GitHub.

**Success:** You have built an academically rigorous college backend!
