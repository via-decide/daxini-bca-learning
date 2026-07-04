## 🔌 API Design: Plan Before Coding

### 1. Punch In
**POST `/api/attendance/punch-in`**
- **Logic**: Insert row. If Unique Constraint fails (they already punched in today), return error.

### 2. Punch Out
**POST `/api/attendance/punch-out`**
- **Logic**: 
  1. Find today's record.
  2. `UPDATE punch_out = NOW()`.
  3. `UPDATE total_hours = EXTRACT(EPOCH FROM (NOW() - punch_in))/3600`.
