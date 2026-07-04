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

## 🏗️ Architecture: Design Before Coding

### Step 1: The Availability Algorithm

**Question: How do we know if a room is available from Oct 10 to Oct 15?**
We must find a room that has **ZERO** existing bookings that overlap with the requested dates.
Two date ranges (A and B) overlap if: `StartA < EndB AND EndA > StartB`.

### Step 2: Database Architecture

```text
Rooms
├─ id (INT)
├─ room_number (VARCHAR)
├─ category (ENUM: 'Standard', 'Deluxe', 'Suite')
└─ base_price_per_night (DECIMAL)

Bookings
├─ id (UUID)
├─ user_id (FK -> Users)
├─ room_id (FK -> Rooms)
├─ check_in_date (DATE)
├─ check_out_date (DATE)
├─ total_price (DECIMAL)
└─ status (ENUM: 'pending', 'confirmed', 'cancelled')
```

---

## 🔌 API Design: Plan Before Coding

### Endpoint 1: Search Availability
**GET `/api/rooms/available?start=2024-10-10&end=2024-10-15&category=Deluxe`**
- **Response**: List of available rooms and the calculated total price for that stay.

### Endpoint 2: Create Booking
**POST `/api/bookings`**
- **Body**: `{ "room_id": 12, "start": "2024-10-10", "end": "2024-10-15" }`
- **Response**: `201 Created` with Booking ID.

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

## ⚠️ Common Mistakes

### ❌ Mistake 1: Ignoring Check-Out/Check-In Same Day Swaps
**What's wrong:** Using `<=` and `>=` in your overlap logic.
**Why it's bad:** If User A checks out on Oct 10 at 11 AM, and User B checks in on Oct 10 at 3 PM, they do *not* overlap in reality. But if your SQL says `check_in <= Oct 10`, the system will block User B from booking.
**How to fix:** Use strict `<` and `>` for date overlap boundary conditions.

### ❌ Mistake 2: Client-Side Pricing
**What's wrong:** The frontend calculates `price = $500` and sends it in the POST body to the API, which blindly saves it.
**Why it's bad:** A hacker can intercept the request, change `price: 1`, and book a 5-star suite for $1.
**How to fix:** The backend must ALWAYS calculate the price itself using the database's `base_price` and the requested dates.

---

## 🧪 Testing: How to Verify

### Test 1: Boundary Overlaps
- Create a confirmed booking from Oct 1 to Oct 5.
- Try to book Oct 4 to Oct 6. Should Fail (409).
- Try to book Sept 28 to Oct 2. Should Fail (409).
- Try to book Oct 5 to Oct 10. Should Succeed! (Because Oct 5 checkout allows an Oct 5 check-in).

### Test 2: Concurrent Booking (Race Condition)
- Use Postman or a script to send two identical Booking POST requests at the exact same millisecond.
- Ensure only ONE succeeds and the other receives a `409 Conflict`.

---

## 📚 Resources

- **Date Logic**: "Determine Whether Two Date Ranges Overlap" (StackOverflow).
- **Database Locks**: ACID Transactions and `SERIALIZABLE` isolation levels.

---

## ✅ Before Submission

- [ ] Does the system correctly handle same-day check-in/check-out?
- [ ] Are prices calculated exclusively on the backend?
- [ ] Do you use database transactions when creating a booking?
- [ ] Is there a role system separating customers from hotel admins?

---

**Build this and learn: Date interval math, transaction isolation, and inventory tracking.**
