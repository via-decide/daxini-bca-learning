# Library Management System

## 🏗️ Architecture: Design Before Coding

**The Problem:**
A library has books. Users borrow them and return them. If a book is borrowed, no one else can borrow it. If a user is late, they owe fines.

**The Solution:**
Keep a ledger of `Borrowing_Records`. Calculate fines dynamically based on the difference between the current date and the `due_date`.

**Database Architecture:**
```text
Books
├─ id
├─ title
├─ isbn
└─ total_copies

Borrowing_Records
├─ id
├─ book_id
├─ user_id
├─ borrow_date
├─ due_date
├─ return_date (NULL if not returned yet)
└─ fine_amount (Calculated upon return)
```
