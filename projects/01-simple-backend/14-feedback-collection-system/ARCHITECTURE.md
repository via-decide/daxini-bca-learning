# Feedback Collection System API: Learn By Building

**"Build an embeddable widget API that accepts feedback ratings, aggressively blocks spam using IP rate-limiting, and calculates real-time averages."**

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
