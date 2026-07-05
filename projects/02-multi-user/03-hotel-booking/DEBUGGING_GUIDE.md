# 🏨 Hotel Booking System: Learn By Building

**"Build a reservation backend where Users can search for available rooms, Staff can manage bookings, and Administrators can manage inventory, featuring real-time availability checks to prevent double-booking."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Availability Search

```
1. Create a Room (e.g. Room 101).
2. Book Room 101 for Dec 10 to Dec 15.
3. Search for available rooms from Dec 1 to Dec 5.
4. Expected: Room 101 should appear in the results.
5. Search for available rooms from Dec 12 to Dec 14.
6. Expected: Room 101 MUST NOT appear.
7. Search for available rooms from Dec 8 to Dec 11 (Overlapping start).
8. Expected: Room 101 MUST NOT appear.
9. Search for available rooms from Dec 14 to Dec 20 (Overlapping end).
10. Expected: Room 101 MUST NOT appear.
```
*(This is the hardest part of the project. Your SQL query must perfectly handle all 4 types of date overlap).*

### Scenario 2: The Double-Booking Race Condition

```
1. Have two completely separate Postman windows ready (or use an automated script).
2. Prepare identical POST requests to book Room 101 for Dec 20 to Dec 25.
3. Send both requests at the exact same millisecond.
4. Expected: ONE request should get a 201 Created. The OTHER request MUST get a 409 Conflict.
5. Verify: Check your database. There should only be ONE booking for Room 101 on those dates.
```

### Scenario 3: RBAC (Role-Based Access Control) Enforcement

```
1. Login as a Guest. Copy the JWT.
2. Attempt to PUT `/api/bookings/:id` to change your booking status to `checked_in`.
3. Expected: Server MUST reject with 403 Forbidden. Only Receptionists/Admins can check someone in.
```

### Scenario 4: The Time-Travel Test

```
1. POST `/api/bookings` with a `check_in_date` of yesterday.
2. Expected: Server MUST reject it. You cannot book a room in the past.
3. POST `/api/bookings` with a `check_out_date` that is BEFORE the `check_in_date`.
4. Expected: Server MUST reject it. (Your database `CHECK` constraint should also catch this).
```

---
