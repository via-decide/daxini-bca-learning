# Hotel Booking System: Learn By Building

**"Build a reservation engine that handles date-range availability, dynamic pricing, and concurrent booking conflicts."**

---


## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Date Range Overlaps** - Writing complex SQL to find available resources between two dates.
✅ **Inventory Management** - Ensuring you don't sell the same room twice (Race conditions).
✅ **State Transitions** - Managing the lifecycle of a booking (Pending -> Confirmed -> Checked In -> Checked Out).
✅ **Dynamic Pricing** - Calculating totals based on weekend vs weekday rates.

---


## 📋 Project Overview

### The Problem
Booking a hotel isn't like buying a t-shirt. A t-shirt is either in stock or out of stock. A hotel room is in stock *for specific dates*. If User A books Room 101 from Monday to Wednesday, and User B tries to book it from Tuesday to Thursday, the system must detect the overlap and block User B. Furthermore, you must prevent the scenario where two users click "Book" at the exact same millisecond.

### Who Uses It
```
Customer:
├─ Searches for rooms available between Date X and Date Y.
└─ Books a room and receives a confirmation.

Receptionist / Admin:
├─ Checks in customers arriving today.
├─ Overrides bookings or processes cancellations.
└─ Adjusts room prices for peak seasons.
```

---


## 🧠 Implementation: Pseudocode First

### 1. The Availability Query
```text
FUNCTION search_rooms(request, response):
    req_start = request.query.start
    req_end = request.query.end
    
    // Find rooms that do NOT have any overlapping bookings
    sql = """
        SELECT * FROM Rooms r
        WHERE r.id NOT IN (
            SELECT room_id FROM Bookings b
            WHERE b.status = 'confirmed' 
            AND b.check_in_date < ? 
            AND b.check_out_date > ?
        )
    """
    // Note: The parameters are req_end, req_start (due to overlap logic)
    available_rooms = DB.execute(sql, [req_end, req_start])
    
    RETURN 200 available_rooms
```

### 2. The Safe Booking Transaction
```text
FUNCTION create_booking(request, response):
    DB.start_transaction() // Lock to prevent race conditions
    
    // Re-verify availability inside the transaction!
    overlap_count = DB.query("SELECT count(*) FROM Bookings WHERE room_id = ? AND status = 'confirmed' AND check_in_date < ? AND check_out_date > ?", [room_id, req_end, req_start])
    
    IF overlap_count > 0:
        DB.rollback()
        RETURN 409 "Room just got booked by someone else!"
        
    // Calculate Price
    days = days_between(req_start, req_end)
    price = room.base_price * days
    
    DB.insert("Bookings", { room_id, req_start, req_end, status: 'confirmed' })
    DB.commit()
    
    RETURN 201 "Success"
```

---


## ✅ Before Submission

- [ ] Does the system correctly handle same-day check-in/check-out?
- [ ] Are prices calculated exclusively on the backend?
- [ ] Do you use database transactions when creating a booking?
- [ ] Is there a role system separating customers from hotel admins?

---

**Build this and learn: Date interval math, transaction isolation, and inventory tracking.**
