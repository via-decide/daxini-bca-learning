# 🏨 Hotel Booking System: API Design

**"Build a reservation backend where Users can search for available rooms, Staff can manage bookings, and Administrators can manage inventory, featuring real-time availability checks to prevent double-booking."**

---

## 🔗 API Endpoints

**Authentication:**
```
POST /api/auth/register        → Register a new 'guest'
POST /api/auth/login           → Login and receive a JWT
```

**Inventory & Searching (Public / Guest):**
```
GET    /api/rooms/available    → Search for rooms. Query params: ?check_in=...&check_out=...
```

**Booking (Requires 'guest' role):**
```
POST   /api/bookings           → Create a booking
GET    /api/bookings/me        → View my own bookings
```

**Staff Management (Requires 'receptionist' or 'admin'):**
```
GET    /api/bookings           → View all bookings (for the front desk)
PUT    /api/bookings/:id       → Change status (e.g., 'confirmed' -> 'checked_in')
```

**Admin Management (Requires 'admin'):**
```
POST   /api/rooms              → Add a new room to the hotel
PUT    /api/rooms/:id          → Update room price or status
```

---

## 📦 Request/Response Examples

### 1. Search for Available Rooms

**Request:**
```http
GET /api/rooms/available?check_in=2026-12-20&check_out=2026-12-25 HTTP/1.1
```

**Response (200):**
```json
{
  "search": {
    "check_in": "2026-12-20",
    "check_out": "2026-12-25",
    "nights": 5
  },
  "available_rooms": [
    {
      "id": "room-101",
      "room_number": "101",
      "type": "standard",
      "price_per_night": 100.00,
      "total_price_estimate": 500.00
    },
    {
      "id": "room-205",
      "room_number": "205",
      "type": "deluxe",
      "price_per_night": 200.00,
      "total_price_estimate": 1000.00
    }
  ]
}
```

### 2. Create a Booking

**Request:**
*(Requires `Authorization: Bearer <token>` in headers)*
```json
POST /api/bookings
{
  "room_id": "room-205",
  "check_in_date": "2026-12-20",
  "check_out_date": "2026-12-25"
}
```

**Response (201):**
```json
{
  "message": "Booking successful",
  "booking": {
    "id": "book-999",
    "room_id": "room-205",
    "check_in_date": "2026-12-20",
    "check_out_date": "2026-12-25",
    "total_price": 1000.00,
    "status": "confirmed"
  }
}
```

### 3. Update Booking Status (Receptionist)

**Request:**
*(Requires `Authorization: Bearer <token>`)*
```json
PUT /api/bookings/book-999
{
  "status": "checked_in"
}
```

**Response (200):**
```json
{
  "message": "Booking updated to checked_in"
}
```

---

## ⚠️ Error Responses

```json
// 409 Conflict (User tried to book a room that was just taken)
{ "error": "Room is no longer available for these dates." }

// 400 Bad Request (Validation)
{ "error": "check_out_date must be after check_in_date." }

// 403 Forbidden (Guest tries to change status to checked_in)
{ "error": "Only staff can modify booking statuses." }
```
