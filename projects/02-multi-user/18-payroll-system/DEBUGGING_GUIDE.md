# 💰 Payroll System API: Learn By Building

**"Build a multi-user API where Admins define salary structures, Employees log daily hours, and the system automatically generates monthly payslips calculating gross pay, tax deductions, and net pay."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Double Payment Prevention (Idempotency/State)

```
1. Employee A logs 8 hours on Monday (Status: pending).
2. Admin runs Payroll for the month. (Status changes to 'processed').
3. Admin accidentally clicks "Run Payroll" again immediately.
4. Expected: The second run should generate exactly $0.00 for Employee A, or skip them entirely. It MUST NOT process those 8 hours again.
```

### Scenario 2: Historical Snapshot Test

```
1. Set Employee A's hourly rate to $20.
2. Log 10 hours. (Pending).
3. Run Payroll. (Gross Pay is $200).
4. Update Employee A's hourly rate to $50.
5. Fetch the old Payslip via `GET /api/payslips/me`.
6. Expected: The Gross Pay on that payslip MUST still say $200, NOT $500. It must reflect the rate at the time of processing.
```

### Scenario 3: Daily Limit Constraint

```
1. Employee A logs 8 hours for 2026-10-15.
2. Employee A attempts to log another 5 hours for 2026-10-15.
3. Expected: Server MUST reject it (409 Conflict). The DB `UNIQUE (user_id, work_date)` constraint should block this. If they need to edit their hours, they should use a `PUT` request to update the existing row, not create a second one.
```

### Scenario 4: Transaction Failure Rollback

```
1. Inside your `POST /api/payroll/run` route, intentionally throw an error right after generating the Payslip, but *before* updating the Timesheets to 'processed'.
2. Run Payroll.
3. Check the DB.
4. Expected: No payslip should exist. The transaction must rollback to prevent generating a payslip without marking the timesheets as paid.
```

---
