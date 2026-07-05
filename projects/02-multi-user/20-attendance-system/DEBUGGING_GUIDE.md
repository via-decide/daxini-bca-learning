# 🕒 Employee Attendance System: Learn By Building

**"Build a multi-user API where Employees clock in and out daily, and Managers view attendance reports to track tardiness and total hours worked."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Idempotency Test (Double Clock-In)

```
1. Employee A calls `POST /api/attendance/clock-in` at 09:00:00. (Success)
2. Employee A calls `POST /api/attendance/clock-in` at 09:00:05.
3. Expected: Server MUST reject the second request (409 Conflict). The database `UNIQUE (user_id, date)` constraint should catch this and block the insert.
```

### Scenario 2: The Tardiness Algorithm

```
1. Set Employee B's `expected_start_time` to '09:00:00'.
2. Mock the server's time (or your system clock) to '08:50:00'.
3. Employee B clocks in. Expected status: 'present'.
4. Mock the server's time to '09:15:00'.
5. Employee C (same start time) clocks in. Expected status: 'late'.
6. Verify in the database that the status column correctly caught the tardiness automatically.
```

### Scenario 3: The Missing Clock-In

```
1. Employee A forgets to clock in.
2. At 5:00 PM, Employee A calls `PUT /api/attendance/clock-out`.
3. Expected: Server MUST reject it (400 Bad Request). You cannot update a record that does not exist for the current date.
```

### Scenario 4: The Manager Hierarchy Report

```
1. Manager Mary manages Ethan and Alice.
2. Manager Dave manages Bob.
3. Ethan, Alice, and Bob all clock in.
4. Mary calls `GET /api/reports/daily?date=today`.
5. Expected: Mary should see exactly two records (Ethan and Alice). Bob MUST NOT appear in her report.
```

---
