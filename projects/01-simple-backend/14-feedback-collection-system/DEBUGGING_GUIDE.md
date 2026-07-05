# 📝 Feedback Collection System: Learn By Building

**"Build an API that allows a business to create multiple feedback forms (e.g. 'Website Redesign', 'Customer Support'), generate unique links for them, and securely collect and aggregate user responses."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Validation Test

```
1. Create a form. Note the ID.
2. POST to `/api/forms/:id/responses` with `{ rating: 8 }`.
3. Expected: Server MUST reject it with a 400 Bad Request. (Rating must be 1-5).
4. POST with `{ rating: "five" }`.
5. Expected: Server MUST reject it with a 400 Bad Request. (Rating must be an integer).
```

### Scenario 2: The Double-Voting Prevention

```
1. Submit a valid response (e.g. rating: 5) to your form.
2. Immediately submit another valid response (e.g. rating: 1) from the same computer/Postman instance.
3. Expected: The server MUST reject the second request with a 429 Too Many Requests (or 403) stating you have already voted.
4. Verify: The database should only have ONE row for you, and the rating should be 5.
```

### Scenario 3: The Inactive Form Test

```
1. In your database, manually set `is_active = 0` (or `false`) for your form.
2. Try to submit a new response.
3. Expected: Server MUST reject it with a 403 Forbidden.
```

### Scenario 4: Aggregation Accuracy (The Math Test)

```
1. Create a new form.
2. (You will need to bypass your IP check for a moment, or use different IPs).
3. Insert three responses: 
   - Rating: 5
   - Rating: 4
   - Rating: 2
4. GET `/api/forms/:id/analytics`.
5. Expected:
   - `total_responses`: 3
   - `average_rating`: 3.66 (or 3.7 rounded)
   - `rating_breakdown`: { "5": 1, "4": 1, "3": 0, "2": 1, "1": 0 }
```

---
