# Weather App API: Learn By Building

**"Build a proxy API that fetches live weather data, standardizes it, and caches the results to avoid external rate limits."**

---


## 🧪 Testing: How to Verify

### Test 1: Cache Verification
- Make a request for a city (e.g., `/api/weather?city=tokyo`). Look at the response time (e.g., 400ms) and the `source` field.
- Make the exact same request immediately after.
- The response time should be nearly instant (e.g., 5ms), and the `source` field should say "cache".

### Test 2: Error Propagation
- Make a request for a fake city (`/api/weather?city=GothamCity`).
- Ensure your API safely returns a `404 Not Found` with a clean JSON error message, rather than crashing the server.

---


## 🛠️ Debugging: When Things Break

### Problem: Cache misses are happening even for the same city
**Root Cause:** You forgot to normalize the city name before generating the cache key. "Paris" and "paris" are generating two different cache keys.
**Solution:** Ensure `city.toLowerCase().trim()` is applied before doing any cache lookups.

---
