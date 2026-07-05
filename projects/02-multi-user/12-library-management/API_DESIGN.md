# 📚 Library Management System: API Design

**"Build a multi-user API for a library where Admins manage the book catalog, and Members check out books, requiring strict inventory management, due dates, and automated late fee calculations."**

---

## 🔗 API Endpoints

*(All routes require Authentication via JWT)*

**Admin Operations (Requires 'admin' role):**
```
POST   /api/books              → Add a new book to the catalog
PUT    /api/books/:id          → Update book details (e.g., total copies)
POST   /api/returns            → Process a returned book (calculates fees)
```

**Member Operations (Requires 'member' role):**
```
GET    /api/books              → Browse catalog (includes dynamic 'available_copies')
POST   /api/borrow             → Check out a book
GET    /api/members/me/loans   → View my currently borrowed books and due dates
```

---

## 📦 Request/Response Examples

### 1. Browse the Catalog (Member)

This endpoint must calculate availability dynamically.

**Request:**
```http
GET /api/books?search=harry HTTP/1.1
```

**Response (200):**
```json
{
  "books": [
    {
      "id": "book-123",
      "isbn": "978-0439708180",
      "title": "Harry Potter and the Sorcerer's Stone",
      "author": "J.K. Rowling",
      "total_copies": 3,
      "currently_borrowed": 2,
      "available_copies": 1
    }
  ]
}
```

### 2. Borrow a Book (Member)

**Request:**
```json
POST /api/borrow
{
  "book_id": "book-123"
}
```

**Response (201):**
```json
{
  "message": "Book checked out successfully",
  "loan": {
    "id": "loan-999",
    "book_id": "book-123",
    "borrowed_date": "2026-10-01",
    "due_date": "2026-10-15"
  }
}
```

### 3. Process a Return (Admin)

When the admin scans the book, the system calculates the fee based on the current date.

**Request:**
```json
POST /api/returns
{
  "loan_id": "loan-999",
  "return_date": "2026-10-20" 
}
```

**Response (200):**
```json
{
  "message": "Book returned",
  "receipt": {
    "loan_id": "loan-999",
    "book_title": "Harry Potter and the Sorcerer's Stone",
    "borrowed_date": "2026-10-01",
    "due_date": "2026-10-15",
    "returned_date": "2026-10-20",
    "days_late": 5,
    "late_fee_assessed": 5.00
  }
}
```

---

## ⚠️ Error Responses

```json
// 409 Conflict (Member tries to borrow a book with 0 available copies)
{ "error": "No copies of this book are currently available." }

// 403 Forbidden (Member tries to borrow more than the 5-book limit)
{ "error": "You have reached your maximum borrowing limit of 5 books." }

// 400 Bad Request (Admin tries to return a book that is already returned)
{ "error": "This loan has already been closed." }
```
