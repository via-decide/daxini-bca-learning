# Link Expiration System: Learn By Building

**"Build a secure file/resource sharing API that automatically deletes access after a specific time limit or view count is reached."**

---


## 🧪 Testing: How to Verify

### Test 1: Single View Limit
- Create a secret with `max_views: 1`.
- Access the link. You should see the message.
- Refresh the page. You should get a `410 Gone` error.

### Test 2: Time Expiration Limit
- Create a secret with `expires_in_hours: -1` (set to expire 1 hour ago for testing).
- Access the link. It should immediately return `410 Gone` even if `current_views` is 0.

---


## 🛠️ Debugging: When Things Break

### Problem: Links expire instantly upon creation.
**Root Cause:** Timezone mismatches. Your server is creating the `expires_at` timestamp in UTC, but evaluating it against the server's local time, making it instantly appear expired.
**Solution:** Always use standardized UTC timestamps for all database entries and time comparisons.

---
