# 📚 Tutoring Platform API: API Design

**"Build a multi-user API where Tutors define their availability slots, and Students book sessions using those slots without causing double-bookings."**

---

## 🔗 API Endpoints

*(Routes require Authentication via JWT unless marked Public)*

**Public / Student Operations:**
```
GET    /api/tutors             → (Public) Search for tutors by subject
GET    /api/tutors/:id/slots   → (Public) View a tutor's 'available' slots
POST   /api/slots/:id/book     → (Student) Book a specific slot
GET    /api/bookings/me        → (Student) View my upcoming sessions
```

**Tutor Operations (Requires 'tutor' role):**
```
POST   /api/slots              → Create new availability blocks (e.g., next Monday 10am-11am)
GET    /api/bookings/my-schedule → View all confirmed bookings with students
DELETE /api/slots/:id          → Remove an unbooked slot
```

---

## 📦 Request/Response Examples

### 1. Create Availability Slot (Tutor)

The frontend MUST send this in UTC ISO-8601 format.

**Request:**
```json
POST /api/slots
{
  "start_time": "2026-10-15T14:00:00Z",
  "end_time": "2026-10-15T15:00:00Z"
}
```

**Response (201):**
```json
{
  "message": "Slot created",
  "slot_id": "slot-123"
}
```

### 2. View Available Slots (Public/Student)

The API should only return slots where `is_booked = false` and the time is in the future.

**Request:**
```http
GET /api/tutors/tutor-99/slots HTTP/1.1
```

**Response (200):**
```json
{
  "tutor_name": "Tom Math",
  "available_slots": [
    {
      "slot_id": "slot-123",
      "start_time": "2026-10-15T14:00:00Z",
      "end_time": "2026-10-15T15:00:00Z"
    }
  ]
}
```

### 3. Book a Slot (Student)

This endpoint must use an atomic database update to prevent double-booking.

**Request:**
```json
POST /api/slots/slot-123/book
{}
```

**Response (201):**
```json
{
  "message": "Session booked successfully!",
  "booking_id": "book-555"
}
```

---

## ⚠️ Error Responses

```json
// 409 Conflict (Student clicks book, but someone else got it 1 millisecond earlier)
{ "error": "This slot is no longer available." }

// 400 Bad Request (Tutor tries to create a slot that overlaps with an existing slot they already created)
{ "error": "You already have a slot scheduled during this time." }

// 403 Forbidden (Tutor tries to delete a slot that has already been booked by a student)
{ "error": "Cannot delete a booked slot. You must cancel the booking first." }
```
