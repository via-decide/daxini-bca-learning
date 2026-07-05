# 📝 Complaint Management System: Learn By Building

**"Build a multi-user API for a city or large organization where Citizens submit complaints (like Potholes), and City Workers claim, update, and resolve those complaints via a strict state machine."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. Citizen Charlie submits a complaint: "Pothole on 5th Ave". It is marked 'open'.
2. City Worker Wendy sees the complaint and clicks "Claim". It is assigned to her and marked 'in_progress'.
3. Wendy fixes the pothole and adds a comment: "Filled with asphalt."
4. Wendy marks it 'resolved'.

**What data do you need for each?**

After thinking, here's the data model:

```
Table: Users (Citizens & Workers)
├─ id (UUID)
├─ email (String)
├─ password_hash (String)
└─ role (Enum: 'citizen', 'worker', 'admin')

Table: Categories
├─ id (UUID)
├─ name (String - e.g., 'Roads', 'Sanitation')
└─ department_head_id (Foreign Key -> Users)

Table: Complaints
├─ id (UUID)
├─ citizen_id (Foreign Key -> Users)
├─ category_id (Foreign Key -> Categories)
├─ worker_id (Foreign Key -> Users - NULL initially)
├─ title (String)
├─ description (String)
├─ status (Enum: 'open', 'in_progress', 'resolved', 'closed')
└─ created_at (DateTime)

Table: Comments (The Activity Log)
├─ id (UUID)
├─ complaint_id (Foreign Key -> Complaints)
├─ user_id (Foreign Key -> Users) -- Who wrote this?
├─ content (String)
└─ created_at (DateTime)
```

---

### Step 2: The State Machine (Validating Transitions)

A "State Machine" is a computer science concept where an object can only be in one State at a time, and can only transition to specific other states.

**Bad Idea:** An API endpoint `PUT /api/complaints/:id` that lets a user update the status to anything they want. A citizen could change their complaint from 'open' directly to 'resolved' to mess with the metrics, or from 'closed' back to 'in_progress'.

**Good Idea:** The Backend strictly enforces State Transitions.
- `open` -> `in_progress` (Only a Worker can do this, via claiming)
- `in_progress` -> `resolved` (Only the assigned Worker can do this)
- `resolved` -> `closed` (Only the Citizen who made it, or an Admin, can do this)

---

### Step 3: Cascading Deletions and Data Integrity

If a Citizen deletes their account, what happens to their complaints?
If you use `ON DELETE CASCADE`, the complaints vanish. But for a city, that pothole still exists even if the citizen moved away! 

You must use `ON DELETE SET NULL` for the `citizen_id` so the city still knows about the problem, even if the reporter is gone.

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Citizen App (Submit & Track)         │  │
│  │ Worker Dashboard (Claim & Update)    │  │
│  │ Admin Metrics (Resolution Times)     │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP requests with JWT (RBAC)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. State Machine Enforcer            │  │
│  │ 2. Ownership & RBAC Validator        │  │
│  │ 3. Activity Log (Comments)           │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (PostgreSQL/MySQL)         │
│  - users, complaints, comments tables      │
└────────────────────────────────────────────┘
```
