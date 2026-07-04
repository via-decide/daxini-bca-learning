## 🔌 API Design: Plan Before Coding

### 1. Submit Assignment
**POST `/api/assignments/:id/submit`**
- **Logic**: 
  1. Check if the User is in the `enrollments` table for the Assignment's `course_id`.
  2. Insert into `submissions`.

### 2. Grade Submission
**POST `/api/submissions/:id/grade`**
- **Body**: `{ "score": 95 }`
- **Logic**: 
  1. Check if the User making the request is the `professor_id` for that Course.
  2. `UPDATE submissions SET score = 95`.
