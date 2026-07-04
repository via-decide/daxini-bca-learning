# 🔗 URL Shortener: Learn By Building

**"Build a system that makes long URLs short. Understand every part."**

---


## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Database Design** - How to structure data for uniqueness and performance  
✅ **API Design** - How to plan endpoints before coding  
✅ **Redirect Logic** - How HTTP redirects work  
✅ **Click Tracking** - How to maintain statistics  
✅ **URL Validation** - How to verify user input  
✅ **Error Handling** - How to manage failures gracefully  
✅ **Deployment** - How to put code on the internet  
✅ **Debugging** - How to find and fix problems systematically  

---


## 📋 Project Overview

### The Problem

You have URLs like:
```
https://en.wikipedia.org/wiki/Artificial_intelligence?utm_source=twitter&utm_campaign=ai_article_2026
```

This is long, hard to remember, breaks in some contexts.

**Solution:** Create short URLs
```
https://short.url/abc123
```

When someone visits the short URL, they get redirected to the original.

### The Big Picture

```
┌─────────────┐
│   Browser   │  User types short URL
└─────────────┘
       │
       ▼
┌─────────────────┐
│  Your Server    │  Lookup short code
└─────────────────┘
       │
       ▼
┌─────────────┐
│  Database   │  Find original URL
└─────────────┘
       │
       ▼
┌─────────────┐
│   Browser   │  Redirect to original
└─────────────┘
```

**Your job:** Build the server and database.

---


## 🧠 Implementation: Pseudocode First, Real Code After

### How to Generate Unique Short Codes

**Option 1: Random (What should you choose?)**
```pseudocode
function generateShortCode():
  characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
  code = ""
  repeat 6 times:
    pick random character from characters
    add to code
  return code

Advantage: _________ (you think)
Disadvantage: _________ (you think)
```

**Option 2: Counter (What about this?)**
```pseudocode
function generateShortCode():
  count = read from database (how many URLs exist?)
  convert count to base62 string
  return base62

Advantage: _________ (you think)
Disadvantage: _________ (you think)
```

**Question: Which would you use? Why?**

---

### Building the Shorten Endpoint

**Pseudocode (NOT real code):**

```pseudocode
function shortenUrl(request):
  Step 1: Get longUrl from request
  Step 2: Validate URL (is it really a URL?)
    If not valid:
      return error "Invalid URL"
  
  Step 3: Check if customCode provided
    If yes:
      code = customCode
    If no:
      code = generateShortCode()
  
  Step 4: Check if code exists in database
    If exists:
      return error "Code already exists"
  
  Step 5: Insert into database
    INSERT urls (shortCode, longUrl) VALUES (code, longUrl)
    If fails:
      return error "Database error"
  
  Step 6: Build short URL
    shortUrl = "http://localhost:3000/" + code
  
  Step 7: Return success
    return {
      shortCode: code,
      shortUrl: shortUrl,
      longUrl: longUrl
    }
```

**Now you write the real code using this pseudocode as guide.**

---

### Building the Redirect Endpoint

**Pseudocode:**

```pseudocode
function redirect(shortCode):
  Step 1: Query database
    SELECT longUrl FROM urls WHERE shortCode = ?
  
  Step 2: Check result
    If no result found:
      return 404 "URL not found"
  
  Step 3: Increment clicks
    UPDATE urls SET clicks = clicks + 1 WHERE shortCode = ?
  
  Step 4: Redirect
    return HTTP 302 redirect to longUrl
```

---


## ✅ Before Submission

**Technical Checklist:**
- [ ] Works after `git clone` and `npm install`
- [ ] Deployed to live URL
- [ ] Can shorten a real URL
- [ ] Short link redirects correctly
- [ ] Clicks increment
- [ ] Database persists after restart
- [ ] Error handling works

**Learning Checklist:**
- [ ] Can explain architecture
- [ ] Can explain database design
- [ ] Can explain API design
- [ ] Can debug basic issues
- [ ] Understand your own code

**Documentation:**
- [ ] README.md explains project
- [ ] Setup instructions work
- [ ] Database schema documented
- [ ] API endpoints documented
- [ ] Demo credentials provided

**Demo Preparation:**
- [ ] Can demo 3 core features
- [ ] Can explain what you learned
- [ ] Know how to debug common issues
- [ ] Can discuss design decisions
- [ ] Can suggest improvements

---
