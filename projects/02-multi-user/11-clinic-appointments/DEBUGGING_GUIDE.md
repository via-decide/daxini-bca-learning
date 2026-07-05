# 🩺 Clinic Appointments API: Learn By Building

**"Build a scheduling API where Doctors define their weekly availability, and Patients book specific 15-minute time slots, requiring strict time-boundary logic and overlap prevention."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Availability Generator

```
1. Create a Doctor with a schedule on Monday (Day 1) from 09:00:00 to 10:00:00.
2. Find the date of the next Monday (e.g., '2026-10-12').
3. GET `/api/doctors/:id/slots?date=2026-10-12`.
4. Expected: The array MUST contain exactly 4 slots: ["09:00:00", "09:15:00", "09:30:00", "09:45:00"]. (10:00:00 is the end time, so you can't start a 15-min appointment then).
```

### Scenario 2: The Double Booking Race Condition

```
1. Create a Doctor. Find an available slot (e.g., 09:00).
2. Fire two POST `/api/appointments` requests at the exact same millisecond for that doctor/date/time.
3. Expected: One succeeds. The other MUST fail with a 409 Conflict.
4. Verify: Check the database to ensure only one appointment was created for that slot.
```

### Scenario 3: Booking Outside Schedule

```
1. Doctor is scheduled 09:00 to 12:00.
2. Patient attempts to POST `/api/appointments` for 08:45.
3. Expected: Server MUST reject it.
4. Patient attempts to POST `/api/appointments` for 13:00.
5. Expected: Server MUST reject it.
```

### Scenario 4: The 15-Minute Boundary Check

```
1. Patient attempts to POST `/api/appointments` for 09:07:00.
2. Expected: Server MUST reject it. Appointments must snap to 15-minute grid lines (:00, :15, :30, :45).
```

---
