# 🔗 URL Shortener: Learn By Building

**"Build a system that takes long, ugly URLs and turns them into short, shareable links, tracking how many times they are clicked."**

---

## 🧪 Testing Scenarios

### Scenario 1: Creating a Link (Happy Path)

```
1. User POSTs to /api/shorten with a valid URL
2. Expected: API returns 201 Created and a short_code (e.g., 'Xy39pL')
3. Verify: Database `urls` table has a new row
```

### Scenario 2: Testing the Redirect

```
1. Open browser and visit http://localhost:3000/Xy39pL
2. Expected: Browser immediately redirects to the original URL
3. Verify: Network tab shows HTTP 302 or 301 status code
```

### Scenario 3: Missing or Invalid Short Code

```
1. Open browser and visit http://localhost:3000/DOESNOTEXIST
2. Expected: API returns a 404 HTML page or JSON error "Link not found"
3. Verify: It should not crash the server!
```

### Scenario 4: Verifying Background Analytics

```
1. Have your database client open. Look at `click_analytics` row count.
2. Click the short link in your browser.
3. IMMEDIATELY check the database row count again.
4. Expected: The row count increased by 1, AND `urls.clicks` increased by 1.
5. If the redirect feels slow (e.g., 500ms delay before loading the page), your analytics insert is blocking the redirect response.
```

### Scenario 5: Validating Input

```
1. User POSTs to /api/shorten with `{"original_url": "not-a-url"}`
2. Expected: API returns 400 Bad Request
3. Verify: DB does not contain the bad URL.
```

---
