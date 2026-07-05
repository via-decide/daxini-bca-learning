# 🏨 Hotel Booking System: Learn By Building

**"Build a reservation backend where Users can search for available rooms, Staff can manage bookings, and Administrators can manage inventory, featuring real-time availability checks to prevent double-booking."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. A User searches for a "Deluxe" room available from Oct 1 to Oct 5.
2. The user books Room 101.
3. Another user tries to book Room 101 for Oct 3 to Oct 7. The system must reject it.
4. A Receptionist marks a booking as "checked-in".

**What data do you need for each?**

After thinking, here's the data model:

```
Table: Users
├─ id (UUID)
├─ email (String)
├─ password_hash (String)
└─ role (Enum: 'guest', 'receptionist', 'admin')

Table: Rooms
├─ id (UUID)
├─ room_number (String)
├─ type (Enum: 'standard', 'deluxe', 'suite')
├─ price_per_night (Decimal)
└─ is_active (Boolean - e.g., false if under maintenance)

Table: Bookings
├─ id (UUID)
├─ user_id (Foreign Key -> Users)
├─ room_id (Foreign Key -> Rooms)
├─ check_in_date (Date)
├─ check_out_date (Date)
├─ total_price (Decimal)
└─ status (Enum: 'pending', 'confirmed', 'checked_in', 'checked_out', 'cancelled')
```

---

### Step 2: The Double-Booking Problem (Concurrency)

**Question: How do you prevent two people from booking the same room for the same dates at the exact same millisecond?**

**Bad Idea:**
```javascript
// 1. Check if room is available
const existing = await db.query("SELECT * FROM bookings WHERE room_id = X AND dates overlap");

if (existing.length === 0) {
  // 2. Book it!
  await db.query("INSERT INTO bookings ...");
}
```
*Why it's bad:* This is a classic **Race Condition**. Two users run Step 1 at the same millisecond. Both get `length === 0`. Both proceed to Step 2. You just double-booked a room and ruined someone's vacation.

**Good Idea (Database Transactions & Locking):**
You must lock the row or use an atomic transaction with a strict overlapping date constraint in the database itself.

```sql
-- Advanced databases (like PostgreSQL) allow you to prevent overlapping date ranges at the schema level using EXCLUDE constraints.
-- Or, in application logic, you use a SERIALIZABLE transaction.
BEGIN TRANSACTION;
  -- Query to check availability...
  -- Insert...
COMMIT;
```

---

### Step 3: Searching for Availability

Searching for "available rooms" is actually a negative search. You aren't looking for rooms that *are* available, you are looking for ALL rooms, *minus* the rooms that are already booked for those dates.

**The Logic:**
Give me all rooms WHERE the `room_id` is NOT IN (the list of bookings where the dates overlap).

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Guest (Search & Book)                │  │
│  │ Reception (Check In/Out)             │  │
│  │ Admin (Add/Remove Rooms)             │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP requests with JWT in Authorization header
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. Authentication & RBAC             │  │
│  │ 2. Availability Engine (SQL queries) │  │
│  │ 3. Booking Engine (Transactions)     │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (PostgreSQL/MySQL)         │
│  - users table                             │
│  - rooms table                             │
│  - bookings table (with overlapping rules) │
└────────────────────────────────────────────┘
```
