# 🎓 Student Information System: Learn By Building

**"Build a multi-user university backend where Admins manage courses, Professors assign grades, and Students view their academic transcripts."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. An Admin creates a course called "Intro to Programming".
2. Professor Smith is assigned to teach "Intro to Programming".
3. Student Alice enrolls in "Intro to Programming".
4. Professor Smith gives Alice an 'A' for the course.
5. Alice views her transcript.

**What data do you need for each?**

After thinking, here's the data model:

```
Table: Users
├─ id (UUID)
├─ email (String)
├─ password_hash (String)
└─ role (Enum: 'admin', 'professor', 'student')

Table: Courses
├─ id (UUID)
├─ name (String)
├─ credits (Integer)
└─ professor_id (Foreign Key -> Users WHERE role='professor')

Table: Enrollments (The Junction Table)
├─ id (UUID)
├─ student_id (Foreign Key -> Users WHERE role='student')
├─ course_id (Foreign Key -> Courses)
├─ semester (String - e.g., 'Fall 2026')
└─ grade (Enum: 'A', 'B', 'C', 'D', 'F', NULL)
```

---

### Step 2: Many-to-Many Relationships

A student takes **Many** courses. A course has **Many** students.
You cannot just put a `course_id` on the Student table (because they take many courses). You cannot put a `student_id` on the Course table (because there are many students).

**The Solution: The Junction Table (Enrollments)**
To connect two tables in a Many-to-Many relationship, you create a third table in the middle. The `Enrollments` table links one student to one course. If Alice takes 5 courses, she has 5 rows in the `Enrollments` table. This table is also the perfect place to store the `grade`.

---

### Step 3: GPA Calculation (Complex Aggregation)

When Alice views her transcript, the frontend wants to display her GPA.
GPA = Sum of (Grade Value * Course Credits) / Total Credits.

**Bad Idea:** The server sends Alice's grades ('A', 'B') to the frontend, and the frontend writes a massive `switch` statement to convert 'A' to 4.0, 'B' to 3.0, and does the math.
**Good Idea:** Use SQL `CASE` statements to calculate it dynamically in the database, or use a lookup table, so the backend just sends `{ gpa: 3.5 }`.

```sql
-- Using a CASE statement in SQL to map letters to numbers
SELECT 
  SUM(
    CASE 
      WHEN grade = 'A' THEN 4.0 
      WHEN grade = 'B' THEN 3.0 
      WHEN grade = 'C' THEN 2.0 
      WHEN grade = 'D' THEN 1.0 
      ELSE 0.0 
    END * c.credits
  ) / SUM(c.credits) as gpa
FROM enrollments e
JOIN courses c ON e.course_id = c.id
WHERE e.student_id = 'alice-123' AND e.grade IS NOT NULL;
```

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Admin (Manage Courses/Users)         │  │
│  │ Professor (Gradebook)                │  │
│  │ Student (Transcript/Enrollment)      │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP requests with JWT (RBAC)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. RBAC (Role-Based Routing)         │  │
│  │ 2. Grade & GPA Calculation Engine    │  │
│  │ 3. Enrollment Validation             │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (PostgreSQL/MySQL)         │
│  - users, courses, enrollments tables      │
└────────────────────────────────────────────┘
```
