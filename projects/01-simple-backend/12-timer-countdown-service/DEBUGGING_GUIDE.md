# ⏱️ Timer & Countdown Service: Learn By Building

**"Build an API that creates shareable countdown timers (e.g., 'Product Launch', 'New Year'), stores them persistently, and calculates the remaining time precisely whenever requested."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Time Machine Test (Past Dates)

```
1. POST to `/api/timers` with `{"target_datetime": "2010-01-01T00:00:00Z"}`.
2. Expected: The server MUST reject it with a 400 Bad Request. You cannot count down to a time that has already happened.
```

### Scenario 2: The Precision Parsing Test

```
1. POST to `/api/timers` with `{"target_datetime": "Next Friday"}`.
2. Expected: The server MUST reject it. Parsing natural language is incredibly difficult and prone to error. Enforce strict ISO 8601 formatting.
```

### Scenario 3: The Timezone Math Test

```
1. POST to `/api/timers` with a time that is exactly 24 hours from right now. (e.g., if it's currently June 1 at 12:00:00Z, submit June 2 at 12:00:00Z).
2. Note the returned ID.
3. GET `/api/timers/:id`.
4. Expected: The API should return the exact same target timestamp string you sent it.
5. If you implemented the optional `time_remaining_ms` feature, the value should be slightly under `86400000` (which is 24 hours in milliseconds).
```

### Scenario 4: The Expiration Test

```
1. In your database, manually change a timer's `target_datetime` to yesterday.
2. GET `/api/timers/:id`.
3. Expected: The API should return `is_expired: true` (or simply allow the frontend to realize the target is in the past).
```

---
