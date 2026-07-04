# Timer/Countdown Service API: Learn By Building

**"Build a real-time countdown service that synchronizes thousands of clients to a single, server-authoritative timer."**

---


## 🔌 API Design: Plan Before Coding

### Endpoint 1: Create Timer (Admin Only)
**POST `/api/timers`**
- **Body**: `{ "name": "Concert", "target_time": "2024-12-31T23:59:59Z" }`

### Endpoint 2: Subscribe to Timer
**GET `/api/timers/:name/stream`**
- **Headers Needed on Response**:
  - `Content-Type: text/event-stream`
  - `Cache-Control: no-cache`
  - `Connection: keep-alive`
- **Response**: An open, continuous stream of data.

---
