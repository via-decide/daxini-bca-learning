# Timer/Countdown Service API: Learn By Building

**"Build a real-time countdown service that synchronizes thousands of clients to a single, server-authoritative timer."**

---


## ⚠️ Common Mistakes

### ❌ Mistake 1: Not Handling Disconnects
**What's wrong:** Forgetting the `request.on("close")` logic.
**Why it's bad:** If a user closes their laptop, the connection drops. If you don't remove them from `active_clients`, your server will try to write data to a dead connection, throwing memory leak errors and eventually crashing.

### ❌ Mistake 2: Bad Timestamp Formats
**What's wrong:** Saving the target time as "Midnight EST" in a simple string.
**Why it's bad:** Timezones will break everything.
**How to fix:** Always store target times as ISO-8601 UTC strings (`2024-12-31T23:59:59Z`) or Unix Epoch Integers (milliseconds since 1970).

---
