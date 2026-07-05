# 🏢 Employee Management System (HRIS): API Design

**"Build a multi-user API where Admins manage company departments, Managers oversee their assigned employees, and Employees can view the company directory."**

---

## 🔗 API Endpoints

*(All routes require Authentication via JWT)*

**Admin Operations (Requires 'admin' role):**
```
POST   /api/departments        → Create a new department
PUT    /api/departments/:id    → Update department (e.g., assign manager)
POST   /api/users              → Provision a new employee/manager account
```

**Manager Operations (Requires 'manager' role):**
```
GET    /api/departments/my-team  → List all employees in my department
PUT    /api/users/:id/title      → Update job title for an employee (Must be in my department)
```

**Employee/Shared Operations (All roles):**
```
GET    /api/directory          → Search the company directory
GET    /api/users/me           → View my own full profile
```

---

## 📦 Request/Response Examples

### 1. Search Directory (Employee)

**Request:**
```http
GET /api/directory?name=Smith&department=Sales HTTP/1.1
```

**Response (200):**
```json
{
  "results": [
    {
      "id": "emp-123",
      "full_name": "John Smith",
      "job_title": "Sales Executive",
      "department": "Sales",
      "email": "jsmith@company.com"
    },
    {
      "id": "emp-456",
      "full_name": "Jane Smith",
      "job_title": "Account Manager",
      "department": "Sales",
      "email": "jane.smith@company.com"
    }
  ]
}
```

### 2. View My Team (Manager)

The backend determines which department the manager runs and fetches the roster.

**Request:**
```http
GET /api/departments/my-team HTTP/1.1
```

**Response (200):**
```json
{
  "department_name": "Sales",
  "total_headcount": 12,
  "team_members": [
    {
      "id": "emp-123",
      "full_name": "John Smith",
      "job_title": "Sales Executive",
      "hire_date": "2023-01-15"
    }
  ]
}
```

### 3. Update Employee Title (Manager)

A manager attempts to promote someone.

**Request:**
```json
PUT /api/users/emp-123/title
{
  "job_title": "Senior Sales Executive"
}
```

**Response (200):**
```json
{
  "message": "Job title updated successfully",
  "employee": {
    "id": "emp-123",
    "full_name": "John Smith",
    "new_title": "Senior Sales Executive"
  }
}
```

---

## ⚠️ Error Responses

```json
// 403 Forbidden (Manager tries to update title of an employee in a DIFFERENT department)
{ "error": "You do not have permission to manage this employee." }

// 409 Conflict (Admin tries to create a department name that already exists)
{ "error": "A department with this name already exists." }

// 400 Bad Request (Admin tries to assign a manager who is already managing another department)
{ "error": "This user is already managing a department." }
```
