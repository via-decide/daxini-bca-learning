# Feedback Collection System API: Learn By Building

**"Build an embeddable widget API that accepts feedback ratings, aggressively blocks spam using IP rate-limiting, and calculates real-time averages."**

---


## 🧪 Testing: How to Verify

### Test 1: The Spam Test
- Hit the `/api/feedback` endpoint 6 times rapidly using Postman or a script.
- The first 5 should return `201`. The 6th should return `429 Too Many Requests`.

### Test 2: The Math Test
- Submit ratings of 5, 5, and 2.
- Hit the `/stats` endpoint. Ensure the average strictly returns `4.0` and total votes is `3`.

---


## 🛠️ Debugging: When Things Break

### Problem: `AVG()` returns crazy decimal numbers like `4.333333333333333`.
**Root Cause:** Floating point division in SQL.
**Solution:** Round the output in your SQL query directly: `SELECT ROUND(AVG(rating), 1)`.

---
