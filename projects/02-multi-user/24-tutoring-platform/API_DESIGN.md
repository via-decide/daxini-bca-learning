## 🔌 API Design: Plan Before Coding

### 1. Search Tutors
**GET `/api/tutors?subject=Calculus`**
- **Logic**: `SELECT u.name, ts.hourly_rate FROM users u JOIN tutor_subjects ts ON u.id = ts.tutor_id JOIN subjects s ON ts.subject_id = s.id WHERE s.name = 'Calculus'`.

### 2. Book Session
**POST `/api/sessions`**
- **Body**: `{ "tutor_id": "1", "subject_id": "2", "duration": 60 }`
- **Logic**: 
  1. Verify tutor teaches subject. Fetch `hourly_rate`.
  2. Calculate `total_price = (duration / 60) * hourly_rate`.
  3. (Optional) Call Zoom API to get a `meeting_url`.
  4. Insert into `sessions`.
