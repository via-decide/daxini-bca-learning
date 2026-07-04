# Employee Directory (Org Chart)

## 🏗️ Architecture: Design Before Coding

**The Problem:**
A company wants to map its organizational chart. A CEO manages Directors. Directors manage Managers. Managers manage Employees. 

**The Solution:**
You do NOT need separate tables for `CEOs`, `Managers`, and `Employees`. They are all employees. Use a "Self-Referencing" table where an employee has a `manager_id` that points to another row in the same table.

**Database Architecture:**
```text
Employees
├─ id
├─ name
├─ title
├─ department_id
└─ manager_id (REFERENCES Employees.id)
```
