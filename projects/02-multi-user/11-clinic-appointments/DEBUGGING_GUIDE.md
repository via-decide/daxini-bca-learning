## 🛠️ Debugging & Verification

**Test 1: Double Booking Attack**
- Open two Postman tabs.
- Try to book the exact same doctor and time simultaneously.
- One request must succeed (201 Created), the other must fail (409 Conflict).

**Test 2: Availability Math**
- Book the 9:00 slot and the 10:00 slot.
- Query `/availability`. Ensure 9:00 and 10:00 are strictly missing from the array, but 9:30 is present.
