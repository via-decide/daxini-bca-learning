# ⏱️ Timer & Countdown Service: Learn By Building

**"Build an API that creates shareable countdown timers (e.g., 'Product Launch', 'New Year'), stores them persistently, and calculates the remaining time precisely whenever requested."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **ISO 8601 & UTC** - The global standard for transmitting dates and times over HTTP, avoiding timezone disasters.  
✅ **Date Parsing Validation** - Ensuring clients send valid, future-dated timestamps before saving them to the database.  
✅ **Client vs Server Responsibilities** - Why servers provide *state* (the target date) and clients provide *presentation* (the ticking clock animation).  
✅ **Nanoid** - Generating short, URL-friendly IDs for sharing links.

---

## 📋 Project Overview

### The Problem

If I want to launch my new App on Friday at 5:00 PM in California, I want to tweet a link to a countdown timer. When my friend in Japan clicks the link, they should see a timer counting down exactly to the launch moment (which is Saturday morning for them).

Timezones are the source of 90% of bugs in scheduling applications.

**Your job:** Build a bulletproof backend that stores standard UTC time, and serves it correctly to anyone in the world.

### Who Uses It

```
Creator:
├─ POSTs target time to /api/timers
└─ Shares the link: yoursite.com/timer/xyz

Viewer:
├─ GETs /api/timers/xyz
└─ Sees a ticking clock on the frontend based on the returned target date.
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. Creating the Timer (Validation is Key)

```pseudocode
POST /api/timers:
  Step 1: Validate Date
    target_str = request.body.target_datetime
    
    // Attempt to parse it
    parsed_date = new Date(target_str)
    
    // Check if invalid (e.g. they sent "hello")
    if isNaN(parsed_date.getTime()):
      return 400 "Invalid Date Format"
      
  Step 2: Ensure it is in the future
    now = new Date()
    
    if parsed_date <= now:
      return 400 "Target must be in the future"
      
  Step 3: Generate ID
    id = generateNanoid(6) // e.g. "x8F9Zq"
    
  Step 4: Save to Database
    // We save the ISO string to guarantee we don't lose timezone data
    db.insert("timers", {
      id: id,
      title: request.body.title,
      target_datetime: parsed_date.toISOString() 
    })
    
  Step 5: Return Success
    return 201 { id: id, target_datetime: parsed_date.toISOString() }
```

### 2. Fetching the Timer

```pseudocode
GET /api/timers/:id:
  Step 1: Fetch from DB
    timer = db.query("SELECT * FROM timers WHERE id = ?", request.params.id)
    
    if !timer: return 404 "Not found"
    
  Step 2: (Optional) Calculate extra data for the client
    target = new Date(timer.target_datetime)
    now = new Date()
    
    // Difference in milliseconds
    diff_ms = target.getTime() - now.getTime()
    
    is_expired = diff_ms <= 0
    
    // Ensure we don't return negative milliseconds if it's expired
    remaining_ms = is_expired ? 0 : diff_ms
    
  Step 3: Return
    return 200 {
      id: timer.id,
      title: timer.title,
      target_datetime: timer.target_datetime,
      time_remaining_ms: remaining_ms,
      is_expired: is_expired
    }
```

---

## ✅ Before Submission

- [ ] API accepts a `title` and a `target_datetime` string.
- [ ] API rejects strings that cannot be parsed into valid dates.
- [ ] API rejects dates that are in the past.
- [ ] API returns a short, unique ID (e.g., `nanoid`).
- [ ] API allows fetching the timer by ID, returning the exact UTC target date.
- [ ] Code is on GitHub.

**Success:** You have conquered the notoriously difficult problem of Timezones in backend development!
