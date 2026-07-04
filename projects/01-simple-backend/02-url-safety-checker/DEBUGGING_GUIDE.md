# URL Safety Checker: Learn By Building

**"Build a security tool that scans URLs for phishing, malware, and malicious redirects."**

---


## 🧪 Testing: How to Verify

### Test 1: Known Bad URLs
- Find a test malware URL (Google provides safe testing URLs for this purpose).
- Submit it to your API.
- Verify it returns `safe: false`.

### Test 2: Cache Hit Verification
- Submit a safe URL (`https://github.com`).
- Turn off your internet connection.
- Submit the same URL again.
- It should succeed immediately because it pulled from the local database cache.

---


## 🛠️ Debugging: When Things Break

### Problem: API returns "Rate Limit Exceeded" (429)
**Root Causes:**
1. You aren't caching results, so you're hitting the external API for every request.
2. A single user is spamming your endpoint.
**Solution:** Check your database cache logic. Implement IP-based rate limiting on your own `/api/scan` endpoint.

---
