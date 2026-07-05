# 💻 Code Snippet Storage API: Learn By Building

**"Build a pastebin-like API where developers can upload text (code snippets), optionally set them to self-destruct after viewing, and retrieve them with a unique ID."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Basic Workflow

```
1. POST to `/api/snippets` with `{"content": "hello world"}`.
2. Expected: Response gives you a short ID (e.g. `xy12z`).
3. GET `/api/snippets/xy12z`.
4. Expected: You get "hello world" back.
```

### Scenario 2: Burn After Reading (The Race Condition Test)

```
1. POST to `/api/snippets` with `{"content": "secret", "is_burn_after_reading": true}`.
2. Note the ID.
3. Rapid-fire two GET requests to that ID at the exact same time (using a script or quickly double-clicking in Postman).
4. Expected: The first request should get a 200 OK with the secret. The second request MUST get a 404 Not Found.
5. Verify: Check your database. The row MUST NOT exist anymore.
```

### Scenario 3: Size Limits

```
1. Try to upload 500,000 characters of text.
2. Expected: The API should return a 400 Bad Request or 413 Payload Too Large.
3. Verify: The Node.js server should NOT crash due to memory exhaustion. (If you are using `express.json()`, you can set the limit like `express.json({ limit: '100kb' })`).
```

### Scenario 4: Rate Limiting

```
1. Hit the POST `/api/snippets` endpoint 20 times within 10 seconds.
2. Expected: After the 10th request (or whatever limit you set), the server should return a 429 Too Many Requests status code.
```

---
