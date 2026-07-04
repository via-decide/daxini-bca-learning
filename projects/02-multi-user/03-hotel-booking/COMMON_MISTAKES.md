# Hotel Booking System: Learn By Building

**"Build a reservation engine that handles date-range availability, dynamic pricing, and concurrent booking conflicts."**

---


## ⚠️ Common Mistakes

### ❌ Mistake 1: Ignoring Check-Out/Check-In Same Day Swaps
**What's wrong:** Using `<=` and `>=` in your overlap logic.
**Why it's bad:** If User A checks out on Oct 10 at 11 AM, and User B checks in on Oct 10 at 3 PM, they do *not* overlap in reality. But if your SQL says `check_in <= Oct 10`, the system will block User B from booking.
**How to fix:** Use strict `<` and `>` for date overlap boundary conditions.

### ❌ Mistake 2: Client-Side Pricing
**What's wrong:** The frontend calculates `price = $500` and sends it in the POST body to the API, which blindly saves it.
**Why it's bad:** A hacker can intercept the request, change `price: 1`, and book a 5-star suite for $1.
**How to fix:** The backend must ALWAYS calculate the price itself using the database's `base_price` and the requested dates.

---
