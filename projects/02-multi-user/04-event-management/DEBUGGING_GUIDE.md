# Event Management System: Learn By Building

**"Build a platform where organizers can create events, manage seating capacity, and attendees can register and receive tickets."**

---


## 🧪 Testing: How to Verify

### Test 1: Capacity Limit
- Create an event with `capacity: 2`.
- Register Attendee 1 (Success).
- Register Attendee 2 (Success).
- Register Attendee 3 (Fails with 409).
- Cancel Attendee 1's ticket.
- Register Attendee 3 again (Success!).

### Test 2: Check-In Validation
- As the Organizer, hit the Check-In endpoint with a valid ticket ID. (Success).
- Hit the Check-In endpoint again with the same ticket ID. (Should return an error: "Already checked in").

---


