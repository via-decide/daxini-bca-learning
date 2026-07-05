# 💸 Expense Tracker API: Learn By Building

**"Build a multi-user finance API where users can log daily expenses, categorize them, and generate monthly budget reports."**

---

## 🧪 Testing Scenarios

### Scenario 1: Data Isolation

```
1. Login as User A. Create Category "Food". Log a $10 expense for "Food".
2. Login as User B. GET `/api/expenses`.
3. Expected: User B MUST see an empty array `[]`. If User B sees User A's expense, you have a critical security flaw (IDOR).
```

### Scenario 2: The Negative Expense

```
1. Login as User A.
2. POST `/api/expenses` with `amount: -500`.
3. Expected: Server MUST reject with 400 Bad Request. (Your database `CHECK` constraint should also block this).
```

### Scenario 3: Aggregation Accuracy

```
1. Create Category "Travel" with a $1000 budget.
2. Insert three expenses into "Travel":
   - $200 on Oct 5
   - $300 on Oct 20
   - $100 on Nov 2 (Next month)
3. GET `/api/reports/monthly?month=2026-10`.
4. Expected Response check:
   - `budget`: 1000
   - `spent`: 500 (It MUST ignore the Nov 2 expense!)
   - `remaining`: 500
   - `is_over_budget`: false
5. Insert another $600 expense on Oct 25.
6. Re-run the GET request.
7. Expected Response check:
   - `spent`: 1100
   - `remaining`: -100
   - `is_over_budget`: true
```

### Scenario 4: The Missing Category Fallback

```
1. Create a "Test" Category.
2. Log an expense under it.
3. DELETE the "Test" category.
4. What happens to the expense?
5. Depending on your design, either:
   a) The expense is deleted (ON DELETE CASCADE)
   b) The database blocks the deletion (ON DELETE RESTRICT)
   c) The expense's category_id is set to NULL (ON DELETE SET NULL).
   Test your API to confirm it behaves exactly as you designed it!
```

---
