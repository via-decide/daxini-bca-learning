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


## ✅ Before Submission

- [ ] Does your API correctly read the `x-forwarded-for` header for IPs?
- [ ] Are you hashing the IP address before saving it?
- [ ] Does the API block a user after 5 submissions in an hour?
- [ ] Is the average calculation done in the database (SQL), not in a loop in your code?

---

**Build this and learn: Rate limiting algorithms, CORS security, proxy networks, and SQL aggregations.**
