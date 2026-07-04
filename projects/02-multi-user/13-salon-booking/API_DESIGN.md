## 🔌 API Design: Plan Before Coding

### 1. Book Appointment
**POST `/api/appointments`**
- **Body**: `{ "stylist_id": "1", "service_id": "5", "start_time": "2024-10-10T10:00:00Z" }`
- **Logic**: 
  1. Fetch service `duration_minutes`. Calculate `req_end_time = start_time + duration`.
  2. Check for overlap: `SELECT count(*) FROM appointments WHERE stylist_id=1 AND (start_time < req_end_time AND end_time > req_start_time)`.
  3. If count > 0, reject. Otherwise, insert.

### 2. Get Stylist Schedule
**GET `/api/stylists/:id/schedule?date=2024-10-10`**
- **Logic**: Fetch all appointments for the stylist on that day to render blocks on a calendar frontend.
