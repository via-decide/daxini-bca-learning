# 🕒 Employee Attendance System: Learn By Building

**"Build a multi-user API where Employees clock in and out daily, and Managers view attendance reports to track tardiness and total hours worked."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. Employee Ethan arrives at 8:55 AM and clicks "Clock In".
2. Ethan leaves at 5:05 PM and clicks "Clock Out".
3. Manager Mary views a report for the week to see if Ethan was ever late (expected start time is 9:00 AM).
4. Ethan forgets to clock out on Tuesday. The system needs to flag this anomaly.

**What data do you need for each?**

After thinking, here's the data model:

```
Table: Users (Managers, Employees)
├─ id (UUID)
├─ email (String)
├─ password_hash (String)
├─ role (Enum: 'manager', 'employee')
└─ manager_id (Foreign Key -> Users - Hierarchy)

Table: Attendance_Records
├─ id (UUID)
├─ user_id (Foreign Key -> Users)
├─ date (Date - The calendar day)
├─ clock_in_time (DateTime)
├─ clock_out_time (DateTime - NULL initially)
├─ status (Enum: 'present', 'late', 'absent')
└─ notes (String - e.g., "Forgot to clock out")
```

---

### Step 2: The "Double Clock In" Problem

**Question: Ethan clicks "Clock In" at 9:00 AM. At 9:05 AM, he gets confused and clicks "Clock In" again. How do you prevent two records from being created for the same day?**

**Bad Idea:** Trusting the frontend to hide the "Clock In" button.

**Good Idea:** Enforce a Unique Constraint in the Database on `(user_id, date)`. This guarantees that an employee can only have ONE attendance record per calendar day. If they click it again, the database throws an error, which your API catches and returns as a `409 Conflict`.

---

### Step 3: Handling Missing Clock-Outs (The Midnight Cron Job)

What happens if Ethan clocks in, but goes home and never clocks out? The `clock_out_time` remains `NULL` forever. This breaks total hours calculations.

**Solution:** A Background Worker (Cron Job).
Every night at 11:59 PM, a script runs:
`UPDATE attendance_records SET notes = 'System Auto-Closed (Missing Clock Out)' WHERE clock_out_time IS NULL AND date = CURRENT_DATE;`
This flags the record so the Manager can manually intervene the next day.

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Employee Dashboard (Big In/Out Button│  │
│  │ Manager Panel (Daily Reports)        │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP requests with JWT (RBAC)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. Time State Machine (In vs Out)    │  │
│  │ 2. Tardiness Calculator (Math)       │  │
│  │ 3. Nightly Anomaly Sweeper (Cron)    │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (PostgreSQL/MySQL)         │
│  - users, attendance_records tables        │
└────────────────────────────────────────────┘
```
