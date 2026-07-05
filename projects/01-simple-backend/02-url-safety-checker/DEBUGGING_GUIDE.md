# 🛡️ URL Safety Checker: Learn By Building

**"Build a security service that scans URLs against a database of known malicious domains to protect users from phishing and malware."**

---

## 🧪 Testing Scenarios

### Scenario 1: Admin Adds a Threat

```
1. Admin logs in
2. POSTs to /api/admin/domains with domain `bad-phish.com`
3. Expected: Returns 201 Created. Database shows the new row.
4. Admin tries to add `bad-phish.com` again.
5. Expected: Returns 409 Conflict (Already exists). Database does NOT duplicate it.
```

### Scenario 2: Standard Safe URL

```
1. User POSTs to /api/scan with URL `https://github.com/via-decide`
2. Expected: Returns `is_safe: true`.
3. Verify: `scan_logs` table has a new row indicating it was safe.
```

### Scenario 3: Malicious URL Parsing

```
1. Ensure `bad-phish.com` is in your blocked_domains table.
2. User POSTs to /api/scan with URL `http://www.bad-phish.com/login?victim=123`
3. Expected: Returns `is_safe: false`.
4. Verify: It correctly ignored the `http://`, the `www.`, and the `/login?victim=123` path to successfully match the base domain `bad-phish.com`.
```

### Scenario 4: Invalid URL

```
1. User POSTs to /api/scan with URL `not-a-url`
2. Expected: Returns 400 Bad Request.
3. Verify: The backend caught the error in the URL parsing logic and didn't crash.
```

### Scenario 5: Third-Party API Fallback (Optional)

```
1. Implement the Google Safe Browsing API fallback.
2. Add a known test malware URL to your test payload.
3. Expected: Your local DB says it is "safe" (because you didn't add it), but the Google API returns "unsafe", so the final response to the user is `is_safe: false`.
```

---
