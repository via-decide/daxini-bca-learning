# 🔗 Link Expiration System: Learn By Building

**"Build a secure link-sharing API that generates unique URLs that automatically expire after a certain number of clicks or a specific time limit."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Click Limit Test

```
1. POST to `/api/links` with `target_url: "https://google.com"` and `max_clicks: 2`.
2. Note the returned short URL (e.g. `/s/xY9z`).
3. Open your browser and go to `localhost:3000/s/xY9z`. You should end up on Google.
4. Go back to `localhost:3000/s/xY9z`. You should end up on Google again.
5. Go to `localhost:3000/s/xY9z` a third time.
6. Expected: The server MUST return a 410 Gone error saying "Link expired". You should NOT be redirected to Google.
```

### Scenario 2: The Time Expiration Test

```
1. POST to `/api/links` with `target_url: "https://google.com"` and `expires_at: [A time 30 seconds from now]`.
2. Note the short URL.
3. Test it immediately. It should work.
4. Wait 31 seconds.
5. Test it again.
6. Expected: The server MUST return a 410 Gone error.
```

### Scenario 3: The Infinite Loop Test (Phishing Prevention)

```
1. POST to `/api/links` with `target_url: "http://localhost:3000/s/xY9z"`. (You are trying to make the short URL redirect to itself, or to another short URL).
2. Expected: Your validation logic should reject this immediately with a 400 Bad Request to prevent infinite redirect loops on your server.
```

### Scenario 4: Concurrency / Race Condition Test

```
1. Create a link with `max_clicks: 1`.
2. Write a quick Node.js script (or use an API testing tool like Artillery) to send 50 requests to the `/s/:id` endpoint at the exact same millisecond.
3. Expected: ONLY ONE of those 50 requests should receive a 302 Redirect. The other 49 MUST receive a 410 Gone error. If more than one receives a 302, your click-increment logic is flawed and susceptible to race conditions.
```

---
