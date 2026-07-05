# ✂️ Salon Booking API: API Design

**"Build a scheduling API for a salon where Customers book distinct Services (like Haircuts or Coloring) with specific Stylists, managing varying service durations and preventing overlap."**

---

## 🔗 API Endpoints

*(All routes require Authentication via JWT)*

**Public/Customer Operations:**
```
GET    /api/services           → List all available salon services
GET    /api/services/:id/stylists → Get stylists who provide this service
POST   /api/appointments       → Book an appointment
GET    /api/appointments/me    → View my upcoming appointments
```

**Stylist/Admin Operations (Requires 'stylist' or 'admin' role):**
```
POST   /api/services           → Create a new service (Admin)
POST   /api/stylist/services   → Add a service to my capabilities (Stylist)
GET    /api/stylist/schedule   → View my daily schedule
PUT    /api/appointments/:id   → Mark appointment as 'completed'
```

---

## 📦 Request/Response Examples

### 1. View Services

**Request:**
```http
GET /api/services HTTP/1.1
```

**Response (200):**
```json
{
  "services": [
    {
      "id": "srv-01",
      "name": "Men's Haircut",
      "duration_minutes": 30,
      "price": 30.00
    },
    {
      "id": "srv-02",
      "name": "Full Color",
      "duration_minutes": 120,
      "price": 150.00
    }
  ]
}
```

### 2. Book an Appointment

The backend must calculate the `end_time` based on the service's `duration_minutes`.

**Request:**
```json
POST /api/appointments
{
  "stylist_id": "stylist-sarah",
  "service_id": "srv-02",
  "appointment_date": "2026-11-05",
  "start_time": "10:00:00"
}
```

**Response (201):**
```json
{
  "message": "Appointment booked successfully",
  "appointment": {
    "id": "apt-999",
    "stylist": "Sarah",
    "service": "Full Color",
    "date": "2026-11-05",
    "start_time": "10:00:00",
    "end_time": "12:00:00", 
    "price": 150.00
  }
}
```

### 3. Stylist Daily Schedule

**Request:**
```http
GET /api/stylist/schedule?date=2026-11-05 HTTP/1.1
```

**Response (200):**
```json
{
  "date": "2026-11-05",
  "total_expected_revenue": 180.00,
  "appointments": [
    {
      "time": "10:00 - 12:00",
      "customer_name": "John Doe",
      "service": "Full Color",
      "status": "booked"
    },
    {
      "time": "13:30 - 14:00",
      "customer_name": "Alice Smith",
      "service": "Men's Haircut",
      "status": "booked"
    }
  ]
}
```

---

## ⚠️ Error Responses

```json
// 409 Conflict (Overlap detected!)
{ "error": "The stylist is already booked during this time period." }

// 400 Bad Request (Stylist isn't trained for this service)
{ "error": "This stylist does not offer the requested service." }

// 400 Bad Request (Booking outside business hours)
{ "error": "Appointments must be scheduled between 09:00 and 17:00." }
```
