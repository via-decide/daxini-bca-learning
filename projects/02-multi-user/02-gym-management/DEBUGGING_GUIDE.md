# 💪 Gym Management System: Learn By Building

**"Build a complete system for managing gyms. Understand databases, roles, and complex workflows."**

---


## 🧪 Testing Scenarios

### Scenario 1: Admin Adds Member

```
1. Admin logs in
2. Goes to "Add Member"
3. Fills: name, email, phone, age, weight, height
4. Clicks "Add"
5. Expected: Member appears in list, can log in with email
6. Verify: Can't add duplicate email
```

### Scenario 2: Member Checks In

```
1. Member arrives, scans QR or enters ID
2. System marks check-in: 06:30 AM
3. Member works out
4. Member leaves, scans/enters again
5. System marks check-out: 07:45 AM
6. Duration calculated: 75 minutes
7. Analytics: Today's attendance shows 75 minutes
```

### Scenario 3: Membership Renewal

```
1. Member's membership expires: 2026-02-15
2. Admin renews for 3 months
3. New end_date: 2026-05-15
4. Member can continue accessing system
```

### Scenario 4: Unauthorized Access

```
1. Member tries to access admin dashboard
2. Expected: Denied with 403 error
3. Member tries to view other member's workouts
4. Expected: Denied with 403 error
5. Someone tries to modify JWT token
6. Expected: Token invalid, denied
```

---


