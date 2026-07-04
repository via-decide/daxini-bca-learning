# Payroll System

## 🏗️ Architecture: Design Before Coding

**The Problem:**
Employees have a base salary, but every month they have variable deductions (Taxes, Insurance) and additions (Bonuses). The final "Net Pay" must be strictly calculated and a Payslip generated.

**The Solution:**
Store the Base Salary on the Employee record. Have a `Payslips` table generated monthly. Use a `Payslip_Line_Items` table (1-to-Many) to list every specific deduction and addition.

**Database Architecture:**
```text
Employee_Contracts
├─ employee_id
└─ base_salary_annual (DECIMAL)

Payslips
├─ id
├─ employee_id
├─ month_year (VARCHAR)
├─ gross_pay
└─ net_pay (Gross - Deductions)

Payslip_Line_Items
├─ payslip_id
├─ type (ENUM: Addition, Deduction)
├─ description (e.g. "Health Insurance")
└─ amount
```
