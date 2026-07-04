## 🔌 API Design: Plan Before Coding

### 1. Request Leave
**POST `/api/leaves/request`**
- **Logic**: 
  1. Ensure `start_date` is in the future.
  2. Ensure `days_requested <= days_remaining` in the balance table.
  3. Insert with `status = pending`.

### 2. Approve Leave
**POST `/api/leaves/:id/approve`**
- **Logic**: (Manager only).
  1. `UPDATE leave_requests SET status = 'approved'`.
  2. `UPDATE leave_balances SET days_remaining = days_remaining - request.days_requested`.
