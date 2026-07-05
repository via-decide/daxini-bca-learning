# 🌴 Leave Management System: Learn By Building

**"Build a multi-user API where Employees request time off (PTO/Sick leave), and Managers approve or reject these requests while the system strictly enforces available leave balances."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Race Condition (Overdraft Test)

```
1. Employee A has exactly 5 PTO days left.
2. Employee A creates two separate `leave_requests` (ID 1 for 4 days, ID 2 for 3 days). Both are 'pending'.
3. Login as their Manager.
4. Call `PUT /api/leave/requests/1/approve` AND `PUT /api/leave/requests/2/approve` simultaneously (using a tool like Postman Runner or a script).
5. Expected: One request should succeed (status 200). The other request MUST FAIL (status 400 or 500) because deducting 3 days from the remaining 1 day would violate the `CHECK (days_remaining >= 0)` constraint in the database.
```

### Scenario 2: The Self-Referencing Inbox

```
1. Create Manager Mary.
2. Create Employee Ethan (`manager_id = Mary.id`).
3. Create Employee Bob (`manager_id = NULL` or someone else).
4. Ethan and Bob both submit pending leave requests.
5. Login as Mary and call `GET /api/leave/inbox`.
6. Expected: Mary should ONLY see Ethan's request. Bob's request should not appear.
```

### Scenario 3: Initial Application Validation

```
1. Employee A has 5 PTO days left.
2. Employee A calls `POST /api/leave/request` for a 10-day vacation.
3. Expected: The server MUST reject it immediately (400 Bad Request) before even saving it as 'pending'. There's no point in bothering the manager if the math doesn't work.
```

### Scenario 4: Transaction Rollback

```
1. In your `PUT .../approve` route, intentionally throw an error *after* updating the `leave_requests` status to 'approved', but *before* deducting the `leave_balances`.
2. As a manager, approve a pending request.
3. Check the database.
4. Expected: The request should STILL be 'pending'. The transaction must rollback to prevent the status from changing if the balance isn't successfully deducted.
```

---
