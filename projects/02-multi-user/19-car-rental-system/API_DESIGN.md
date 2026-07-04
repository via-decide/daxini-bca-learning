## 🔌 API Design: Plan Before Coding

### 1. Search Available Cars
**GET `/api/cars/available?start=2024-10-01&end=2024-10-05`**
- **Logic**: Select all cars EXCEPT those that have a 'Confirmed' booking that overlaps with the requested dates.

### 2. Book Car
**POST `/api/bookings`**
- **Logic**: Validate the overlap condition one final time before `INSERT`.
  `SELECT count(*) FROM bookings WHERE car_id = X AND status = 'confirmed' AND (start_date <= requested_end AND end_date >= requested_start)`
  If count > 0, reject.
