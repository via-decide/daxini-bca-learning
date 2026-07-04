-- Schema Design
When user registers:
  1. Take password: "password123"
  2. Hash it: bcryptjs.hash("password123", 10)
  3. Result: "$2a$10$N9qo8uLOic..."
  4. Store the hash, NOT the plaintext

When user logs in:
  1. Get plaintext password from form
  2. Get hash from database
  3. Compare: bcryptjs.compare("password123", "$2a$10$...")
  4. Result: true/false (no plaintext ever compared)
Membership:
├─ start_date: 2026-01-15
├─ end_date: 2026-02-15
└─ status: active

When member tries to access:
1. Query their latest membership
2. Check if end_date > today
3. If yes: allow
4. If no: show "Membership expired, renew to continue"
When member arrives:
  POST /api/attendance
  Body: { memberId: 123 }
  
  Create record:
  {
    member_id: 123,
    date: 2026-01-20,
    check_in: 06:30 AM,
    check_out: null,
    duration: null
  }

When member leaves:
  PUT /api/attendance/123/checkout
  
  Update record:
  {
    check_out: 07:45 AM,
    duration: 75 (minutes)
  }