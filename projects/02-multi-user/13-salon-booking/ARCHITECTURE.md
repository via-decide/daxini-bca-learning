# ✂️ Salon Booking API: Learn By Building

**"Build a scheduling API for a salon where Customers book distinct Services (like Haircuts or Coloring) with specific Stylists, managing varying service durations and preventing overlap."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. The salon offers a "Men's Haircut" (30 minutes, $30) and "Hair Coloring" (120 minutes, $150).
2. Stylist Sarah works 9 AM to 5 PM.
3. Customer John books a "Hair Coloring" with Sarah at 10:00 AM.
4. The system must block out Sarah's schedule from 10:00 AM to 12:00 PM.
5. Another customer tries to book a 30-minute haircut with Sarah at 11:30 AM. The system rejects it.

**What data do you need for each?**

After thinking, here's the data model:

```
Table: Users (Stylists & Customers)
├─ id (UUID)
├─ email (String)
├─ password_hash (String)
└─ role (Enum: 'stylist', 'customer')

Table: Services
├─ id (UUID)
├─ name (String)
├─ duration_minutes (Integer)
└─ price (Decimal)

Table: Stylist_Services (Which stylist can do which service?)
├─ stylist_id (Foreign Key -> Users)
└─ service_id (Foreign Key -> Services)

Table: Appointments
├─ id (UUID)
├─ customer_id (Foreign Key -> Users)
├─ stylist_id (Foreign Key -> Users)
├─ service_id (Foreign Key -> Services)
├─ appointment_date (Date)
├─ start_time (Time)
├─ end_time (Time) -- Derived from start_time + service duration
└─ status (Enum: 'booked', 'completed', 'cancelled')
```

---

### Step 2: Varying Durations vs Fixed Slots

In a basic Clinic API, every appointment might be exactly 15 minutes. You can easily generate a list of slots: `[9:00, 9:15, 9:30]`.

In a Salon API, a haircut is 30 mins, but coloring is 120 mins. 
If someone books coloring from 10:00 to 12:00, you can't just rely on a `UNIQUE(date, time)` database constraint to prevent double-booking at 11:00.

**The Solution: Overlap Checking Queries**
Before saving an appointment, you must ask the database: "Does this stylist have any appointments on this date where the `start_time` is BEFORE my new `end_time` AND the `end_time` is AFTER my new `start_time`?"

---

### Step 3: Managing Stylist Capabilities

Not every stylist can do every service. Sarah might do haircuts, but only Mike does coloring.
This is a **Many-to-Many** relationship. A Stylist offers many Services, and a Service is offered by many Stylists. You need a junction table (`Stylist_Services`).

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Browse Services & Select Stylist     │  │
│  │ Calendar (Available Times)           │  │
│  │ Stylist Dashboard (My Schedule)      │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP requests with JWT (RBAC)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. Capability Validation (Can they?) │  │
│  │ 2. Time Overlap Algorithm (SQL)      │  │
│  │ 3. Booking Engine                    │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (PostgreSQL/MySQL)         │
│  - users, services, appointments tables    │
└────────────────────────────────────────────┘
```
