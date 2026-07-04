# To-Do List API: Learn By Building

**"Build the quintessential CRUD API with a twist: focus heavily on database relationships, pagination, and data validation."**

---


## 🧪 Testing: How to Verify

### Test 1: The 404 Check
- Send `GET /api/tasks/99999` (an ID that doesn't exist).
- Ensure the API returns a proper `404 Not Found` status code, not a `500 Internal Server Error`.

### Test 2: Validation Failure
- Send `POST /api/tasks` with `{ "title": "" }`.
- Ensure it returns `400 Bad Request` with an error message saying "Title is required".

---


## 🛠️ Debugging: When Things Break

### Problem: Page 2 returns the exact same data as Page 1
**Root Cause:** Your math for the `OFFSET` calculation is wrong, or you aren't actually passing the offset value into your SQL query.
**Solution:** Print the generated SQL query to the console before executing it. Verify that it says `OFFSET 10` for page 2 (assuming a limit of 10).

---
