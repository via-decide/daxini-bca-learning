# 📚 Tutoring Platform API: Learn By Building

**"Build a multi-user API where Tutors define their availability slots, and Students book sessions using those slots without causing double-bookings."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. Tutor Tom signs up.
2. Tom creates two available 1-hour slots for Monday: 10:00 AM and 11:00 AM.
3. Student Sally sees Tom's profile and books the 10:00 AM slot.
4. Student Sam tries to book the 10:00 AM slot, but the system prevents it because Sally already took it. Sam books 11:00 AM instead.

**What data do you need for each?**

After thinking, here's the data model:

```
Table: Users (Tutors, Students)
├─ id (UUID)
├─ email (String)
├─ password_hash (String)
└─ role (Enum: 'tutor', 'student')

Table: Tutor_Profiles
├─ id (UUID)
├─ tutor_id (Foreign Key -> Users)
├─ subjects (String)
└─ hourly_rate (Decimal)

Table: Availability_Slots (The Inventory)
├─ id (UUID)
├─ tutor_id (Foreign Key -> Users)
├─ start_time (DateTime)
├─ end_time (DateTime)
└─ is_booked (Boolean - Default False)

Table: Bookings (The Transaction)
├─ id (UUID)
├─ slot_id (Foreign Key -> Availability_Slots)
├─ student_id (Foreign Key -> Users)
├─ status (Enum: 'confirmed', 'cancelled')
└─ created_at (DateTime)
```

---

### Step 2: The Double Booking Problem (Race Conditions)

**Question: Sally and Sam both click "Book" on the 10:00 AM slot at the exact same millisecond. How do you ensure only one person gets it?**

**Bad Idea:**
```javascript
const slot = await db.query("SELECT is_booked FROM availability_slots WHERE id = ?", slot_id);
if (!slot.is_booked) {
  await db.query("INSERT INTO bookings...");
  await db.query("UPDATE availability_slots SET is_booked = true...");
}
```
Because of asynchronous execution, both requests run the `SELECT` at the same time, both see `is_booked = false`, and both insert a booking. You just double-booked Tom.

**Good Idea:**
Put a `UNIQUE` constraint on `(slot_id, status)` in the Bookings table where `status = 'confirmed'`. 
Or, use the `UPDATE` statement as an atomic lock.
```sql
UPDATE availability_slots SET is_booked = true WHERE id = ? AND is_booked = false;
-- If affectedRows == 0, someone else got it first!
```

---

### Step 3: Dealing with Timezones

**Question: Tom is in New York (EST). Sally is in London (GMT). When Tom creates a 10:00 AM slot, what time is it for Sally?**

**Bad Idea:** Storing "10:00 AM" as a simple string or a naive datetime in the database.

**Good Idea:** ALWAYS store dates in the database in **UTC**. The frontend must convert Tom's local 10:00 AM to UTC before sending it to the backend. When Sally fetches the slots, her browser converts the UTC time to her local London time. The Backend only speaks UTC.

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Tutor Dashboard (Manage Slots)       │  │
│  │ Student Portal (Search & Book)       │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP requests with JWT (RBAC)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. Timezone Handler (UTC Enforcer)   │  │
│  │ 2. Atomic Slot Booking Engine        │  │
│  │ 3. Booking Cancellation Logic        │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (PostgreSQL/MySQL)         │
│  - users, slots, bookings tables           │
└────────────────────────────────────────────┘
```
