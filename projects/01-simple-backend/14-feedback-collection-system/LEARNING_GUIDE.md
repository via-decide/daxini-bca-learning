# Feedback Collection System API: Learn By Building

**"Build an embeddable widget API that accepts feedback ratings, aggressively blocks spam using IP rate-limiting, and calculates real-time averages."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Rate Limiting** - Restricting how many times a single user (IP address) can hit your API within a timeframe.
✅ **Data Aggregation** - Calculating averages, counts, and percentiles directly using database queries (not in memory).
✅ **CORS (Cross-Origin Resource Sharing)** - Allowing third-party websites to securely send POST requests to your API.
✅ **Anonymization** - Hashing IP addresses so you can track users without violating privacy laws (GDPR).

---

## 📋 Project Overview

### The Problem
You build a little "Did you find this helpful? 👍 👎" widget and put it on a public blog. Because it has no login requirement, a single malicious user (or a bot) can click "Thumbs Down" 5,000 times a minute, ruining your data. You need a backend that silently discards spam, accepts valid votes, and provides the author with the total score.

### Who Uses It
```
Blog Widget (Frontend, No Login):
├─ User clicks: "5 Stars"
└─ Sends POST /api/feedback { page: "/article-1", rating: 5 }

Backend API (You):
├─ Checks if this IP has voted on this page recently
├─ Saves the vote
└─ Calculates the new average: "4.8 Stars"
```

### The Big Picture

```text
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Public Blog │ ──> │ Your Backend │ ──> │ Redis / DB   │
│  (No Login)  │     │ (Rate Limiter│     │ (IP Counters)│
└──────────────┘     └──────┬───────┘     └──────────────┘
                            │ (Allowed)
                            V
                     ┌──────────────┐
                     │ Database     │
                     │ (Feedback)   │
                     └──────────────┘
```

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data

**Question: How do we identify a user if they aren't logged in?**
- We use their IP Address.
- **Privacy Issue:** Storing raw IP addresses in a database permanently can violate privacy laws. 
- **Solution:** Store a one-way cryptographic hash of the IP address (e.g., `SHA256(IP + "secret_salt")`).

### Step 2: Rate Limiting Diagram (The Token Bucket)

```text
1. Client POSTs /api/feedback { rating: 5 }
2. API extracts Client IP (e.g., 192.168.1.1)
3. API checks Redis: "How many requests from hash(192.168.1.1) in the last 60 minutes?"
4. IF requests > 5:
     RETURN 429 Too Many Requests
5. ELSE:
     Increment Redis counter for hash(192.168.1.1)
     Save feedback to DB
     RETURN 201 Created
```

---

## 🗄️ Database: Design, Don't Code

### Schema Design (SQL)

```text
Table: Feedback
- id: UUID
- page_url: VARCHAR (e.g., "/blog/post-1")
- rating: INT (1 to 5)
- user_hash: VARCHAR (Hashed IP)
- created_at: TIMESTAMP
```

### Design Questions

1. **Why calculate the average in the Database and not in the Code?**
   If a page has 1,000,000 votes, running `SELECT *` and looping through an array of a million items in your code will crash the server (Out of Memory). Instead, run `SELECT AVG(rating) FROM Feedback WHERE page_url = '/blog/post-1'`. The database is highly optimized to do this math instantly without moving the raw data over the network.

---

## 🔌 API Design: Plan Before Coding

### Endpoint 1: Submit Feedback
**POST `/api/feedback`**
- **Headers**: `Origin: https://someblog.com` (Requires CORS configuration)
- **Body**: `{ "page_url": "/about", "rating": 5 }`
- **Response (Success)**: `201 Created`
- **Response (Spam)**: `429 Too Many Requests`

### Endpoint 2: Get Aggregated Stats
**GET `/api/feedback/stats?page_url=/about`**
- **Response**: `200 OK`
```json
{
  "page_url": "/about",
  "average_rating": 4.2,
  "total_votes": 142
}
```

---

## 🧠 Implementation: Pseudocode First

```text
FUNCTION submit_feedback(request, response):
    page = request.body.page_url
    rating = request.body.rating
    
    // 1. Validation
    IF rating < 1 OR rating > 5:
        RETURN 400 "Invalid rating"
        
    // 2. Anonymize IP
    raw_ip = request.headers["x-forwarded-for"] OR request.ip
    user_hash = SHA256(raw_ip + ENV.SECRET_SALT)
    
    // 3. Rate Limiting Check
    rate_key = "ratelimit:feedback:" + user_hash
    current_requests = Redis.get(rate_key) OR 0
    
    IF current_requests >= 5:
        RETURN 429 "Too Many Requests. Try again in an hour."
        
    // 4. Save and Increment Limit
    Redis.increment(rate_key)
    Redis.expire(rate_key, 3600) // Reset after 1 hour
    
    DB.insert("Feedback", {
        page_url: page,
        rating: rating,
        user_hash: user_hash,
        created_at: NOW()
    })
    
    RETURN 201 "Feedback recorded"
```

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Blocking the Load Balancer
**What's wrong:** Using `request.ip` directly when your app is hosted on AWS, Heroku, or behind Cloudflare.
**Why it's bad:** Cloudflare acts as a middleman. To your server, *every* request looks like it's coming from Cloudflare's IP. Your rate limiter will block all traffic after 5 users vote.
**How to fix:** Always check the `x-forwarded-for` HTTP header first, which load balancers use to pass along the real user's IP.

### ❌ Mistake 2: Missing CORS Headers
**What's wrong:** You build the API, test it in Postman (it works!), but when you put the widget on a blog, the browser blocks the request with a red CORS error.
**Why it's bad:** Browsers block frontend code from sending POST requests to a different domain unless the backend explicitly says it's allowed.
**How to fix:** Configure your API framework to return `Access-Control-Allow-Origin: *` (or the specific blog domain).

---

## 🧪 Testing: How to Verify

### Test 1: The Spam Test
- Hit the `/api/feedback` endpoint 6 times rapidly using Postman or a script.
- The first 5 should return `201`. The 6th should return `429 Too Many Requests`.

### Test 2: The Math Test
- Submit ratings of 5, 5, and 2.
- Hit the `/stats` endpoint. Ensure the average strictly returns `4.0` and total votes is `3`.

---

## 🛠️ Debugging: When Things Break

### Problem: `AVG()` returns crazy decimal numbers like `4.333333333333333`.
**Root Cause:** Floating point division in SQL.
**Solution:** Round the output in your SQL query directly: `SELECT ROUND(AVG(rating), 1)`.

---

## 📚 Resources

- **Rate Limiting**: "Redis Rate Limiting Patterns" (Token Bucket vs Fixed Window).
- **CORS**: MDN Web Docs: Cross-Origin Resource Sharing.
- **Proxies**: Express.js (or equivalent framework) documentation on "trust proxy".

---

## ✅ Before Submission

- [ ] Does your API correctly read the `x-forwarded-for` header for IPs?
- [ ] Are you hashing the IP address before saving it?
- [ ] Does the API block a user after 5 submissions in an hour?
- [ ] Is the average calculation done in the database (SQL), not in a loop in your code?

---

**Build this and learn: Rate limiting algorithms, CORS security, proxy networks, and SQL aggregations.**
