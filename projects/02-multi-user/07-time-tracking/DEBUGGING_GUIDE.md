# ⏱️ Time Tracking API: Learn By Building

**"Build a multi-user API where freelancers log hours against client projects, generating automated invoices and tracking real-time productivity."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Active Timer Constraint

```
1. POST `/api/time/start` to start Timer A.
2. Immediately POST `/api/time/start` to start Timer B.
3. Expected: The server MUST reject Timer B with a 409 Conflict. You cannot work on two things simultaneously.
4. Verify: Query your DB for active timers (`end_time IS NULL`) for your user. There should only be one.
```

### Scenario 2: Stopping a Timer

```
1. Start a timer.
2. Wait exactly 60 seconds (or manually change `start_time` in the DB to 1 hour ago).
3. POST `/api/time/:id/stop`.
4. Expected: The server should update `end_time` to NOW(), calculate the duration (approx 60 seconds, or 1 hour if you cheated), multiply by the `hourly_rate`, and return the `earned` amount in the JSON.
```

### Scenario 3: Aggregation (The Invoice Test)

```
1. Create Client X and Project Y ($100/hr).
2. Insert three manual rows into `time_entries` for Project Y:
   - Row 1: 1 hour duration. `is_billed = false`
   - Row 2: 2 hours duration. `is_billed = false`
   - Row 3: 5 hours duration. `is_billed = true`
3. GET `/api/reports/unbilled`.
4. Expected: The total unbilled hours for Client X should be exactly 3. The total owed should be exactly $300.
5. Verify: If the API includes Row 3, your `WHERE is_billed = 0` logic is missing!
```

### Scenario 4: The Rogue Client Modification

```
1. User A creates Client X.
2. Login as User B. Get JWT.
3. User B attempts to GET or PUT Client X.
4. Expected: Server MUST reject with 403 Forbidden. Users should never be able to see or touch other users' clients or invoices.
```

---
