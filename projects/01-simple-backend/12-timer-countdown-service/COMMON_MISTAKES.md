# ⏱️ Timer & Countdown Service: Learn By Building

**"Build an API that creates shareable countdown timers (e.g., 'Product Launch', 'New Year'), stores them persistently, and calculates the remaining time precisely whenever requested."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Not enforcing ISO 8601 Strings

**Wrong:**
```javascript
// A user sends: "01/02/2027"
const date = new Date(req.body.target_datetime);
```
*Why it's bad:* In the US, `01/02` is January 2nd. In the UK, `01/02` is February 1st. Node.js might guess incorrectly depending on server settings.

**Right:**
Force the client to send ISO 8601 format (e.g., `2027-01-02T00:00:00Z`).
```javascript
const targetStr = req.body.target_datetime;
const parsedDate = new Date(targetStr);

// Simple validation: If it's not a valid Date, JS returns NaN
if (isNaN(parsedDate.getTime())) {
  return res.status(400).json({ error: "Invalid date format." });
}
```

### ❌ Mistake 2: Relying on the Server's Local Timezone

**Wrong:**
```javascript
// Getting the "current" time using a library without specifying timezone
const now = moment().format('YYYY-MM-DD HH:mm:ss');
```
*Why it's bad:* If you deploy your app to an AWS server in Ohio (EST), and later move it to a server in London (GMT), all your timers will instantly break by 5 hours.

**Right:**
Use UTC for absolutely everything on the backend.
```javascript
const now = new Date().toISOString(); // Always UTC
```

### ❌ Mistake 3: Doing heavy math formatting on the backend

**Wrong:**
```javascript
// Backend trying to format the string
const timeLeft = "5 Days, 4 Hours, 3 Mins";
res.json({ time_left: timeLeft });
```
*Why it's bad:* What if the frontend is an iOS app in Spain? It wants to display "5 Días, 4 Horas". The backend shouldn't care about translation or formatting.

**Right:**
Send raw data (Timestamps or Milliseconds). Let the frontend do the translation and formatting.

---
