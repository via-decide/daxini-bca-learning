# 🎓 College Management System API: Learn By Building

**"Build a multi-user API where Admins manage course catalogs, Professors grade students, and Students enroll in courses up to a maximum credit limit."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. Admin Alice creates a "Computer Science 101" course worth 4 credits.
2. She assigns Professor Pete to teach it.
3. Student Sam enrolls in CS101. Sam is only allowed to take 15 credits per semester.
4. At the end of the semester, Pete gives Sam an 'A'.
5. Sam views his transcript to see his GPA.

**What data do you need for each?**

After thinking, here's the data model:

```
Table: Users (Admins, Professors, Students)
├─ id (UUID)
├─ email (String)
├─ password_hash (String)
└─ role (Enum: 'admin', 'professor', 'student')

Table: Courses
├─ id (UUID)
├─ course_code (String - e.g., "CS101")
├─ title (String)
├─ credits (Integer)
├─ professor_id (Foreign Key -> Users - Who teaches it?)
└─ capacity (Integer)

Table: Enrollments (The Junction / Transcript)
├─ id (UUID)
├─ student_id (Foreign Key -> Users)
├─ course_id (Foreign Key -> Courses)
├─ grade (Enum: 'A', 'B', 'C', 'D', 'F', NULL initially)
└─ status (Enum: 'enrolled', 'dropped', 'completed')
```

---

### Step 2: The Multi-Constraint Problem (Enrollment)

**Question: Sam clicks "Enroll" on CS101. Before you insert the row into `Enrollments`, what must you verify?**

1. **Capacity:** Is the class full? (Total enrolled < Course Capacity).
2. **Duplicate:** Is Sam already enrolled?
3. **Credit Limit:** Will this course push Sam over the 15-credit limit?

**Bad Idea:** Trusting the frontend to hide the enroll button. Or pulling down all data into JS and doing the math asynchronously.

**Good Idea:** A Database Transaction that uses aggregate SQL functions to sum the current credits and count the current seats before allowing the INSERT.

---

### Step 3: Authorization Matrices

**Question: Who can change a grade?**

- **Student:** Can view their own grade. Cannot edit.
- **Admin:** Can view any grade. Can edit in emergencies.
- **Professor:** Can view and edit grades, BUT **ONLY** for courses they teach.

If Professor Pete teaches CS101, he cannot change the grades for Math202 (taught by Professor Mary). Your SQL `UPDATE` statement must `JOIN` the Courses table to verify ownership.

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Admin Panel (Course creation)        │  │
│  │ Professor Portal (Grading)           │  │
│  │ Student Dashboard (Enrollment & GPA) │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP requests with JWT (RBAC)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. Transactional Enrollment Engine   │  │
│  │ 2. Deep Authorization (Grading)      │  │
│  │ 3. GPA Calculation (Aggregation)     │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (PostgreSQL/MySQL)         │
│  - users, courses, enrollments tables      │
└────────────────────────────────────────────┘
```
