## 🔌 API Design: Plan Before Coding

### 1. Log Expense
**POST `/api/expenses`**
- **Logic**: Insert the expense. Immediately calculate if the sum of expenses for this category this month exceeds 90% of the budget. If so, return a warning flag in the response.

### 2. Get Monthly Summary
**GET `/api/expenses/summary?month=2024-10`**
- **Logic**: `GROUP BY category` and `SUM(amount)`.
