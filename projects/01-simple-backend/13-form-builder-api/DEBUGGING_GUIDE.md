# Form Builder API: Learn By Building

**"Build a dynamic API that allows users to define custom form fields (JSON schemas), and then strictly validates incoming submissions against those user-defined rules."**

---


## 🧪 Testing: How to Verify

### Test 1: The Rejection Test
- Create a form requiring a number > 10.
- Submit a string (`"15"`). Ensure it fails type checking.
- Submit a number (`9`). Ensure it fails logic checking.
- Submit an empty object (`{}`). Ensure it fails required checking.

### Test 2: The Extra Data Test
- Submit valid answers, but include a fake field: `{"name": "Bob", "secret_hack": "yes"}`.
- Check the database. Ensure `secret_hack` was NOT saved.

---


## 🛠️ Debugging: When Things Break

### Problem: Everything passes validation even when it shouldn't.
**Root Cause:** The loop logic. If you use a `forEach` loop in some languages, returning from inside the loop only exits the callback, it doesn't stop the validation engine.
**Solution:** Collect all errors into an array. Check `errors.length > 0` at the very end of the evaluation phase.

---
