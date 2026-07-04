# Hotel Booking System: Learn By Building

**"Build a reservation engine that handles date-range availability, dynamic pricing, and concurrent booking conflicts."**

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
