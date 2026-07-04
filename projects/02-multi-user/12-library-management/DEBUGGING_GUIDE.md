## 🛠️ Debugging & Verification

**Test 1: Stock Limit**
- Set `total_copies` to 2.
- User A borrows the book. User B borrows the book.
- User C tries to borrow the book. The API must return `400 Bad Request: No copies available`.
- User A returns the book. User C tries again and succeeds.

**Test 2: Fine Calculation**
- Create a mock record where `due_date` was 5 days ago.
- Execute the Return API. Ensure the `fine_amount` is exactly `$5.00`.
