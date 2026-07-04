## 🔌 API Design: Plan Before Coding

### 1. Transfer Money
**POST `/api/transfers`**
- **Logic**: 
  1. `BEGIN TRANSACTION`
  2. `SELECT balance FROM accounts WHERE id = A FOR UPDATE` (Lock the row!)
  3. If balance < amount, `ROLLBACK` and error.
  4. `UPDATE accounts SET balance = balance - amount WHERE id = A`
  5. `UPDATE accounts SET balance = balance + amount WHERE id = B`
  6. `INSERT INTO transactions`
  7. `COMMIT`
