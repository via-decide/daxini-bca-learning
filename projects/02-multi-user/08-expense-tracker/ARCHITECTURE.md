# Expense Tracker & Budgeting

## 🏗️ Architecture: Design Before Coding

**The Problem:**
Users need to log daily expenses, categorize them (Food, Rent), and ensure they don't exceed monthly budget thresholds. 

**The Solution:**
A highly aggregated financial system that can convert currencies on the fly and trigger alerts when a specific category hits 90% of its budget.

**Database Architecture:**
```text
Budgets
├─ id
├─ user_id
├─ category (ENUM: Food, Transport, Rent)
├─ monthly_limit (DECIMAL)
└─ month_year (VARCHAR '2024-10')

Expenses
├─ id
├─ user_id
├─ category
├─ amount (DECIMAL)
├─ currency (VARCHAR 'USD')
└─ date
```
