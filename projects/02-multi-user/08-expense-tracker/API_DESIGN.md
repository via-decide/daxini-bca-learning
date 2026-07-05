# 💸 Expense Tracker API: API Design

**"Build a multi-user finance API where users can log daily expenses, categorize them, and generate monthly budget reports."**

---

## 🔗 API Endpoints

*(All routes require Authentication via JWT)*

**Categories:**
```
POST   /api/categories         → Create a custom category
GET    /api/categories         → List my categories
```

**Expenses:**
```
POST   /api/expenses           → Log a new expense
GET    /api/expenses           → List recent expenses (Paginated)
DELETE /api/expenses/:id       → Delete a mistake
```

**Analytics & Reports:**
```
GET    /api/reports/monthly    → Get total spending vs budget for a specific month
```

---

## 📦 Request/Response Examples

### 1. Create a Category

**Request:**
```json
POST /api/categories
{
  "name": "Entertainment",
  "monthly_budget": 200.00
}
```

**Response (201):**
```json
{
  "message": "Category created",
  "category": {
    "id": "cat-555",
    "name": "Entertainment",
    "monthly_budget": 200.00
  }
}
```

### 2. Log an Expense

**Request:**
```json
POST /api/expenses
{
  "category_id": "cat-555",
  "amount": 25.50,
  "description": "Movie tickets",
  "date": "2026-10-15"
}
```

**Response (201):**
```json
{
  "message": "Expense logged",
  "expense": {
    "id": "exp-123",
    "category_id": "cat-555",
    "amount": 25.50,
    "description": "Movie tickets",
    "date": "2026-10-15"
  }
}
```

### 3. Generate Monthly Report (The Core Feature)

**Request:**
```http
GET /api/reports/monthly?month=2026-10 HTTP/1.1
```

**Response (200):**
```json
{
  "month": "2026-10",
  "total_spent": 1450.75,
  "breakdown": [
    {
      "category_id": "cat-111",
      "category_name": "Groceries",
      "budget": 400.00,
      "spent": 380.00,
      "remaining": 20.00,
      "is_over_budget": false
    },
    {
      "category_id": "cat-555",
      "category_name": "Entertainment",
      "budget": 200.00,
      "spent": 225.50,
      "remaining": -25.50,
      "is_over_budget": true
    }
  ]
}
```
*(Notice how the backend does all the complex logic. It calculates `remaining` and flags `is_over_budget` so the frontend can just instantly render a red progress bar).*

---

## ⚠️ Error Responses

```json
// 400 Bad Request (Validation)
{ "error": "Amount must be a positive number." }

// 404 Not Found (User tries to use a category that doesn't exist)
{ "error": "Category not found." }

// 403 Forbidden (User tries to delete someone else's expense)
{ "error": "You do not have permission to delete this expense." }
```
