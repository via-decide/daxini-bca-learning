# ⏱️ Timer & Countdown Service: Learn By Building

**"Build an API that creates shareable countdown timers (e.g., 'Product Launch', 'New Year'), stores them persistently, and calculates the remaining time precisely whenever requested."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. User creates a countdown for "New Year 2027" set to Jan 1, 2027 at 00:00:00 UTC.
2. The server gives them a short link: `your-api.com/timer/newyear27`.
3. User A opens the link in New York.
4. User B opens the link in Tokyo.
5. The API needs to tell both users exactly how many days, hours, minutes, and seconds are remaining.

**What data do you need for each?**

After thinking, here's the data model:

```
Timers
├─ id (String - short, custom, or auto-generated like 'newyear27')
├─ title (String - e.g. "New Year 2027")
├─ target_datetime (Timestamp with Timezone - Crucial)
└─ created_at
```

---

### Step 2: The Timezone Problem

**Question: If I create a countdown for 5:00 PM, whose 5:00 PM is it?**

Time is incredibly difficult in programming. 
- If a user in New York creates a timer for 5:00 PM EST...
- A user in Tokyo who checks it should see it counting down to 6:00 AM JST the next day.

**Bad Idea (Local Time):**
```javascript
// Saving strings
const target = "2027-01-01 17:00:00"; 
db.insert({ target });
```
*Why it's bad:* The database doesn't know the timezone. When Tokyo asks for the time remaining, the server will calculate based on UTC or the server's local time, completely messing up the countdown.

**Good Idea (UTC & ISO 8601):**
ALWAYS convert everything to UTC (Coordinated Universal Time) before saving it to the database.
```javascript
// Client sends ISO 8601 string: "2027-01-01T22:00:00Z" (The Z means UTC)
// Or "2027-01-01T17:00:00-05:00" (5 PM EST with offset)
const targetDate = new Date(req.body.target_datetime);

// Save standard Date object to DB
db.insert({ target_datetime: targetDate });
```
When calculating "time remaining", you just do `targetDate - Date.now()`. Because `Date.now()` is standard UTC milliseconds, the math is perfectly accurate regardless of where the server or user is located.

---

### Step 3: Server vs Client Calculation

**Question: Should the backend calculate `remaining = 5 days, 2 hours` and send that to the frontend?**

**Bad Idea (Backend computes the exact string):**
```json
// GET /api/timers/newyear27
{ "time_left": "5 days, 2 hours, 10 seconds" }
```
*Why it's bad:* By the time the HTTP request reaches the user's browser, 1 second has passed. The data is already stale. If the frontend wants to show a ticking clock, it has to fetch this API every single second, which will crash your server.

**Good Idea (Backend sends the target, Frontend computes the diff):**
```json
// GET /api/timers/newyear27
{ 
  "title": "New Year 2027",
  "target_datetime": "2027-01-01T00:00:00.000Z" 
}
```
*Why it's good:* The frontend fetches this *once*. Then, the frontend uses JavaScript (`setInterval`) to calculate the difference between the target and the user's local clock every second, creating a smooth ticking animation without hitting your API ever again.

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Create Timer Form (Date/Time Picker) │  │
│  │ View Timer Page (Ticking Clock UI)   │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP POST /api/timers
        HTTP GET /api/timers/:id
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. Validate ISO 8601 Date Strings    │  │
│  │ 2. Ensure Date is in the future      │  │
│  │ 3. Save to DB (Normalize to UTC)     │  │
│  │ 4. Handle Read Requests              │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (SQLite/PostgreSQL)        │
│  - Persistent storage for timers           │
└────────────────────────────────────────────┘
```
