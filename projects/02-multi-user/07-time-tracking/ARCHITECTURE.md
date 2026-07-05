# ⏱️ Time Tracking API: Learn By Building

**"Build a multi-user API where freelancers log hours against client projects, generating automated invoices and tracking real-time productivity."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. A Freelancer creates a "Client: Acme Corp".
2. The Freelancer creates a "Project: Website Design" for Acme Corp, with an hourly rate of $50.
3. The Freelancer clicks "Start Timer". 2 hours later, they click "Stop Timer".
4. At the end of the month, they generate a total invoice for Acme Corp.

**What data do you need for each?**

After thinking, here's the data model:

```
Table: Users (Freelancers)
├─ id (UUID)
├─ email (String)
└─ password_hash (String)

Table: Clients
├─ id (UUID)
├─ user_id (Foreign Key -> Users) -- Who owns this client
├─ name (String)
└─ email (String)

Table: Projects
├─ id (UUID)
├─ client_id (Foreign Key -> Clients)
├─ name (String)
└─ hourly_rate (Decimal)

Table: Time_Entries
├─ id (UUID)
├─ project_id (Foreign Key -> Projects)
├─ start_time (DateTime)
├─ end_time (DateTime - Nullable if currently running)
├─ description (String)
└─ is_billed (Boolean)
```

---

### Step 2: The "Running Timer" Problem

**Question: How do you handle a timer that is currently running?**

**Bad Idea:** The frontend runs a `setInterval` and sends a PUT request to the backend every 1 second to update the `duration` in the database.
*Why it's bad:* If 100 users are tracking time, that's 100 database writes per second. Your server will crash. If the user's laptop battery dies, the timer stops tracking.

**Good Idea:** The backend only records the *events*.
1. User clicks "Start" -> Insert row: `start_time = NOW()`, `end_time = NULL`.
2. The frontend uses its local clock to show a ticking counter (purely visual).
3. User clicks "Stop" -> Update row: `end_time = NOW()`.
4. The database mathematically calculates `duration = end_time - start_time` later.

---

### Step 3: Complex Aggregation (Invoicing)

At the end of the month, the freelancer wants to know: "How much does Acme Corp owe me?"
This requires calculating the duration of every time entry, multiplying it by the project's hourly rate, and summing it all up.

**Bad Idea:** Pulling all rows into Node.js, doing the math in a `for` loop.
**Good Idea:** A SQL query using `SUM()` and date math.

```sql
SELECT 
  SUM((STRFTIME('%s', end_time) - STRFTIME('%s', start_time)) / 3600.0 * projects.hourly_rate) as total_owed
FROM time_entries
JOIN projects ON time_entries.project_id = projects.id
WHERE projects.client_id = 'acme-123' AND is_billed = 0;
```
*(The exact date math syntax depends on whether you use Postgres, MySQL, or SQLite, but the concept is the same: The Database does the math!)*

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Dashboard (Active Timers)            │  │
│  │ Client/Project Manager               │  │
│  │ Invoice Generator (Charts/Tables)    │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP requests with JWT (State changes)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. JWT Authentication                │  │
│  │ 2. Timer State Machine (Start/Stop)  │  │
│  │ 3. Invoice Math Engine (SQL Aggs)    │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (PostgreSQL/MySQL)         │
│  - users, clients, projects, time_entries  │
└────────────────────────────────────────────┘
```
