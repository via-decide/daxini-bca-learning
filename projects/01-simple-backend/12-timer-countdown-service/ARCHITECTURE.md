# Timer/Countdown Service API: Learn By Building

**"Build a real-time countdown service that synchronizes thousands of clients to a single, server-authoritative timer."**

---


## 🏗️ Architecture: Design Before Coding

### Step 1: Push vs Pull (Polling)

**Question: Should the frontend ask the backend for the time every second (Polling)?**
- No. If you have 10,000 users, that's 10,000 requests per second. Your backend will struggle to handle the overhead of opening and closing 10,000 connections repeatedly.
- **Solution:** Use Server-Sent Events (SSE). The client opens ONE connection, and the server keeps it open, sending a tiny text message through the open pipe every second.

### Step 2: Architecture Diagram

```text
1. Admin POSTs /api/timers { "name": "Concert", "target_time": "2024-12-31T23:59:59Z" }
2. Client connects GET /api/timers/Concert/stream
3. Server adds Client to a list of active connections.
4. Server runs an internal loop every 1 second:
     a. Calculates remaining time.
     b. Writes "data: { remaining: 43 }\n\n" to all active connections.
5. If a Client closes the tab, Server removes them from the list.
```

---
