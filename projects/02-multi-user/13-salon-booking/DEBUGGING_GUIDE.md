## 🛠️ Debugging & Verification

**Test 1: Variable Overlap**
- Stylist A has a 120-min appointment from 10:00 to 12:00.
- Try to book a 30-min service at 10:30. Must fail.
- Try to book a 30-min service at 11:30. Must fail.
- Try to book a 30-min service at 12:00. Must succeed!

**Test 2: Price Validation**
- Ensure the API response for the confirmed booking fetches the correct price from the DB and doesn't rely on the frontend payload.
