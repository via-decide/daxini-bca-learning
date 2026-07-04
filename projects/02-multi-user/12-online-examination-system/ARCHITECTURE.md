# Online Examination System

## 🏗️ Architecture: Design Before Coding

**The Problem:**
Students take an online multiple-choice test. The timer must be strict (server-enforced). Students cannot submit twice. Questions have different score weights.

**The Solution:**
Track the exact `start_time` in a `Test_Attempts` table. When the student submits, check if `NOW() - start_time` is greater than the allowed duration. If so, reject the late answers.

**Database Architecture:**
```text
Exams
├─ id
└─ duration_minutes

Questions
├─ id
├─ exam_id
├─ correct_option (CHAR 'A', 'B', 'C', 'D')
└─ weight (INT)

Test_Attempts
├─ id
├─ student_id
├─ exam_id
├─ start_time
└─ end_time

Answers
├─ attempt_id
├─ question_id
└─ selected_option
```
