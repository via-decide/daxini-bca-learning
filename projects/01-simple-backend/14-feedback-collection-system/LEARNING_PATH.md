# 📝 Feedback Collection System: Learn By Building

**"Build an API that allows a business to create multiple feedback forms (e.g. 'Website Redesign', 'Customer Support'), generate unique links for them, and securely collect and aggregate user responses."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Relational Data (One-to-Many)** - Linking multiple `responses` to a single `form` using Foreign Keys.  
✅ **SQL Aggregation** - Using `COUNT()`, `AVG()`, and `GROUP BY` to make the database do the heavy mathematical lifting.  
✅ **Data Anonymization** - Hashing IP addresses to prevent double-voting without violating user privacy laws (GDPR).  
✅ **Database Constraints** - Using SQL `CHECK` constraints to enforce data integrity (e.g., ensuring ratings are exactly 1-5) at the lowest level.

---

## 📋 Project Overview

### The Problem

Polling systems are incredibly common (Twitter polls, YouTube surveys, NPS scores). The backend challenge is twofold: 
1) **Write Heavy:** You might receive thousands of votes per second. The insertion logic must be fast and secure against spam.
2) **Read Heavy (Analytics):** The admin dashboard needs to calculate statistics across millions of rows instantly without crashing the server.

**Your job:** Build a highly optimized, relational database backend that handles both the firehose of incoming data and the complex math required for the dashboard.

### Who Uses It

```
The Business (Admin):
├─ POSTs to /api/forms to create a poll
└─ GETs /api/forms/:id/analytics to view the charts

The Customer:
├─ GETs /api/forms/:id to view the question
└─ POSTs to /api/forms/:id/responses to submit a 5-star rating
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. Creating the Form (Admin)

```pseudocode
POST /api/forms:
  id = request.body.id // Allow them to choose a nice URL slug, e.g. "q3-survey"
  title = request.body.title
  
  // Basic validation...
  
  try:
    db.insert("forms", { id, title, is_active: true })
    return 201 "Created"
  catch (error):
    // If ID already exists, SQLite will throw a UNIQUE constraint error
    return 400 "That URL slug is already taken"
```

### 2. Handling the Submission (Public)

```pseudocode
POST /api/forms/:id/responses:
  Step 1: Check Form Status
    form = db.query("SELECT is_active FROM forms WHERE id = ?", request.params.id)
    if !form: return 404 "Form not found"
    if !form.is_active: return 403 "Form closed"
    
  Step 2: Validate Input
    rating = request.body.rating
    if typeof rating != "number" || rating < 1 || rating > 5:
      return 400 "Rating must be 1-5"
      
  Step 3: Spam Prevention (Hash the IP)
    raw_ip = request.ip
    salt = "my_secret_salt_123"
    // Create a unique hash for THIS user on THIS specific form
    voter_hash = sha256(raw_ip + request.params.id + salt)
    
  Step 4: Save to Database
    try:
      db.insert("responses", {
        id: generateUUID(),
        form_id: request.params.id,
        rating: rating,
        comment: request.body.comment,
        voter_hash: voter_hash
      })
      return 201 "Success"
    catch (error):
      // If our database has a UNIQUE INDEX on (form_id, voter_hash), 
      // the DB will throw an error if they try to vote twice!
      return 429 "You have already voted"
```

### 3. The Analytics Engine (Admin)

```pseudocode
GET /api/forms/:id/analytics:
  
  // Query 1: Get the basic stats (One row returned)
  // AVG() and COUNT() are native SQL functions
  stats = db.query(`
    SELECT COUNT(id) as total, AVG(rating) as average 
    FROM responses 
    WHERE form_id = ?
  `, id)
  
  // Query 2: Get the breakdown (Returns up to 5 rows)
  // e.g. [{ rating: 5, count: 80 }, { rating: 4, count: 40 }]
  breakdown = db.query(`
    SELECT rating, COUNT(id) as count 
    FROM responses 
    WHERE form_id = ? 
    GROUP BY rating
  `, id)
  
  // Format the response for the frontend charts
  return 200 {
    total_responses: stats.total,
    average_rating: stats.average,
    rating_breakdown: formatBreakdownToJSON(breakdown)
  }
```

---

## ✅ Before Submission

- [ ] System supports multiple separate forms with unique IDs.
- [ ] Users can submit a rating (1-5) and an optional comment.
- [ ] Forms can be deactivated (closing them to new responses).
- [ ] The API prevents the same IP address from voting twice on the same form.
- [ ] The API calculates the average rating using SQL (`AVG`), not Javascript loops.
- [ ] Code is on GitHub.

**Success:** You have built a relational, data-aggregation backend!
