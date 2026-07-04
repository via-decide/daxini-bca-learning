## 🛠️ Debugging & Verification

**Test 1: Joins**
- Query an employee. Ensure the JSON response contains the actual names of the Department and Role, not just the UUIDs.

**Test 2: Terminated Exclusion**
- Query `/api/employees/active`. Ensure employees with status `terminated` are successfully filtered out of the directory search.
