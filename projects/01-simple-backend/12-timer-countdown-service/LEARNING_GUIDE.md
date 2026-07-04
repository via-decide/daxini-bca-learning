# Timer/Countdown Service API: Learn By Building

**"Build a real-time countdown service that synchronizes thousands of clients to a single, server-authoritative timer."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Server-Sent Events (SSE)** - Pushing live updates from the server to the client without the client constantly refreshing.
✅ **Server-Authoritative Time** - Why you can never trust the user's local computer clock.
✅ **Connection Management** - Handling dropped HTTP connections and managing active client lists.
✅ **Timestamp Math** - Calculating precise differences in time (deltas) using UTC Unix timestamps.

---

## 📋 Project Overview

### The Problem
If you are launching a flash sale for concert tickets, you want a timer on the website counting down to zero. If you do this entirely in JavaScript on the frontend, users can just change their computer's clock to bypass the wait. Also, if 10,000 people are waiting, having them all `setInterval()` and refresh the API every second will destroy your server via a DDoS attack. You need a server that broadcasts a single, trusted countdown to everyone efficiently.

### Who Uses It
```
Flash Sale Website (Frontend):
├─ Connects to Server Event Stream
└─ Renders: "Sale starts in 04:32:11"

Backend API (You):
├─ Holds the "Target Date" (e.g., Midnight UTC)
├─ Broadcasts the remaining time every 1 second to all listeners
└─ Ensures nobody can cheat the clock
```

### The Big Picture

```text
┌──────────────┐
│  Client 1    │ <─┐
└──────────────┘   │  (Server-Sent Events)    ┌──────────────┐
                   ├───────────────────────── │ Your Backend │
┌──────────────┐   │  "43 seconds left"       │ (Broadcaster)│
│  Client 2    │ <─┘                          └──────────────┘
└──────────────┘
```

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

## 🗄️ Database: Design, Don't Code

### Schema Design

```text
Table: Timers
- id: VARCHAR (Primary Key)
- name: VARCHAR
- target_time: TIMESTAMP (UTC strictly)
- is_active: BOOLEAN
```

### Design Questions

1. **Do we save the remaining seconds in the database every second?**
   Absolutely NOT. You never write fast-moving computational data to a database. You only store the `target_time` once. The "remaining time" is dynamically calculated in RAM every second.

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

## 🧠 Implementation: Pseudocode First

```text
GLOBAL active_clients = []

FUNCTION stream_timer(request, response):
    timer_name = request.params.name
    timer = DB.find(timer_name)
    
    // 1. Set SSE Headers
    response.setHeader("Content-Type", "text/event-stream")
    response.setHeader("Cache-Control", "no-cache")
    response.setHeader("Connection", "keep-alive")
    
    // 2. Add client to list
    active_clients.push(response)
    
    // 3. Handle Disconnection
    request.on("close", () => {
        active_clients.remove(response)
    })

// Background Loop (Runs once per second on the server)
setInterval(FUNCTION () {
    target_time = DB.get("Concert").target_time
    now = current_time_utc()
    
    seconds_left = max(0, (target_time - now) / 1000)
    message = "data: {\"seconds\": " + seconds_left + "}\n\n"
    
    FOR client IN active_clients:
        client.write(message)
        
}, 1000)
```

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

## 🧪 Testing: How to Verify

### Test 1: Event Stream Verification
- Open terminal and run: `curl -N http://localhost:3000/api/timers/Concert/stream`
- You should see lines of data appearing automatically every second without the command finishing.

### Test 2: Connection Cleanup
- Add a `console.log(active_clients.length)` inside your background loop.
- Open 5 browser tabs to the stream URL. Ensure the count goes up to 5.
- Close 3 tabs. Ensure the count drops exactly to 2.

---

## 📚 Resources

- **Server-Sent Events**: MDN Web Docs: Server-sent events.
- **Time Math**: Date and Time formatting in your chosen language.

---

## ✅ Before Submission

- [ ] Does the `/stream` endpoint keep the connection open indefinitely?
- [ ] Is the data formatted strictly with `data: ... \n\n` (required for SSE)?
- [ ] Do clients get properly removed from memory when they close the tab?
- [ ] Is the time calculation completely independent of the client's local computer clock?

---

**Build this and learn: Real-time data pushing, connection pooling, and authoritative server logic.**
