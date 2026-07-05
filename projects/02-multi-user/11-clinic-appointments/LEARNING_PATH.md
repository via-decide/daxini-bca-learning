# 🩺 Clinic Appointments API: Learn By Building

**"Build a scheduling API where Doctors define their weekly availability, and Patients book specific 15-minute time slots, requiring strict time-boundary logic and overlap prevention."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Dynamic Data Generation** - Instead of storing empty time slots in the database, using Javascript algorithms to merge "Rules" (Doctor Schedules) and "Events" (Existing Appointments) to generate available options on the fly.  
✅ **Time and Date Math** - Working with `HH:MM:SS` strings, converting them to minutes/seconds in JS, and looping through intervals (e.g., adding 15 minutes).  
✅ **Composite Unique Constraints** - Guaranteeing data integrity at the database level by preventing duplicate combinations of `(doctor_id, date, time)`.

---

## 📋 Project Overview

### The Problem

Scheduling systems are notoriously difficult. You cannot store "available slots" in the database, because availability is a *calculation*, not a static fact. 

If Dr. Smith works 9-5 on Mondays, you have 32 potential 15-minute slots. To show a patient what is available on Monday, Oct 12th, you must mathematically subtract the already-booked appointments from those 32 slots.

Secondly, you must guarantee that two patients cannot book the same slot, even if they click the "Book" button at the exact same millisecond.

**Your job:** Build an algorithmic backend that calculates availability on the fly, and uses strict database rules to prevent double-booking.

### Who Uses It

```
Doctor:
├─ PUT /api/schedules/me (Sets Monday to Friday, 9am to 5pm)

Patient:
├─ GET /api/doctors/:id/slots?date=2026-10-12 (Calculates available slots)
└─ POST /api/appointments (Books a slot)
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. The Slot Generator Algorithm (The core challenge)

```pseudocode
GET /api/doctors/:id/slots:
  target_date = request.query.date // '2026-10-12'
  
  // 1. What day of the week is this? (0-6)
  day_num = getDayOfWeek(target_date) 
  
  // 2. Fetch the doctor's rule for this day
  schedule = db.query(`
    SELECT start_time, end_time FROM doctor_schedules 
    WHERE doctor_id = ? AND day_of_week = ?
  `, [request.params.id, day_num])
  
  if !schedule: return 200 { available_slots: [] } // Doc doesn't work today
  
  // 3. Fetch ALREADY BOOKED appointments for this specific date
  booked = db.query(`
    SELECT start_time FROM appointments 
    WHERE doctor_id = ? AND appointment_date = ? AND status = 'scheduled'
  `, [request.params.id, target_date])
  
  // Map into a simple array of strings: ['09:15:00', '11:00:00']
  booked_times = booked.map(b => b.start_time)
  
  // 4. Generate the slots!
  available_slots = []
  current = schedule.start_time // e.g. '09:00:00'
  
  while (current < schedule.end_time):
    if !booked_times.includes(current):
      available_slots.push(current)
      
    // Add 15 minutes to current string (You'll need a helper function for this!)
    current = add15Minutes(current) 
    
  return 200 { available_slots }
```

### 2. Validating and Booking

When the user submits a booking, we must validate it on the server before saving.

```pseudocode
POST /api/appointments:
  middlewares: [authenticateUser, requireRole(['patient'])]
  
  doc_id = request.body.doctor_id
  req_date = request.body.appointment_date
  req_time = request.body.start_time
  
  // 1. Validate 15-minute grid (e.g. 09:15, 09:30. NOT 09:12)
  if !isOn15MinuteInterval(req_time): return 400 "Invalid time interval"
  
  // 2. Is the doctor actually working at this time?
  day_num = getDayOfWeek(req_date)
  schedule = db.query("SELECT * FROM doctor_schedules WHERE ...")
  
  if !schedule OR req_time < schedule.start_time OR req_time >= schedule.end_time:
    return 400 "Doctor is not available at this time"
    
  // 3. Save it! Rely on the Database Unique Constraint to prevent overlaps.
  try:
    db.query(`
      INSERT INTO appointments (id, doctor_id, patient_id, appointment_date, start_time)
      VALUES (UUID(), ?, ?, ?, ?)
    `, [doc_id, req.user.id, req_date, req_time])
    
    return 201 "Booked!"
  catch (error):
    // If the UNIQUE constraint fails, someone else took the slot
    if error.isDuplicateKeyError:
      return 409 "Slot already booked"
```

---

## ✅ Before Submission

- [ ] System supports Doctors and Patients via JWT Roles.
- [ ] Doctors can set their weekly schedule (Day of week, Start Time, End Time).
- [ ] Available slots are calculated dynamically in Node.js, NOT pre-saved in the database.
- [ ] Backend strictly enforces 15-minute boundaries (no booking at 10:02).
- [ ] Database prevents double-booking using a Unique Index/Constraint.
- [ ] Code is on GitHub.

**Success:** You have built a robust, algorithmic scheduling engine!
