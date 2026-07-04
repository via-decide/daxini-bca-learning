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


## ✅ Before Submission

- [ ] Does the `/stream` endpoint keep the connection open indefinitely?
- [ ] Is the data formatted strictly with `data: ... \n\n` (required for SSE)?
- [ ] Do clients get properly removed from memory when they close the tab?
- [ ] Is the time calculation completely independent of the client's local computer clock?

---

**Build this and learn: Real-time data pushing, connection pooling, and authoritative server logic.**
