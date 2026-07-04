# Hotel Booking System: Learn By Building

**"Build a reservation engine that handles date-range availability, dynamic pricing, and concurrent booking conflicts."**

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
