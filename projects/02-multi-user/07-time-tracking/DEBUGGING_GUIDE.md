## 🛠️ Debugging & Verification

**Test 1: Concurrent Timers**
- Click Start.
- Open a new tab and click Start again. The API should reject the second request: "You already have a running timer."

**Test 2: Rounding Errors**
- Work for 1 hr 15 mins. Rate is $100/hr. Ensure the math accurately charges $125.00, not $100 or $150.
