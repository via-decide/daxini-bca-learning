# Feedback Collection System API: Learn By Building

**"Build an embeddable widget API that accepts feedback ratings, aggressively blocks spam using IP rate-limiting, and calculates real-time averages."**

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
