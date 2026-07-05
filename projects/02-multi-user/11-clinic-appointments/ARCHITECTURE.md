# 🩺 Clinic Appointments API: Learn By Building

**"Build a scheduling API where Doctors define their weekly availability, and Patients book specific 15-minute time slots, requiring strict time-boundary logic and overlap prevention."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. Dr. Smith sets her schedule: Monday 9:00 AM to 5:00 PM, with 15-minute appointment slots.
2. Patient Bob books an appointment with Dr. Smith for Monday at 10:15 AM.
3. Patient Alice tries to book Dr. Smith for Monday at 10:15 AM. The system rejects it.
4. Patient Charlie tries to book Dr. Smith for Monday at 8:00 AM. The system rejects it (Doctor is not working).

**What data do you need for each?**

After thinking, here's the data model:

```
Table: Users (Doctors & Patients)
├─ id (UUID)
├─ role (Enum: 'doctor', 'patient')
└─ full_name (String)

Table: Doctor_Schedules
├─ id (UUID)
├─ doctor_id (Foreign Key -> Users)
├─ day_of_week (Integer: 0=Sun, 1=Mon, ..., 6=Sat)
├─ start_time (Time - e.g., '09:00:00')
└─ end_time (Time - e.g., '17:00:00')

Table: Appointments
├─ id (UUID)
├─ doctor_id (Foreign Key -> Users)
├─ patient_id (Foreign Key -> Users)
├─ appointment_date (Date - e.g., '2026-10-12')
├─ start_time (Time - e.g., '10:15:00')
└─ status (Enum: 'scheduled', 'completed', 'cancelled')
```

---

### Step 2: The "Time Slot" Problem

**Question: How do you show a patient all the available 15-minute slots for next Monday?**

**Bad Idea:** Store a database row for every single 15-minute slot for the next 10 years (`9:00`, `9:15`, `9:30`...). This creates millions of useless rows.

**Good Idea:** Calculate it on the fly in Node.js.
1. Fetch the Doctor's schedule for Monday (e.g., 9:00 to 12:00).
2. Fetch all *existing* appointments for that Doctor on that specific date.
3. Write a JavaScript loop that starts at 9:00, adds 15 minutes repeatedly until 12:00. If the generated slot doesn't exist in the appointments array, add it to the `available_slots` array to send to the frontend!

---

### Step 3: Preventing Overlaps (The Composite Unique Constraint)

You need to guarantee that no two patients can book the exact same slot with the exact same doctor.

In previous projects, we used Transactions to check overlapping date ranges. Here, because appointments are fixed exactly to a specific date and time, we can use a simpler, bulletproof Database Constraint.

```sql
-- You cannot have two rows with the same Doctor, Date, and Time.
-- If someone tries to book an already booked slot, the database will instantly throw an error.
CREATE UNIQUE INDEX idx_no_double_booking 
ON appointments(doctor_id, appointment_date, start_time) 
WHERE status = 'scheduled';
```

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Doctor: Set Availability UI          │  │
│  │ Patient: Calendar & Slot Picker      │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP requests with JWT (RBAC)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. Time Slot Generator Algorithm     │  │
│  │ 2. Validation (Is Doctor working?)   │  │
│  │ 3. Booking Engine (Unique Index)     │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (PostgreSQL/MySQL)         │
│  - users, schedules, appointments tables   │
└────────────────────────────────────────────┘
```
