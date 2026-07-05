# 🔗 Link Expiration System: Learn By Building

**"Build a secure link-sharing API that generates unique URLs that automatically expire after a certain number of clicks or a specific time limit."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **HTTP Redirects** - How the web moves users around using `301` and `302` status codes and `Location` headers.  
✅ **Atomic Database Operations** - Preventing Race Conditions by letting the SQL engine handle the math (`current_clicks = current_clicks + 1`).  
✅ **Validation** - Ensuring users provide valid URLs (using JavaScript's `URL` constructor) to prevent bad redirects.  
✅ **HTTP 410 Gone** - Proper use of semantic HTTP status codes.

---

## 📋 Project Overview

### The Problem

Sometimes you want to share a file or a meeting link, but you don't want it floating around the internet forever. You want strict access control based on time or usage.

**Your job:** Build the logic engine that intercepts a click, instantly checks a database for limits, increments a counter securely, and then either forwards the user to their destination or stops them in their tracks.

### Who Uses It

```
Creator:
├─ POSTs target URL + limits
└─ Shares the short link

User:
├─ Clicks short link
├─ Server checks time limit
├─ Server checks click limit
├─ Server increments click counter
└─ Server Redirects to target URL
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. Creating the Link

```pseudocode
POST /api/links:
  Step 1: Validate the URL
    target_url = request.body.target_url
    
    try:
      parsed_url = new URL(target_url) // Native JS URL parser
      if parsed_url.protocol != "http:" && parsed_url.protocol != "https:":
        throw Error
    catch:
      return 400 "Invalid URL"
      
  Step 2: Generate ID
    short_id = generateNanoid(6)
    
  Step 3: Save to DB
    db.insert("links", {
      id: short_id,
      target_url: target_url,
      max_clicks: request.body.max_clicks || null,
      expires_at: request.body.expires_at || null
    })
    
  Step 4: Return
    return 201 { short_url: `http://localhost:3000/s/${short_id}` }
```

### 2. The Redirect Engine

```pseudocode
GET /s/:id:
  Step 1: Fetch the Link
    link = db.query("SELECT * FROM links WHERE id = ?", request.params.id)
    if !link: return 404 "Not Found"
    
  Step 2: Check Time Expiration
    if link.expires_at != null:
      now = new Date()
      expires = new Date(link.expires_at)
      if now > expires:
        return 410 "Link Expired (Time limit reached)"
        
  Step 3: Atomic Click Increment & Check
    // This SQL query is the magic. It tries to update the row.
    // If current_clicks is already equal to max_clicks, it fails to update.
    result = db.query(`
      UPDATE links 
      SET current_clicks = current_clicks + 1 
      WHERE id = ? 
      AND (max_clicks IS NULL OR current_clicks < max_clicks)
    `, request.params.id)
    
    // Check if the query actually changed a row
    if result.rows_affected == 0:
      return 410 "Link Expired (Click limit reached)"
      
  Step 4: Redirect!
    // Tell Express to send a 302 Redirect Header
    response.redirect(302, link.target_url)
```

---

## ✅ Before Submission

- [ ] API accepts a target URL and optional click/time limits.
- [ ] API validates that the input is an actual URL.
- [ ] Visiting `/s/:id` redirects the user if limits are not met.
- [ ] Visiting `/s/:id` returns a `410 Gone` if limits ARE met.
- [ ] Click counter is updated atomically to prevent race conditions.
- [ ] Code is on GitHub.

**Success:** You have built a production-ready link manager!
