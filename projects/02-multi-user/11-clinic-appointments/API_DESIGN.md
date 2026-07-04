## 🔌 API Design: Plan Before Coding

### 1. Get Available Slots
**GET `/api/doctors/:id/availability?date=2024-10-10`**
- **Logic**: Generate all possible 30-minute slots for the day (9:00, 9:30, 10:00). Query the `appointments` table for that doctor on that date. Subtract booked slots from the generated list. Return the remainder to the client.

### 2. Book Appointment
**POST `/api/appointments`**
- **Body**: `{ "doctor_id": "123", "appointment_time": "2024-10-10T09:00:00Z" }`
- **Logic**: Simple `INSERT`. If the database throws a unique constraint violation, return `409 Conflict: Slot already taken`.
