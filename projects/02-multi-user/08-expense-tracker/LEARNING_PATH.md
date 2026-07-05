# 💸 Expense Tracker API: Learn By Building

**"Build a multi-user finance API where users can log daily expenses, categorize them, and generate monthly budget reports."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Data Isolation** - Using `user_id` Foreign Keys and SQL `WHERE` clauses to ensure users can only see their own private financial data.  
✅ **Date Filtering in SQL** - Extracting the month and year from a Date field to group records.  
✅ **API Data Shaping** - Calculating budget differences (`budget - spent`) on the server and returning ready-to-render flags (`is_over_budget`) for the frontend.  
✅ **Financial Data Types** - Why Floats are dangerous and how to use `DECIMAL` or Cents.

---

## 📋 Project Overview

### The Problem

A finance app must be incredibly fast, mathematically perfect, and completely private. 

If you make a To-Do list app and you accidentally send someone else's To-Do list, it's a bug. If you send someone else's financial expenses, it's a massive privacy breach that kills your company. Therefore, Data Isolation is paramount.

Secondly, analytics (like "Monthly Spend vs Budget") require grouping data. A naive approach pulls all data into Node.js to do the math. A professional approach uses the Database engine to group and sum the data instantly.

**Your job:** Build a highly secure API that stores expenses and uses SQL to generate instant monthly budget reports.

### Who Uses It

```
The User:
├─ POST /api/categories (Sets up their budgets)
├─ POST /api/expenses (Logs their coffee, rent, etc.)
└─ GET /api/reports/monthly?month=2026-10 (Views their dashboard)
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. Enforcing Data Privacy

Every single request that touches the database MUST include the `req.user.id` (extracted from the JWT token).

```pseudocode
POST /api/expenses:
  middlewares: [authenticateUser]
  
  // 1. Verify the category actually belongs to this user!
  category = db.query(`
    SELECT id FROM categories WHERE id = ? AND user_id = ?
  `, [req.body.category_id, req.user.id])
  
  if !category: return 403 "Invalid category"
  
  // 2. Insert expense, permanently tying it to this user
  db.query(`
    INSERT INTO expenses (id, user_id, category_id, amount, date, description)
    VALUES (UUID(), ?, ?, ?, ?, ?)
  `, [req.user.id, req.body.category_id, req.body.amount, req.body.date, req.body.desc])
  
  return 201 "Expense logged"
```

### 2. The Analytics Engine (Data Shaping)

When the user opens the app, they want to see a dashboard showing exactly how much they have left in their budget for each category for the *current* month.

```pseudocode
GET /api/reports/monthly:
  middlewares: [authenticateUser]
  
  // E.g., '2026-10'
  target_month = request.query.month 
  
  // Let SQL do ALL the heavy lifting.
  // We want to join Categories and Expenses, sum up the expenses for the target month,
  // and group the results by Category.
  
  // Note: STRFTIME is SQLite. Postgres uses TO_CHAR, MySQL uses DATE_FORMAT.
  sql = `
    SELECT 
      c.id as category_id,
      c.name as category_name,
      c.monthly_budget as budget,
      SUM(e.amount) as spent
    FROM categories c
    LEFT JOIN expenses e ON c.id = e.category_id 
                         AND STRFTIME('%Y-%m', e.date) = ?
    WHERE c.user_id = ?
    GROUP BY c.id
  `
  
  raw_results = db.query(sql, [target_month, req.user.id])
  
  // Now, Node.js does the final "Shaping" to make the Frontend developer's life easy
  total_spent = 0
  breakdown = []
  
  for row in raw_results:
    spent = row.spent || 0 // Handle case where they spent nothing this month
    budget = row.budget || 0
    remaining = budget - spent
    
    total_spent += spent
    
    breakdown.push({
      category_id: row.category_id,
      category_name: row.category_name,
      budget: budget,
      spent: spent,
      remaining: remaining,
      is_over_budget: remaining < 0 // Instant boolean flag for the UI to turn the text RED
    })
    
  return 200 {
    month: target_month,
    total_spent: total_spent,
    breakdown: breakdown
  }
```

---

## ✅ Before Submission

- [ ] System supports User registration and JWT login.
- [ ] Users can create custom categories with optional budgets.
- [ ] Users can log expenses tied to a date and category.
- [ ] Data is strictly isolated (A user can NEVER see or delete another user's expenses).
- [ ] Monthly Report endpoint uses SQL `SUM()` and `GROUP BY` to calculate spending.
- [ ] API responses are pre-calculated (providing `remaining` and `is_over_budget` flags).
- [ ] Code is on GitHub.

**Success:** You have built a robust, secure financial backend!
