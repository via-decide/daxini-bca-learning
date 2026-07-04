# Password Strength Checker: Learn By Building

**"Build a security utility that evaluates password complexity, entropy, and checks against known data breaches."**

---


## 🧪 Testing: How to Verify

### Test 1: Breach Detection
- Submit `password123`.
- The API should instantly return `is_breached: true` with a massive `breach_count`.

### Test 2: High Entropy Detection
- Submit a 30-character random string `xKw9$2mPq!8vLz@4fJc#7nRtbYh5`.
- The API should return `is_breached: false` and a `score` of 100/100, with a `time_to_crack` in millions of years.

---


## 🛠️ Debugging: When Things Break

### Problem: HIBP API returns 400 Bad Request
**Root Cause:** You are sending the full SHA-1 hash instead of just the 5-character prefix. The k-Anonymity API strictly requires exactly 5 characters.
**Solution:** Ensure you are correctly slicing the hash string before making the external HTTP request.

---
