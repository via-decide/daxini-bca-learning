# 📝 Complaint Management System: Learn By Building

**"Build a multi-user API for a city or large organization where Citizens submit complaints (like Potholes), and City Workers claim, update, and resolve those complaints via a strict state machine."**

---

## 🧪 Testing Scenarios

### Scenario 1: The State Machine Enforcer

```
1. Citizen A creates a complaint. (Status: 'open').
2. Citizen A attempts to `PUT /api/complaints/:id/resolve`.
3. Expected: Server MUST reject it (403 Forbidden). Citizens cannot resolve their own complaints.
4. Worker B claims the complaint. (Status: 'in_progress').
5. Worker C attempts to `PUT /api/complaints/:id/claim`.
6. Expected: Server MUST reject it (409 Conflict). It is no longer 'open'.
7. Worker B marks it resolved. (Status: 'resolved').
8. Citizen A calls `PUT /api/complaints/:id/close`. (Status: 'closed').
```

### Scenario 2: Data Survival (ON DELETE SET NULL)

```
1. Citizen A submits Complaint X and writes Comment Y.
2. In your database, DELETE the User row for Citizen A.
3. Check the `complaints` table for Complaint X.
4. Expected: The complaint must still exist! The `citizen_id` column should now be `NULL`.
5. Check the `comments` table for Comment Y.
6. Expected: The comment must still exist! The `user_id` column should be `NULL`.
```

### Scenario 3: Authorization Isolation

```
1. Citizen A creates Complaint 1.
2. Citizen B logs in and attempts to `GET /api/complaints/1` or comment on it.
3. Expected: Server MUST reject it (403 Forbidden). Citizens can only see their own complaints. (Note: Unless your design allows public viewing of all city complaints, in which case viewing is allowed, but modifying is forbidden).
```

### Scenario 4: Worker Validation

```
1. Worker A claims Complaint 1.
2. Worker B attempts to `PUT /api/complaints/1/resolve`.
3. Expected: Server MUST reject it. Only the assigned worker (`worker_id === req.user.id`) can resolve the complaint.
```

---
