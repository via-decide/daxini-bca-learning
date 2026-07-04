## ⚠️ Common Mistakes

❌ **Mistake 1: Hardcoding Departments**
If you make `department` a `VARCHAR` column on the Employee table, someone will type "Eng", someone else "Engineering", someone else "Engineers". Grouping data becomes impossible. Always use a foreign key to a Lookup table.

❌ **Mistake 2: Hard Deleting Employees**
When an employee quits, if you run `DELETE FROM employees WHERE id = X`, you will break the Payroll, Leave, and Attendance tables that reference that ID. Always use a `status = 'terminated'` soft delete.
