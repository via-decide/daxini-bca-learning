# Employee Management System (HR Portal)

## 🏗️ Architecture: Design Before Coding

**The Problem:**
A company needs a central database of employees, their departments, roles, and employment status (Active, On Leave, Terminated).

**The Solution:**
Standard relational design. Use lookup tables for Departments and Roles instead of typing "Engineering" into a text column a thousand times.

**Database Architecture:**
```text
Departments
├─ id
└─ name (e.g. Sales, Engineering)

Roles
├─ id
└─ title (e.g. Manager, Intern)

Employees
├─ id
├─ first_name
├─ last_name
├─ department_id
├─ role_id
└─ status (ENUM: Active, On_Leave, Terminated)
```
