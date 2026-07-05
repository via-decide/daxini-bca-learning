# 🗣️ Customer Support Feedback System: Learn By Building

**"Build a multi-user API where Customers leave reviews for specific Support Agents, and Admins view aggregated performance scores to identify top employees."**

---

## 🧪 Testing Scenarios

### Scenario 1: The 1-to-1 Constraint

```
1. Customer Charlie submits a 5-star review for Ticket #1.
2. Charlie tries to submit a 1-star review for Ticket #1 (via `POST /api/feedback`).
3. Expected: Server MUST reject it. The database's `UNIQUE(ticket_id)` constraint should throw an error, which the backend catches and turns into a 409 Conflict HTTP response.
```

### Scenario 2: Data Validation (The Rating)

```
1. Customer sends a payload with `"rating": 6`.
2. Expected: Server MUST reject it (400 Bad Request). The DB's `CHECK (rating BETWEEN 1 AND 5)` should also block it.
3. Customer sends a payload with `"rating": -1`.
4. Expected: Server MUST reject it.
```

### Scenario 3: Authorization Isolation

```
1. Customer Charlie attempts to submit a review for Ticket #2 (which belongs to Customer Bob).
2. Expected: Server MUST reject it (403 Forbidden). A user can only review tickets where `customer_id === req.user.id`.
```

### Scenario 4: Aggregation Accuracy (The Leaderboard)

```
1. Create 3 reviews for Agent Alice: 5 stars, 4 stars, 4 stars.
2. Create 2 reviews for Agent Bob: 5 stars, 5 stars.
3. Call `GET /api/reports/leaderboard`.
4. Expected: 
   - Agent Bob should be Rank 1 (Average: 5.0).
   - Agent Alice should be Rank 2 (Average: 4.33).
5. Verify that the rounding is consistent (e.g., 2 decimal places).
```

---
