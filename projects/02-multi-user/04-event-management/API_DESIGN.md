# 🎟️ Event Management System: API Design

**"Build a platform where organizers can create events, manage ticket sales, and attendees can browse and register for events."**

---

## 🔗 API Endpoints

### Authentication

```
POST   /api/auth/register     → Create account (role: attendee or organizer)
POST   /api/auth/login        → Login, get JWT token
```

### Public Browsing (No Auth Required)

```
GET    /api/events                  → List published events (supports ?category=Music&search=Fest)
GET    /api/events/:id              → Get event details and available ticket tiers
```

### Organizer Management (Requires JWT, Role = Organizer)

```
POST   /api/organizer/events        → Create a new event
PATCH  /api/organizer/events/:id    → Update event details
POST   /api/organizer/events/:id/tiers → Add a ticket tier (e.g., VIP, General)
GET    /api/organizer/events/:id/attendees → List all registered users for an event
POST   /api/organizer/tickets/:id/checkin  → Scan/Check-in a ticket
```

### Attendee Actions (Requires JWT, Role = Attendee)

```
POST   /api/events/:id/register     → Buy/register for tickets (The most complex endpoint)
GET    /api/my-tickets              → List all tickets purchased by the logged-in user
GET    /api/my-tickets/:id          → Get specific ticket details (for QR code rendering)
```

---

## 📦 Request/Response Examples

### 1. Register/Buy Tickets (The Concurrency Endpoint)

**Request:**
```json
POST /api/events/uuid-event-1/register
Authorization: Bearer <jwt_token>
{
  "tickets": [
    { "tier_id": "uuid-tier-vip", "quantity": 2 },
    { "tier_id": "uuid-tier-general", "quantity": 1 }
  ]
}
```

**Response (201):**
```json
{
  "message": "Registration successful",
  "registration": {
    "id": "uuid-reg-1",
    "total_amount": 250.00,
    "payment_status": "completed",
    "tickets": [
      { "id": "uuid-ticket-1", "tier": "VIP", "qr_code": "VIP-123456" },
      { "id": "uuid-ticket-2", "tier": "VIP", "qr_code": "VIP-123457" },
      { "id": "uuid-ticket-3", "tier": "General", "qr_code": "GEN-987654" }
    ]
  }
}
```

### 2. Check-in a Ticket

**Request:**
```json
POST /api/organizer/tickets/VIP-123456/checkin
Authorization: Bearer <jwt_organizer_token>
```

**Response (200):**
```json
{
  "message": "Check-in successful",
  "ticket": {
    "id": "uuid-ticket-1",
    "status": "checked_in",
    "checked_in_at": "2026-10-01T18:30:00Z",
    "attendee_name": "Alice Smith",
    "tier": "VIP"
  }
}
```

---

## ⚠️ Error Responses

```json
// 409 Conflict (Concurrency / Sold out)
{ "error": "VIP tickets are sold out. Only 1 remaining." }

// 403 Forbidden (Attendee trying to create an event)
{ "error": "Only organizers can create events." }

// 400 Bad Request (Checking in an already checked-in ticket)
{ "error": "Ticket has already been used on 2026-10-01 at 18:30" }

// 404 Not Found (Invalid QR code)
{ "error": "Ticket not found or invalid" }
```
