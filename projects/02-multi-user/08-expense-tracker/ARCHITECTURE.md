# 💸 Expense Tracker API: Learn By Building

**"Build a multi-user finance API where users can log daily expenses, categorize them, and generate monthly budget reports."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. User A creates a category called "Groceries" with a monthly budget of $400.
2. User A logs an expense of $50 at "Whole Foods" on Oct 12th under "Groceries".
3. User A asks the app: "How much of my grocery budget do I have left this month?"
4. User B logs in. They should not see User A's expenses or categories.

**What data do you need for each?**

After thinking, here's the data model:

```
Table: Users
├─ id (UUID)
├─ email (String)
└─ password_hash (String)

Table: Categories
├─ id (UUID)
├─ user_id (Foreign Key -> Users)
├─ name (String - e.g., 'Groceries', 'Rent')
└─ monthly_budget (Decimal - Optional)

Table: Expenses
├─ id (UUID)
├─ user_id (Foreign Key -> Users)
├─ category_id (Foreign Key -> Categories)
├─ amount (Decimal)
├─ description (String)
└─ date (Date)
```

---

### Step 2: Date Filtering (The "Monthly" Problem)

When calculating budget usage, we only care about expenses within the current month.

**Bad Idea:** Fetch all expenses ever made, and use a JavaScript `.filter()` to only keep the ones from October.
**Good Idea:** Use SQL date functions to filter before the data ever leaves the database.

```sql
-- SQLite Example (Getting expenses for October 2026)
SELECT SUM(amount) FROM expenses 
WHERE user_id = 'user123' 
AND category_id = 'cat-groceries'
AND STRFTIME('%Y-%m', date) = '2026-10';
```

---

### Step 3: Decimal vs Float (Money handling)

Whenever you deal with money, you must never use floating-point numbers (`FLOAT` or `REAL`).

**The Floating Point Error:**
If you store `$0.10` and `$0.20` as Floats, the computer will often add them to equal `0.30000000000000004`. Over thousands of transactions, your financial app will lose or magically create money, leading to furious users.

**The Solution:**
1. **Best Practice:** Store money as `INTEGER` representing cents. `$50.00` is stored as `5000`. You only divide by 100 when showing it on the frontend.
2. **Alternative:** Store it as `DECIMAL(10,2)` in databases that strictly support it (like PostgreSQL).

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Add Expense Modal                    │  │
│  │ Monthly Budget Progress Bar          │  │
│  │ Pie Chart Breakdown                  │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP requests with JWT (State changes)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. JWT Authentication                │  │
│  │ 2. Expense Validation                │  │
│  │ 3. Financial Aggregation (SQL)       │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (PostgreSQL/MySQL)         │
│  - users, categories, expenses tables      │
└────────────────────────────────────────────┘
```
