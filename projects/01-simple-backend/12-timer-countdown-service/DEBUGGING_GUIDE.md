# Timer/Countdown Service API: Learn By Building

**"Build a real-time countdown service that synchronizes thousands of clients to a single, server-authoritative timer."**

---


## 🧪 Testing: How to Verify

### Test 1: Event Stream Verification
- Open terminal and run: `curl -N http://localhost:3000/api/timers/Concert/stream`
- You should see lines of data appearing automatically every second without the command finishing.

### Test 2: Connection Cleanup
- Add a `console.log(active_clients.length)` inside your background loop.
- Open 5 browser tabs to the stream URL. Ensure the count goes up to 5.
- Close 3 tabs. Ensure the count drops exactly to 2.

---


