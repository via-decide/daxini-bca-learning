# Hotel Booking System: Learn By Building

**"Build a reservation engine that handles date-range availability, dynamic pricing, and concurrent booking conflicts."**

---


## 🧪 Testing: How to Verify

### Test 1: Boundary Overlaps
- Create a confirmed booking from Oct 1 to Oct 5.
- Try to book Oct 4 to Oct 6. Should Fail (409).
- Try to book Sept 28 to Oct 2. Should Fail (409).
- Try to book Oct 5 to Oct 10. Should Succeed! (Because Oct 5 checkout allows an Oct 5 check-in).

### Test 2: Concurrent Booking (Race Condition)
- Use Postman or a script to send two identical Booking POST requests at the exact same millisecond.
- Ensure only ONE succeeds and the other receives a `409 Conflict`.

---


