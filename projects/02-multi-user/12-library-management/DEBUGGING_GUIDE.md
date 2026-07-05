# 📚 Library Management System: Learn By Building

**"Build a multi-user API for a library where Admins manage the book catalog, and Members check out books, requiring strict inventory management, due dates, and automated late fee calculations."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Inventory Limit Test

```
1. Create a Book with `total_copies = 1`.
2. Login as Member A and `POST /api/borrow`. (Success).
3. Login as Member B and `POST /api/borrow` for the same book.
4. Expected: Server MUST reject Member B with a 409 Conflict (No available copies).
5. Admin returns Member A's book (`POST /api/returns`).
6. Member B tries to borrow again. (Success).
```

### Scenario 2: The Late Fee Calculator

```
1. Directly in your Database, create a `borrow_record` with a `due_date` of 10 days ago. Make sure `returned_date` is NULL.
2. Login as Admin.
3. `POST /api/returns` for that loan ID. (Pass today's date, or let the server use `CURRENT_DATE`).
4. Expected: The API should update `returned_date` to today, calculate 10 days late * $1.00/day, and set `late_fee` to $10.00. The JSON response should show this calculation.
```

### Scenario 3: The Member Borrow Limit

```
1. Most libraries limit how many books a member can have at once (e.g., 5).
2. Login as Member A.
3. Borrow 5 different books.
4. Attempt to borrow a 6th book.
5. Expected: Server MUST reject with 403 Forbidden or 400 Bad Request.
6. Verify: The database `borrow_records` should only have 5 rows for Member A where `returned_date IS NULL`.
```

### Scenario 4: Return Idempotency

```
1. Admin returns a book successfully (`POST /api/returns`).
2. Admin accidentally clicks the button again, sending the exact same request.
3. Expected: Server MUST reject the second request (400 Bad Request: "Book already returned"). If it charges the late fee twice, or changes the return date, it is a bug.
```

---
