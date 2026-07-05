# 🏢 Employee Management System (HRIS): Learn By Building

**"Build a multi-user API where Admins manage company departments, Managers oversee their assigned employees, and Employees can view the company directory."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Circular Foreign Keys** - How to design and initialize a schema where Table A depends on Table B, and Table B depends on Table A.  
✅ **Hierarchical RBAC (Scope Validation)** - Going beyond simple "is this user a manager?" and enforcing "is this user the manager *for this specific resource*?" using SQL `WHERE` clauses.  
✅ **Safe Search Queries** - Using SQL `LIKE` with wildcards (`%`) safely via Parameterized Queries to prevent SQL injection.

---

## 📋 Project Overview

### The Problem

In a company, access isn't just about your job title (Admin, Manager, Employee). It's about your *scope*. 

A Manager has high privileges, but *only* within the boundaries of their assigned department. If your backend only checks `if (role === 'manager')`, you have created a massive security hole where any manager can edit any employee in the entire company.

Furthermore, employees need to search for each other. Building a search feature requires understanding how to query partial text strings safely in SQL.

**Your job:** Build an API that enforces strict departmental boundaries for managers, handles the circular logic of Departments and Managers, and provides a safe search endpoint.

### Who Uses It

```
Admin:
├─ POST /api/departments (Creates organization structure)
└─ POST /api/users (Onboards new staff)

Manager:
├─ GET /api/departments/my-team (Views their roster)
└─ PUT /api/users/:id/title (Updates their staff)

Employee:
└─ GET /api/directory (Searches for colleagues)
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. Hierarchical Scope (Updating an Employee)

When a manager tries to edit someone, the SQL query itself must verify the boundary.

```pseudocode
PUT /api/users/:id/title:
  middlewares: [authenticateUser, requireRole(['manager'])]
  
  target_emp_id = request.params.id
  new_title = request.body.job_title
  
  // 1. We ONLY update the target employee IF their department_id 
  // matches the Manager's department_id.
  result = db.query(`
    UPDATE users 
    SET job_title = ? 
    WHERE id = ? AND department_id = ?
  `, [new_title, target_emp_id, req.user.department_id])
  
  // 2. If no rows were changed, either the employee doesn't exist, 
  // or they are in a different department.
  if result.affectedRows === 0:
    return 403 "Forbidden: Employee not found in your department."
    
  return 200 "Title updated."
```

### 2. The Directory Search (Safe LIKE)

```pseudocode
GET /api/directory:
  middlewares: [authenticateUser] // Anyone can search
  
  // Grab query parameters (e.g. ?name=Smith&dept=Sales)
  search_name = request.query.name
  search_dept = request.query.department
  
  // Base query
  sql = `
    SELECT u.id, u.full_name, u.job_title, d.name as department
    FROM users u
    LEFT JOIN departments d ON u.department_id = d.id
    WHERE 1=1
  `
  params = []
  
  // Safely add name search
  if search_name:
    sql += " AND u.full_name LIKE ?"
    params.push("%" + search_name + "%") // Add wildcards in Javascript
    
  // Safely add department search
  if search_dept:
    sql += " AND d.name = ?"
    params.push(search_dept)
    
  // Execute
  results = db.query(sql, params)
  
  return 200 { results: results }
```

### 3. Viewing "My Team"

```pseudocode
GET /api/departments/my-team:
  middlewares: [authenticateUser, requireRole(['manager'])]
  
  if !req.user.department_id:
    return 400 "You are not assigned to a department."
    
  // Get department info
  dept = db.query("SELECT name FROM departments WHERE id = ?", req.user.department_id)
  
  // Get the roster
  roster = db.query(`
    SELECT id, full_name, job_title, hire_date 
    FROM users 
    WHERE department_id = ?
    ORDER BY full_name ASC
  `, req.user.department_id)
  
  return 200 {
    department: dept.name,
    total_headcount: roster.length,
    team_members: roster
  }
```

---

## ✅ Before Submission

- [ ] System supports Admin, Manager, and Employee roles.
- [ ] Database schema properly links Users to Departments, and Departments to a Manager.
- [ ] Managers can only update employees who share their `department_id`.
- [ ] Directory search uses parameterized `LIKE` queries to prevent SQL injection.
- [ ] Search endpoints do not return sensitive data like `password_hash`.
- [ ] Code is on GitHub.

**Success:** You have built a secure Hierarchical RBAC system!
