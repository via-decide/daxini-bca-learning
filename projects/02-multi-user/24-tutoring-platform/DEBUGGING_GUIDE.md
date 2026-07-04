## 🛠️ Debugging & Verification

**Test 1: Rate Calculation**
- Tutor charges $60/hr for Math.
- Book a 90-minute session.
- Ensure the Database records `total_price` as $90.00.

**Test 2: Validation**
- Try to book Tutor A for "Physics".
- If Tutor A does not have an entry in `Tutor_Subjects` for Physics, the API must reject the booking.
