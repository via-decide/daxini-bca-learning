# 📚 Library Management System: Learn By Building

**"Build a multi-user API for a library where Admins manage the book catalog, and Members check out books, requiring strict inventory management, due dates, and automated late fee calculations."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. The Library has 3 physical copies of "Harry Potter".
2. Member John checks out a copy today. It is due in 14 days.
3. The Library now has 2 available copies.
4. John returns the book 20 days later (6 days late). The system charges him a fine of $1 per late day.

**What data do you need for each?**

After thinking, here's the data model:

```
Table: Users
├─ id (UUID)
├─ email (String)
├─ password_hash (String)
└─ role (Enum: 'admin', 'member')

Table: Books (The Catalog)
├─ id (UUID)
├─ isbn (String - Unique Identifier)
├─ title (String)
├─ author (String)
└─ total_copies (Integer)

Table: Borrow_Records (The Transaction Log)
├─ id (UUID)
├─ book_id (Foreign Key -> Books)
├─ user_id (Foreign Key -> Users)
├─ borrowed_date (Date)
├─ due_date (Date)
├─ returned_date (Date - NULL if not yet returned)
└─ late_fee_paid (Decimal - NULL if no fee, or unpaid)
```

---

### Step 2: The "Available Copies" Calculation

**Question: If the library owns 3 copies of a book, how do we know if John can check one out right now?**

**Bad Idea:** Adding an `available_copies` column to the `Books` table and manually subtracting 1 when someone borrows it, and adding 1 when they return it. (If the code fails during a return, a book is lost forever in the system).

**Good Idea:** Calculate `available_copies` on the fly by counting how many `Borrow_Records` have `returned_date IS NULL` for that book, and subtracting that from `total_copies`. The database is the single source of truth.

```sql
SELECT 
  total_copies - (
    SELECT COUNT(*) 
    FROM borrow_records 
    WHERE book_id = books.id AND returned_date IS NULL
  ) as available_copies
FROM books WHERE id = 'book-123';
```

---

### Step 3: Date Math and Financial Penalties (Late Fees)

When John returns a book, the system must check if `returned_date > due_date`. If so, it calculates a fee. 

Because we want this system to be highly reliable, we do the math in the database at the exact moment the book is returned.

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Catalog Search (Available Books)     │  │
│  │ Member Dashboard (My Due Dates)      │  │
│  │ Admin Desk (Process Returns)         │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP requests with JWT (RBAC)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. Search & Availability Engine      │  │
│  │ 2. Borrowing Validation (Limits)     │  │
│  │ 3. Return & Penalty Calculator       │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (PostgreSQL/MySQL)         │
│  - users, books, borrow_records tables     │
└────────────────────────────────────────────┘
```
