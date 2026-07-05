# ✂️ Salon Booking API: Learn By Building

**"Build a scheduling API for a salon where Customers book distinct Services (like Haircuts or Coloring) with specific Stylists, managing varying service durations and preventing overlap."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **The Universal Overlap Algorithm** - The standard mathematical logic used to detect if two time periods intersect, crucial for any calendar or booking application.  
✅ **Derived Data Calculations** - Fetching a base value (`duration_minutes`) and using Javascript Date math to calculate an end state (`end_time`) on the server securely.  
✅ **Many-to-Many Validation** - Checking a junction table (`stylist_services`) to ensure a requested combination is actually valid before proceeding.

---

## 📋 Project Overview

### The Problem

If a doctor's appointments are all exactly 15 minutes, you can easily divide a day into blocks and check if a block is taken.

But what if a customer books a 120-minute hair coloring starting at 10:15 AM? 
You cannot use simple grid-blocks. You must treat time as a continuous spectrum. If another customer tries to book a 30-minute haircut at 11:30 AM, the database must recognize that this falls *inside* the 120-minute window of the first appointment and reject it.

**Your job:** Build an API that perfectly calculates end-times based on service duration, and uses a bulletproof SQL query to prevent any overlapping appointments.

### Who Uses It

```
Customer:
├─ GET /api/services (Sees what they can book)
└─ POST /api/appointments (Books a service with a specific stylist)

Stylist:
└─ GET /api/stylist/schedule (Checks their daily itinerary)
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. The Booking Engine (Validation & Math)

```pseudocode
POST /api/appointments:
  middlewares: [authenticateUser, requireRole(['customer'])]
  
  req_stylist_id = request.body.stylist_id
  req_service_id = request.body.service_id
  req_date = request.body.appointment_date
  req_start_time = request.body.start_time
  
  // 1. Capability Validation (Can this stylist do this service?)
  can_do = db.query(`
    SELECT * FROM stylist_services 
    WHERE stylist_id = ? AND service_id = ?
  `, [req_stylist_id, req_service_id])
  
  if !can_do: return 400 "Stylist does not offer this service."
  
  // 2. Fetch Duration & Calculate End Time (Server-side Math!)
  service = db.query("SELECT duration_minutes FROM services WHERE id = ?", req_service_id)
  
  // You will need a JS helper function to add minutes to a "HH:MM:SS" string
  req_end_time = addMinutesToTime(req_start_time, service.duration_minutes)
  
  // ... Continue to Overlap check ...
```

### 2. The Universal Overlap Formula

Two periods overlap if: `(NewStart < OldEnd) AND (NewEnd > OldStart)`.
We must check if ANY existing appointment matches this formula for the requested stylist and date.

*(Note: We use `<` and `>` rather than `<=` because back-to-back appointments where one ends at 10:00 and the other starts at 10:00 are allowed).*

```pseudocode
  // ... Continued from Booking Engine ...
  
  // 3. The Overlap Check
  // We check if count > 0. If it is, there is an overlap.
  overlap_check = db.query(`
    SELECT COUNT(*) as conflicts
    FROM appointments
    WHERE stylist_id = ? 
      AND appointment_date = ?
      AND status = 'booked'
      AND (? < end_time)     -- req_start_time < OldEnd
      AND (? > start_time)   -- req_end_time > OldStart
  `, [req_stylist_id, req_date, req_start_time, req_end_time])
  
  if overlap_check.conflicts > 0:
    return 409 "The stylist is already booked during this time period."
    
  // 4. Safe to Book!
  db.query(`
    INSERT INTO appointments (id, customer_id, stylist_id, service_id, appointment_date, start_time, end_time)
    VALUES (UUID(), ?, ?, ?, ?, ?, ?)
  `, [req.user.id, req_stylist_id, req_service_id, req_date, req_start_time, req_end_time])
  
  return 201 "Booked!"
```

### 3. Fetching the Daily Schedule (With Joins)

The stylist wants to see their schedule for the day, including the customer's name and the service they are performing.

```pseudocode
GET /api/stylist/schedule:
  middlewares: [authenticateUser, requireRole(['stylist'])]
  target_date = request.query.date
  
  schedule = db.query(`
    SELECT 
      a.start_time, 
      a.end_time,
      a.status,
      c.full_name as customer_name,
      s.name as service_name,
      s.price
    FROM appointments a
    JOIN users c ON a.customer_id = c.id
    JOIN services s ON a.service_id = s.id
    WHERE a.stylist_id = ? AND a.appointment_date = ?
    ORDER BY a.start_time ASC
  `, [req.user.id, target_date])
  
  // Calculate total expected revenue for the day in Node.js
  total_revenue = schedule.reduce((sum, appt) => sum + appt.price, 0)
  
  return 200 { date: target_date, total_revenue, appointments: schedule }
```

---

## ✅ Before Submission

- [ ] System supports varying service durations (e.g., 30 mins vs 120 mins).
- [ ] Backend mathematically calculates the `end_time` based on the database service duration.
- [ ] Database queries successfully implement the `(NewStart < OldEnd) AND (NewEnd > OldStart)` overlap formula.
- [ ] A junction table restricts customers from booking services with stylists who aren't trained for them.
- [ ] Code is on GitHub.

**Success:** You have built an advanced calendar overlap system!
