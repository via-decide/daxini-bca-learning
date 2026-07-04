## 🔌 API Design: Plan Before Coding

### 1. Borrow Book
**POST `/api/borrow`**
- **Body**: `{ "book_id": "123" }`
- **Logic**: 
  1. Check if `SELECT count(*) FROM borrowing_records WHERE book_id=X AND return_date IS NULL` is less than `total_copies`.
  2. If so, `INSERT` new record with `due_date = borrow_date + 14 days`.

### 2. Return Book
**POST `/api/return`**
- **Body**: `{ "borrow_record_id": "999" }`
- **Logic**: 
  1. `UPDATE borrowing_records SET return_date = CURRENT_DATE`.
  2. Calculate fine: `(return_date - due_date) * $1.00`. If negative, fine = 0.
