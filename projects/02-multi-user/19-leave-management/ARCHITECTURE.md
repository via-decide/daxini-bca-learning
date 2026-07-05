# 🌴 Leave Management System: Learn By Building

**"Build a multi-user API where Employees request time off (PTO/Sick leave), and Managers approve or reject these requests while the system strictly enforces available leave balances."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. Employee Ethan gets 20 days of Paid Time Off (PTO) per year and 5 Sick days.
2. Ethan applies for a 3-day vacation starting November 1st.
3. Manager Mary sees the request and clicks "Approve".
4. The system subtracts 3 days from Ethan's PTO balance. He now has 17 days left.
5. Ethan tries to apply for a 20-day vacation. The system rejects it because he only has 17 days.

**What data do you need for each?**

After thinking, here's the data model:

```
Table: Users (Managers, Employees)
├─ id (UUID)
├─ manager_id (Foreign Key -> Users - Self-referencing to establish who approves their leave)
├─ email (String)
├─ password_hash (String)
└─ role (Enum: 'manager', 'employee')

Table: Leave_Balances (The Bank Account)
├─ id (UUID)
├─ user_id (Foreign Key -> Users)
├─ leave_type (Enum: 'pto', 'sick')
└─ days_remaining (Integer)

Table: Leave_Requests (The Transactions)
├─ id (UUID)
├─ user_id (Foreign Key -> Users)
├─ leave_type (Enum: 'pto', 'sick')
├─ start_date (Date)
├─ end_date (Date)
├─ requested_days (Integer)
├─ status (Enum: 'pending', 'approved', 'rejected')
└─ manager_comment (String)
```

---

### Step 2: The Self-Referencing Manager

**Question: How does the system know who is supposed to approve Ethan's request?**

**Bad Idea:** The frontend sends `manager_id: "mary123"` in the JSON payload when applying for leave. (Ethan could just put his friend's ID and his friend could approve it).

**Good Idea:** The `Users` table has a `manager_id` column that points back to the `Users` table. The Backend looks this up automatically. Mary can only see `pending` requests where the `user.manager_id` matches her own ID.

---

### Step 3: The Overdraft Problem (Race Conditions)

**Question: Ethan has 5 days of PTO left. He opens two tabs. In Tab 1, he requests 4 days. At the exact same millisecond in Tab 2, he requests 4 days. If both are approved, his balance becomes -3.**

**Bad Idea:** 
```javascript
let balance = await db.query("SELECT days FROM leave_balances...");
if (balance >= 4) { await db.query("UPDATE leave_balances SET days = days - 4...") }
```

**Good Idea:**
Put a constraint on the Database level: `CHECK (days_remaining >= 0)`.
When the Manager approves the request, attempt the `UPDATE` query. If the balance drops below zero, the Database will throw a constraint error, effectively blocking the approval and preventing the overdraft.

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Employee Dashboard (Apply & Balances)│  │
│  │ Manager Inbox (Pending Approvals)    │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP requests with JWT (RBAC)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. Balance Validation Engine         │  │
│  │ 2. Hierarchical Approval Check       │  │
│  │ 3. Transactional Balance Deduction   │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (PostgreSQL/MySQL)         │
│  - users, balances, requests tables        │
└────────────────────────────────────────────┘
```
