## 🔌 API Design: Plan Before Coding

### 1. Start Exam
**POST `/api/exams/:id/start`**
- **Logic**: Insert row into `test_attempts`. Return the `start_time` and `duration_minutes` to the client so it can render a countdown.

### 2. Submit Exam
**POST `/api/exams/attempts/:attempt_id/submit`**
- **Logic**: 
  1. Check if `NOW()` > `start_time + duration_minutes + 1 minute grace period`. If yes, reject!
  2. Grade the answers by comparing with `questions.correct_option`.
  3. Update `submitted_at` in `test_attempts`.
