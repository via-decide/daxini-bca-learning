# 🏨 Hotel Booking System: Learn By Building

**"Build a reservation backend where Users can search for available rooms, Staff can manage bookings, and Administrators can manage inventory, featuring real-time availability checks to prevent double-booking."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Date Range Logic** - The universal SQL formula for detecting overlapping date intervals (`StartA < EndB AND EndA > StartB`).  
✅ **Database Transactions** - How to wrap multiple SQL queries into an atomic `BEGIN...COMMIT` block to prevent Race Conditions.  
✅ **Financial Data Handling** - Why `FLOAT` ruins currency calculations and how to use `DECIMAL` or integer cents instead.  
✅ **Role-Based Workflows** - Managing state transitions (e.g., A Guest creates a `pending` booking, a Receptionist changes it to `checked_in`).

---

## 📋 Project Overview

### The Problem

Booking systems (Hotels, Flights, Movie Theaters) face one major engineering challenge: **Inventory Contention**. 
Hundreds of users are looking at the exact same limited inventory at the exact same time. If your database logic is loose, two people will book the same seat. 

Furthermore, searching for availability is a complex inverse query. You aren't searching for rooms; you are filtering out rooms that have overlapping reservations.

**Your job:** Build an inventory management and booking engine that is mathematically immune to double-booking.

### Who Uses It

```
Guest:
├─ Searches for dates -> Gets list of available rooms
└─ POSTs a booking -> State is 'pending' or 'confirmed'

Receptionist:
├─ Sees today's arrivals
└─ PUTs booking status to 'checked_in'

Admin:
└─ POSTs new Rooms to the database
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. The Availability Engine (The hardest part)

```pseudocode
GET /api/rooms/available:
  req_in = request.query.check_in
  req_out = request.query.check_out
  
  // Validate dates
  if (req_in >= req_out) return 400 "Check-out must be after check-in"
  
  // THE MAGIC QUERY:
  // Give me all rooms EXCEPT the ones that are booked during this time
  sql = `
    SELECT * FROM rooms 
    WHERE is_active = 1 
    AND id NOT IN (
      SELECT room_id FROM bookings 
      WHERE check_in_date < ?   -- Note the crossover!
      AND check_out_date > ? 
      AND status NOT IN ('cancelled', 'checked_out')
    )
  `
  
  available_rooms = db.query(sql, [req_out, req_in])
  
  // Calculate estimated total price for the frontend
  nights = calculateDaysBetween(req_in, req_out)
  for room in available_rooms:
    room.total_price_estimate = room.price_per_night * nights
    
  return 200 available_rooms
```

### 2. The Booking Engine (Transactions)

```pseudocode
POST /api/bookings:
  middlewares: [authenticateUser, requireRole(['guest'])]
  
  req_in = request.body.check_in_date
  req_out = request.body.check_out_date
  room_id = request.body.room_id
  
  // Start an atomic database transaction
  db.execute("BEGIN TRANSACTION")
  
  try:
    // 1. Double check availability and lock the rows (SELECT ... FOR UPDATE if using Postgres/MySQL)
    overlaps = db.query(`
      SELECT id FROM bookings 
      WHERE room_id = ? 
      AND check_in_date < ? 
      AND check_out_date > ?
      AND status NOT IN ('cancelled')
    `, [room_id, req_out, req_in])
    
    if overlaps.length > 0:
      db.execute("ROLLBACK")
      return 409 "Room is no longer available"
      
    // 2. Calculate price
    room = db.query("SELECT price_per_night FROM rooms WHERE id = ?", room_id)
    nights = calculateDaysBetween(req_in, req_out)
    total = room.price_per_night * nights
    
    // 3. Insert Booking
    booking_id = generateUUID()
    db.query(`
      INSERT INTO bookings (id, user_id, room_id, check_in_date, check_out_date, total_price)
      VALUES (?, ?, ?, ?, ?, ?)
    `, [booking_id, req.user.id, room_id, req_in, req_out, total])
    
    // 4. Commit the transaction
    db.execute("COMMIT")
    
    return 201 "Booking successful"
    
  catch (error):
    db.execute("ROLLBACK")
    return 500 "Internal Server Error"
```

### 3. State Management (Staff)

```pseudocode
PUT /api/bookings/:id:
  middlewares: [authenticateUser, requireRole(['receptionist', 'admin'])]
  
  new_status = request.body.status
  
  // Update the booking status
  db.query("UPDATE bookings SET status = ? WHERE id = ?", [new_status, request.params.id])
  
  return 200 "Status updated"
```

---

## ✅ Before Submission

- [ ] System supports Guests, Receptionists, and Admins via JWT Roles.
- [ ] Availability Search correctly identifies overlapping date ranges.
- [ ] Booking endpoint uses Database Transactions (or strict constraints) to prevent double-booking.
- [ ] Currency is handled safely (using `DECIMAL` types, not Floats).
- [ ] Receptionists can update the state of a booking (`pending` -> `checked_in`).
- [ ] Code is on GitHub.

**Success:** You have built an enterprise-grade reservation and inventory system!
