# Leave Management System

## 🏗️ Architecture: Design Before Coding

**The Problem:**
Employees request days off. They have a yearly allowance (20 Vacation days, 10 Sick days). Managers must approve requests. The system must prevent booking more days than are available.

**The Solution:**
A `Leave_Balances` table caches the remaining days. A `Leave_Requests` table handles the workflow.

**Database Architecture:**
```text
Leave_Balances
├─ employee_id
├─ year (INT)
├─ leave_type (ENUM: Vacation, Sick)
└─ days_remaining (INT)

Leave_Requests
├─ id
├─ employee_id
├─ leave_type
├─ start_date
├─ end_date
├─ days_requested (INT)
└─ status (ENUM: Pending, Approved, Rejected)
```
