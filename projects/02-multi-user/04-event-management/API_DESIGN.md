# Event Management System: Learn By Building

**"Build a platform where organizers can create events, manage seating capacity, and attendees can register and receive tickets."**

---


## 🔌 API Design: Plan Before Coding

### Endpoint 1: Register for Event
**POST `/api/events/:id/register`**
- **Auth**: Requires Attendee JWT.
- **Response (Success)**: `201 Created` with Ticket ID.
- **Response (Full)**: `409 Conflict` "Event is sold out".

### Endpoint 2: Check-In Attendee
**POST `/api/tickets/:ticket_id/checkin`**
- **Auth**: Requires Organizer JWT (must be the organizer who owns the event).
- **Response**: `200 OK` "Successfully checked in".

---
