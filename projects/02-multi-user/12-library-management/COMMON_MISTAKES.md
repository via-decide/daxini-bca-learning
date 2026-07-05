# 📚 Library Management System: Learn By Building

**"Build a multi-user API for a library where Admins manage the book catalog, and Members check out books, requiring strict inventory management, due dates, and automated late fee calculations."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Storing `available_copies` as a physical column

**Wrong:**
```sql
CREATE TABLE books (
  id TEXT,
  total_copies INTEGER,
  available_copies INTEGER -- You manually +1 or -1 this column
);
```
*Why it's bad:* If the server crashes right after a book is returned but before the `available_copies` column is updated, that book copy is permanently "lost" to the system. You now have 3 physical copies on the shelf, but the DB says `available_copies = 2`.

**Right:**
Calculate it dynamically based on the transaction log (`borrow_records`).

### ❌ Mistake 2: Calculating Late Fees in the Database Schema

**Wrong:**
Creating a cron-job or trigger that updates a `late_fee` column every night at midnight.
*Why it's bad:* It's incredibly resource-intensive and error-prone. What if the server is down at midnight? 

**Right:**
Only calculate the late fee *at the exact moment* the book is returned (or when the user requests to see their current balance). Store the finalized fee in the DB only when the transaction is closed.

### ❌ Mistake 3: Weak Date Handling

**Wrong:**
```javascript
// Node.js checking if it's late
const isLate = new Date() > new Date(loan.due_date);
```
*Why it's bad:* Timezones. If a book is due on October 15th, and the user returns it at 11:00 PM on October 15th, but the Server is in London (where it is already October 16th), the user gets charged a late fee unfairly.

**Right:**
Strip the "Time" away. Compare Dates (YYYY-MM-DD) strictly, or do the date math entirely within the SQL engine which can be configured to use a specific timezone or UTC.

---
