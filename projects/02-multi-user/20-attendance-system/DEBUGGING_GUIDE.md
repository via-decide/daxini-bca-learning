## 🛠️ Debugging & Verification

**Test 1: Math Verification**
- Punch in. Wait exactly 90 minutes. Punch out.
- Ensure `total_hours` is stored as exactly `1.50`.

**Test 2: Double Punch**
- Punch in at 9:00am.
- Send another punch in request at 9:05am. Ensure the DB Unique Constraint safely rejects it.
