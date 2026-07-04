# Car Rental System

## 🏗️ Architecture: Design Before Coding

**The Problem:**
You have a Toyota Camry. User A wants to rent it from Monday to Thursday. User B wants to rent it from Wednesday to Friday. This is a double-booking. We must prevent date overlaps.

**The Solution:**
SQL handles this beautifully using `OVERLAPS` or simple date math (`start1 < end2 AND start2 < end1`). 

**Database Architecture:**
```text
Cars
├─ id
├─ make
├─ model
└─ daily_rate

Bookings
├─ id
├─ car_id
├─ user_id
├─ start_date (DATE)
├─ end_date (DATE)
└─ status (ENUM: Confirmed, Cancelled, Completed)
```
