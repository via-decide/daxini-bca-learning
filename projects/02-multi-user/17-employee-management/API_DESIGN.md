## 🔌 API Design: Plan Before Coding

### 1. Onboard Employee
**POST `/api/employees`**
- **Body**: `{ "first_name": "John", "department_id": "1", "role_id": "2" }`
- **Logic**: Simple `INSERT`.

### 2. Get Employee Profile
**GET `/api/employees/:id`**
- **Logic**: `SELECT e.first_name, d.name AS department, r.title AS role FROM employees e JOIN departments d ON e.department_id = d.id JOIN roles r ON e.role_id = r.id WHERE e.id = X`.
