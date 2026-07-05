# ✉️ Email Scheduler API: Learn By Building

**"Build a background job system that accepts email content, schedules it for a specific time, and uses cron jobs or a worker queue to deliver it reliably."**

---

## 🧪 Testing Scenarios

### Scenario 1: Schedule and Send (Happy Path)

```
1. User logs in
2. Schedules an email for "1 minute from now"
3. Expected: API returns 201 Created. DB shows status='pending'
4. Wait 1 minute.
5. Expected: Background worker picks it up. DB shows status='processing'
6. Background worker successfully sends it via SMTP (e.g. Mailtrap)
7. Expected: DB shows status='sent' and sent_at timestamp is populated
```

### Scenario 2: Cancelling a Pending Email

```
1. User schedules an email for "Tomorrow at 9 AM"
2. User calls PATCH /api/emails/:id/cancel
3. Expected: API returns 200 OK. DB shows status='cancelled'
4. Fast forward to tomorrow at 9 AM.
5. Expected: Background worker ignores it because status != 'pending'
6. Email is NOT sent.
```

### Scenario 3: Attempting to Cancel a Processing/Sent Email

```
1. User schedules an email for "Now"
2. Background worker picks it up and marks it 'processing'
3. User simultaneously calls PATCH /api/emails/:id/cancel
4. Expected: API returns 403 "Cannot cancel an email that is already processing"
5. Email continues to send and becomes 'sent'.
```

### Scenario 4: SMTP Server Failure (Retry Logic)

```
1. User schedules an email for "Now"
2. Background worker picks it up, but the SMTP credentials are wrong (simulated error).
3. Worker catches the error.
4. Expected: DB shows status='failed', last_error='Auth failed', attempt_count=1
5. Worker runs again 5 minutes later.
6. Worker should NOT retry automatically unless you programmed exponential backoff (e.g., status='pending', attempt_count=1). 
7. If basic implementation: it just stays 'failed' forever.
```

### Scenario 5: Double Worker Concurrency (Advanced)

```
1. Schedule an email for "Now"
2. Start TWO background worker processes in your terminal at the exact same time.
3. Expected: Only ONE worker successfully claims the email (status='processing').
4. The other worker should find 0 pending emails.
5. Verify: The email is only sent ONCE to the destination inbox.
```

---
