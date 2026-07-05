# 🏥 Hospital Management System: Learn By Building

**"Build a multi-user platform where Doctors can view their appointments, Receptionists can book patients, and Administrators can manage hospital resources, all backed by a relational database."**

---

## 🧪 Testing Scenarios

### Scenario 1: Authentication & JWT Testing

```
1. Create an admin user directly in the database (or via an open seed script).
2. POST to `/api/auth/login` with correct credentials.
3. Expected: Receive a 200 OK and a JWT token.
4. Copy the JWT token.
5. Create a GET request to `/api/users` in Postman.
6. Try without the token. Expected: 401 Unauthorized.
7. Add Header: `Authorization: Bearer <paste_token>`. Expected: 200 OK and a list of users.
```

### Scenario 2: Role-Based Access Control (RBAC)

```
1. Login as a Doctor. Copy the JWT.
2. Attempt to POST to `/api/users` to create a new receptionist using the Doctor's JWT.
3. Expected: Server MUST reject it with a 403 Forbidden. Only Admins can create users.
4. Attempt to GET `/api/appointments`.
5. Expected: Server returns 200 OK.
```

### Scenario 3: Data Isolation (The IDOR Test)

```
1. You have Doctor A and Doctor B.
2. Login as Doctor A.
3. Send GET `/api/appointments`.
4. Expected: You should ONLY see appointments where `doctor_id` matches Doctor A's ID.
5. Verify: If you see Doctor B's appointments, your backend has an Insecure Direct Object Reference (IDOR) vulnerability.
```

### Scenario 4: The JOIN Validation Test

```
1. Book an appointment for a patient named "Sarah Connor".
2. Login as the assigned Doctor.
3. GET `/api/appointments`.
4. Expected: The JSON response MUST contain "Sarah Connor".
5. Verify: If the response only contains `"patient_id": "uuid-1234"` and you have to make a *second* API call to get her name, your SQL `JOIN` is failing or missing.
```

---
