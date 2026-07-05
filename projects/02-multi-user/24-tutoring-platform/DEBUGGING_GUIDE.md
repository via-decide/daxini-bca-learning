# 📚 Tutoring Platform API: Learn By Building

**"Build a multi-user API where Tutors define their availability slots, and Students book sessions using those slots without causing double-bookings."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Booking Race Condition

```
1. Tutor Tom creates a slot (Slot ID: 1).
2. Open two Postman tabs. 
3. Log in as Student A in Tab 1, and Student B in Tab 2.
4. Send `POST /api/slots/1/book` from both tabs simultaneously.
5. Expected: One request MUST succeed (201). The other MUST fail (409 Conflict). If both succeed, your platform just double-booked the tutor. 
6. Verification: Check the `bookings` table. There should only be ONE row with `status = 'confirmed'` for Slot 1.
```

### Scenario 2: The Timezone Trap

```
1. Set your computer's local timezone to EST (New York).
2. Login as Tutor. Create a slot for 10:00 AM local time.
3. Check the database `availability_slots` table directly.
4. Expected: The time stored in the database MUST be `14:00:00` or `15:00:00` (UTC time, depending on daylight savings). If it says `10:00:00`, you are incorrectly storing local time in the database.
```

### Scenario 3: Slot Deletion Protection

```
1. Tutor creates Slot 1.
2. Student books Slot 1.
3. Tutor calls `DELETE /api/slots/1`.
4. Expected: The backend MUST reject this (403 or 409). A tutor cannot delete a slot out from under a student who has already booked it. They must use a specific "Cancel Booking" workflow instead.
```

### Scenario 4: Overlapping Slots

```
1. Tutor creates a slot from 10:00 AM to 11:00 AM.
2. Tutor attempts to create a slot from 10:30 AM to 11:30 AM.
3. Expected: The API should detect the time overlap for this specific tutor and reject the request (400 Bad Request).
```

---
