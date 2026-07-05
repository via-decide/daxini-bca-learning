# 🏢 Employee Management System (HRIS): Learn By Building

**"Build a multi-user API where Admins manage company departments, Managers oversee their assigned employees, and Employees can view the company directory."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. The company has a "Sales" department and an "Engineering" department.
2. Manager Mark is the head of the "Sales" department.
3. Employee Emma works in the "Sales" department.
4. Mark needs to see all employees in his department.
5. Emma wants to search the company directory for someone in "Engineering".

**What data do you need for each?**

After thinking, here's the data model:

```
Table: Users (Admins, Managers, Employees)
├─ id (UUID)
├─ email (String)
├─ password_hash (String)
├─ role (Enum: 'admin', 'manager', 'employee')
├─ full_name (String)
├─ job_title (String)
└─ hire_date (Date)

Table: Departments
├─ id (UUID)
├─ name (String - Unique)
└─ manager_id (Foreign Key -> Users, NULLable if no manager assigned yet)

Table: Department_Employees (The Roster)
├─ department_id (Foreign Key -> Departments)
└─ employee_id (Foreign Key -> Users)
```

*(Note: We use a junction table `Department_Employees` to allow for employees moving departments without losing history, or simply put a `department_id` on the `Users` table if an employee can only ever be in one department at a time. Let's stick to the simpler 1-to-Many approach: An employee belongs to one department).*

**Revised Simpler Data Model:**
```
Table: Users (Admins, Managers, Employees)
├─ id (UUID)
├─ department_id (Foreign Key -> Departments, NULLable)
├─ email (String)
├─ password_hash (String)
├─ role (Enum: 'admin', 'manager', 'employee')
├─ full_name (String)
├─ job_title (String)
└─ hire_date (Date)

Table: Departments
├─ id (UUID)
├─ name (String - Unique)
└─ manager_id (Foreign Key -> Users - Who runs this department?)
```

---

### Step 2: The Circular Dependency Problem

**Question: If a User needs a Department, and a Department needs a Manager (who is a User), which one do you create first?**

**Bad Idea:** Trying to `INSERT` a new department and its new manager in a single SQL statement.

**Good Idea:**
1. Create the Manager (User) with `department_id = NULL`.
2. Create the Department with `manager_id = the_new_manager_id`.
3. Update the Manager (User) to set `department_id = the_new_department_id`.
This requires carefully managed SQL updates, or allowing NULLs on foreign keys.

---

### Step 3: Hierarchical Access Control (RBAC)

**Admin:** Can see and edit anyone.
**Manager:** Can see anyone, but can only edit employees WHERE `employee.department_id === manager.department_id`.
**Employee:** Can only see public profiles of others, can only edit themselves.

You must build SQL queries that dynamically check the requester's role.

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Company Directory (Search)           │  │
│  │ Manager Roster (My Team)             │  │
│  │ Admin Panel (Department Setup)       │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP requests with JWT (RBAC)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. RBAC Hierarchy Validator          │  │
│  │ 2. Department Assignment Engine      │  │
│  │ 3. Directory Search (SQL LIKE)       │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (PostgreSQL/MySQL)         │
│  - users, departments tables               │
└────────────────────────────────────────────┘
```
