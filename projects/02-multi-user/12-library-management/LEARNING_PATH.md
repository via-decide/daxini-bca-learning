# 📚 Library Management System: Learn By Building

**"Build a multi-user API for a library where Admins manage the book catalog, and Members check out books, requiring strict inventory management, due dates, and automated late fee calculations."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Dynamic Inventory Calculation** - Using Subqueries (`SELECT COUNT(...)`) within a main `SELECT` statement to calculate available stock on the fly.  
✅ **Business Rule Validation** - Querying the database to check a user's status (e.g., "Do they already have 5 books?") before allowing an action.  
✅ **Date Math for Penalties** - Calculating the difference in days between a `due_date` and `returned_date` to dynamically apply financial penalties.

---

## 📋 Project Overview

### The Problem

A Library is an inventory system where the items always come back. This means we don't just subtract stock when an item leaves; we track the *lifecycle* of the checkout (The `borrow_record`).

Because physical books are limited, the system must accurately calculate how many copies are currently sitting on the shelf. Because the library wants its books back, the system must enforce strict due dates and mathematically calculate penalties for late returns.

**Your job:** Build an API that strictly limits checkouts based on inventory and user limits, and reliably processes returns with automated math.

### Who Uses It

```
Admin:
├─ POST /api/books (Adds new inventory)
└─ POST /api/returns (Scans a returned book and collects fees)

Member:
├─ GET /api/books (Searches the catalog to see what is available)
└─ POST /api/borrow (Checks out a book)
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. Dynamic Catalog Availability (The Subquery)

When a member searches for a book, they need to know if they can actually borrow it today.

```pseudocode
GET /api/books:
  // Using a SQL Subquery to count the ACTIVE loans for each book
  // This guarantees perfect accuracy without maintaining a fragile counter column.
  
  sql = `
    SELECT 
      b.id, b.title, b.author, b.total_copies,
      (
        SELECT COUNT(*) 
        FROM borrow_records 
        WHERE book_id = b.id AND returned_date IS NULL
      ) as currently_borrowed
    FROM books b
  `
  
  books = db.query(sql)
  
  // Format for the frontend
  results = books.map(book => {
    return {
      ...book,
      available_copies: book.total_copies - book.currently_borrowed
    }
  })
  
  return 200 { books: results }
```

### 2. The Borrowing Constraints

Before letting a user check out a book, you must check TWO things: Do we have the book? Does the user have too many books?

```pseudocode
POST /api/borrow:
  middlewares: [authenticateUser, requireRole(['member'])]
  req_book_id = request.body.book_id
  
  // 1. Check User Limit
  active_loans = db.query(`
    SELECT COUNT(*) as count FROM borrow_records 
    WHERE user_id = ? AND returned_date IS NULL
  `, req.user.id)
  
  if active_loans.count >= 5:
    return 403 "You have reached the maximum of 5 borrowed books."
    
  // 2. Check Book Availability
  // (In a real system, you would do this inside a Transaction)
  book_stats = db.query(`
    SELECT total_copies, 
      (SELECT COUNT(*) FROM borrow_records WHERE book_id = ? AND returned_date IS NULL) as borrowed
    FROM books WHERE id = ?
  `, [req_book_id, req_book_id])
  
  if (book_stats.total_copies - book_stats.borrowed) <= 0:
    return 409 "No copies available"
    
  // 3. Create the Loan (Due in 14 days)
  due_date = today() + 14 days
  
  db.query(`
    INSERT INTO borrow_records (id, book_id, user_id, borrowed_date, due_date)
    VALUES (UUID(), ?, ?, CURRENT_DATE, ?)
  `, [req_book_id, req.user.id, due_date])
  
  return 201 "Book borrowed!"
```

### 3. The Return and Penalty Calculator

```pseudocode
POST /api/returns:
  middlewares: [authenticateUser, requireRole(['admin'])]
  loan_id = request.body.loan_id
  
  // 1. Get the loan
  loan = db.query("SELECT * FROM borrow_records WHERE id = ?", loan_id)
  
  if loan.returned_date != NULL:
    return 400 "Book already returned"
    
  // 2. Calculate Fee (Assume $1 per day late)
  // We use the database to do the math to avoid Timezone issues
  // Note: Date math syntax varies wildly between SQLite/Postgres/MySQL
  fee_calculation = db.query(`
    SELECT 
      CASE 
        WHEN CURRENT_DATE > due_date THEN (julianday(CURRENT_DATE) - julianday(due_date)) * 1.00
        ELSE 0.00
      END as fee
    FROM borrow_records WHERE id = ?
  `, loan_id)
  
  late_fee = fee_calculation.fee
  
  // 3. Update the record
  db.query(`
    UPDATE borrow_records 
    SET returned_date = CURRENT_DATE, late_fee = ?
    WHERE id = ?
  `, [late_fee, loan_id])
  
  return 200 {
    message: "Returned",
    late_fee_assessed: late_fee
  }
```

---

## ✅ Before Submission

- [ ] System separates Admin (catalog management) from Member (borrowing).
- [ ] Availability is calculated dynamically using subqueries (no `available_copies` column).
- [ ] Members are blocked from borrowing if they have 5 active loans, or if 0 copies are available.
- [ ] Returning a book automatically calculates a late fee based on the due date.
- [ ] Code is on GitHub.

**Success:** You have built a robust inventory and penalty system!
