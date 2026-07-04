## 🛠️ Debugging & Verification

**Test 1: The Overlap Gauntlet**
Create a booking for Oct 10 to Oct 15. Attempt to create these bookings (all should be rejected):
- Oct 9 to Oct 11 (Partial overlap front)
- Oct 14 to Oct 16 (Partial overlap back)
- Oct 11 to Oct 13 (Inside overlap)
- Oct 5 to Oct 20 (Total enveloping overlap)

**Test 2: Availability Search**
- Search for Oct 11 to Oct 13. The car should NOT appear in the list.
