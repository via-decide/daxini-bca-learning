# 💪 Gym Management System: Learn By Building

**"Build a complete system for managing gyms. Understand databases, roles, and complex workflows."**

---


## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. Admin checks how many members are currently active
2. Member logs a workout (exercise: chest press, 4 sets, 8 reps)
3. System checks if membership is expired
4. Admin wants to know attendance for this month
5. Member renews membership

**What data do you need for each?**

After thinking, here's the data model:

```
Users (for login)
├─ id
├─ email (unique)
├─ password (hashed)
├─ name
├─ role (admin or member)
└─ created_at

Members (member information)
├─ id
├─ user_id (links to Users)
├─ phone
├─ age
├─ weight
├─ height
├─ join_date
└─ status (active/inactive)

Memberships (membership packages and purchases)
├─ id
├─ member_id
├─ package_id
├─ start_date
├─ end_date
├─ amount_paid
└─ status (active/expired/renewed)

Packages (membership types offered)
├─ id
├─ name (Basic, Premium, etc)
├─ duration_months
├─ price
└─ features (comma-separated or separate table)

Attendance (check-in records)
├─ id
├─ member_id
├─ date
├─ check_in_time
├─ check_out_time
├─ duration_minutes
└─ notes

Workouts (exercise logs)
├─ id
├─ member_id
├─ date
├─ exercise_name
├─ sets
├─ reps
├─ weight
└─ notes
```

---

### Step 2: Database Architecture

```
┌──────────────────────────────────────────┐
│              Database                    │
├──────────────────────────────────────────┤
│                                          │
│  users ─────────┐                        │
│                 │                        │
│                 ├──► members             │
│                 │       │                │
│                 │       ├──► memberships │
│                 │       │                │
│                 │       ├──► attendance  │
│                 │       │                │
│                 │       └──► workouts    │
│                 │                        │
│  packages ──────┘                        │
│                                          │
└──────────────────────────────────────────┘

Relationships:
- users.id → members.user_id (one user, one member)
- members.id → memberships.member_id (one member, many memberships)
- packages.id → memberships.package_id (many members use one package)
- members.id → attendance.member_id (one member, many attendance records)
- members.id → workouts.member_id (one member, many workouts)
```

---

### Step 3: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML)             │
│  ┌──────────────────────────────────────┐  │
│  │ Login Screen                         │  │
│  │ Admin Dashboard                      │  │
│  │ Member Management                    │  │
│  │ Attendance Tracking                  │  │
│  │ Workout Logging                      │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP Requests
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ Authentication Layer                 │  │
│  │  - Login (password check)            │  │
│  │  - JWT token generation              │  │
│  │  - Token verification                │  │
│  ├──────────────────────────────────────┤  │
│  │ Authorization Layer                  │  │
│  │  - Check user role (admin/member)    │  │
│  │  - Verify permissions                │  │
│  ├──────────────────────────────────────┤  │
│  │ API Endpoints                        │  │
│  │  - Members CRUD                      │  │
│  │  - Memberships CRUD                  │  │
│  │  - Attendance tracking               │  │
│  │  - Workouts CRUD                     │  │
│  │  - Dashboard stats                   │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        SQL Queries
              │
              ▼
┌────────────────────────────────────────────┐
│        Database (SQLite/PostgreSQL)        │
│  - Persistent data storage                 │
│  - Relationships and constraints           │
│  - Indexing for fast queries               │
└────────────────────────────────────────────┘
```

---
