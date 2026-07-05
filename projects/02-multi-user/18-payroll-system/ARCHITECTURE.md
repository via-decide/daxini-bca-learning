# 💰 Payroll System API: Learn By Building

**"Build a multi-user API where Admins define salary structures, Employees log daily hours, and the system automatically generates monthly payslips calculating gross pay, tax deductions, and net pay."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. Admin configures Employee Eric's base salary as $30/hour, with a standard tax rate of 15%.
2. Eric logs 8 hours on Monday and 8 hours on Tuesday.
3. At the end of the month, the system generates a Payslip: 
   - 16 hours worked
   - Gross Pay: $480 (16 * $30)
   - Tax Deducted: $72 (15% of $480)
   - Net Pay: $408

**What data do you need for each?**

After thinking, here's the data model:

```
Table: Users (Admins, Employees)
├─ id (UUID)
├─ email (String)
├─ password_hash (String)
└─ role (Enum: 'admin', 'employee')

Table: Salary_Configs
├─ user_id (Foreign Key -> Users - 1-to-1 relationship)
├─ hourly_rate (Decimal)
└─ tax_percentage (Decimal)

Table: Timesheets
├─ id (UUID)
├─ user_id (Foreign Key -> Users)
├─ work_date (Date)
├─ hours_worked (Decimal)
└─ status (Enum: 'pending', 'processed_for_payroll')

Table: Payslips (The Ledger)
├─ id (UUID)
├─ user_id (Foreign Key -> Users)
├─ period_start (Date)
├─ period_end (Date)
├─ total_hours (Decimal)
├─ gross_pay (Decimal)
├─ tax_deducted (Decimal)
├─ net_pay (Decimal)
└─ created_at (DateTime)
```

---

### Step 2: Financial Aggregation & State Transition

**Question: When generating the month's payslip, how do you make sure an employee isn't paid twice for the same hours?**

**Bad Idea:** Fetching timesheets from `2026-10-01` to `2026-10-31`, summing them, and generating the payslip. (What if they logged an October 31st hour late, on November 2nd, after the payslip was generated?)

**Good Idea:** Tie the Timesheet rows directly to the generation process using a State Machine.
1. The system finds all `status = 'pending'` timesheets for the employee up to the current date.
2. It aggregates those specific rows.
3. It generates the Payslip.
4. It updates those exact Timesheet rows to `status = 'processed_for_payroll'` within a **Database Transaction**.

If the employee logs October 31st late, it stays `pending` and rolls over into the November payslip. No money is lost, and no money is double-paid.

---

### Step 3: Immutability of Financial Records

If Admin changes Eric's tax rate from 15% to 20% today, you **cannot** update his previous Payslips. A Payslip is a historical snapshot. This is why the `Payslips` table explicitly stores `gross_pay` and `tax_deducted` directly, rather than calculating them on the fly during a `GET` request.

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Employee Portal (Log Hours, Payslips)│  │
│  │ Admin Dashboard (Run Payroll)        │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP requests with JWT (RBAC)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. Configuration Validation          │  │
│  │ 2. Timesheet Aggregation (SQL SUM)   │  │
│  │ 3. Transactional Payroll Generator   │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (PostgreSQL/MySQL)         │
│  - users, configs, timesheets, payslips    │
└────────────────────────────────────────────┘
```
