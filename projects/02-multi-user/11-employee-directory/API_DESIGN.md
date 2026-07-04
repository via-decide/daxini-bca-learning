## 🔌 API Design: Plan Before Coding

### 1. Get Employee Details
**GET `/api/employees/:id`**
- **Logic**: Fetch the employee. Do a self-join to fetch their manager's name as well.

### 2. Get Org Chart under Employee
**GET `/api/employees/:id/reports`**
- **Logic**: Fetch all employees where `manager_id = :id`. To get deeper levels (reports of reports), use a Recursive CTE in SQL or fetch iteratively in code.
