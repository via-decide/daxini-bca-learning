# 🗣️ Customer Support Feedback System: Learn By Building

**"Build a multi-user API where Customers leave reviews for specific Support Agents, and Admins view aggregated performance scores to identify top employees."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **One-to-One Relationships** - Using `UNIQUE` constraints on foreign keys to ensure a child record (Review) can only be created once for a parent record (Ticket).  
✅ **SQL Aggregation (`AVG`, `COUNT`)** - Offloading mathematical operations to the database for high performance.  
✅ **Denormalization** - Knowing when to purposefully break database normalization rules (like storing `agent_id` on the review table) to speed up read queries.

---

## 📋 Project Overview

### The Problem

A feedback system must be trustworthy. If a customer can leave multiple reviews for the same interaction, the metrics are broken. If the metrics are broken, the Admin's leaderboard is useless.

Furthermore, as the company grows, they might have hundreds of agents and millions of reviews. If your backend pulls all that data into memory just to calculate who has a 4.5 average, your server will crash.

**Your job:** Build an API that strictly limits reviews to a 1-to-1 ratio using database constraints, and uses SQL aggregation to generate performance leaderboards instantly.

### Who Uses It

```
Customer:
└─ POST /api/feedback (Submits a review for their ticket)

Agent:
└─ GET /api/agents/me/stats (Checks their own performance)

Admin:
└─ GET /api/reports/leaderboard (Views the rankings)
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. Submitting Feedback (Handling the UNIQUE constraint)

Because the database has a `UNIQUE(ticket_id)` constraint, we can just try to insert it. If it fails, we catch the specific database error code for a constraint violation.

```pseudocode
POST /api/feedback:
  middlewares: [authenticateUser, requireRole(['customer'])]
  
  req_ticket_id = request.body.ticket_id
  req_rating = request.body.rating
  
  // 1. Verify Ownership & Get Agent ID
  ticket = db.query("SELECT * FROM support_tickets WHERE id = ?", req_ticket_id)
  
  if !ticket or ticket.customer_id != req.user.id:
    return 403 "Forbidden"
    
  // 2. Insert the Review
  try:
    // Notice we save agent_id directly here for faster analytics later
    db.query(`
      INSERT INTO feedback_reviews (id, ticket_id, customer_id, agent_id, rating, comments)
      VALUES (UUID(), ?, ?, ?, ?, ?)
    `, [req_ticket_id, req.user.id, ticket.agent_id, req_rating, request.body.comments])
    
    return 201 "Review submitted!"
    
  catch (error):
    // Check if the error is a UNIQUE constraint violation (Error codes vary by DB)
    if isUniqueViolation(error):
      return 409 "You have already reviewed this ticket."
    else:
      return 500 "Internal Server Error"
```

### 2. The Admin Leaderboard (SQL Aggregation)

We want a list of agents, ordered by their average rating, but perhaps we only want to include agents who have at least 5 reviews (to avoid an agent with a single 5-star review being ranked #1).

```pseudocode
GET /api/reports/leaderboard:
  middlewares: [authenticateUser, requireRole(['admin'])]
  
  // We use the HAVING clause to filter AFTER the GROUP BY has counted the reviews
  leaderboard = db.query(`
    SELECT 
      u.id as agent_id,
      u.full_name as agent_name,
      ROUND(AVG(f.rating), 2) as average_rating,
      COUNT(f.id) as total_reviews
    FROM feedback_reviews f
    JOIN users u ON f.agent_id = u.id
    GROUP BY u.id, u.full_name
    HAVING COUNT(f.id) >= 5
    ORDER BY average_rating DESC
  `)
  
  return 200 { rankings: leaderboard }
```

### 3. Agent Personal Stats

An agent wants to see their average, plus their last 3 reviews.

```pseudocode
GET /api/agents/me/stats:
  middlewares: [authenticateUser, requireRole(['agent'])]
  
  // 1. Get the Math
  stats = db.query(`
    SELECT ROUND(AVG(rating), 2) as avg_score, COUNT(*) as total
    FROM feedback_reviews
    WHERE agent_id = ?
  `, req.user.id)
  
  // 2. Get recent comments
  recent = db.query(`
    SELECT rating, comments, created_at 
    FROM feedback_reviews 
    WHERE agent_id = ? 
    ORDER BY created_at DESC 
    LIMIT 3
  `, req.user.id)
  
  return 200 {
    metrics: stats[0],
    recent_reviews: recent
  }
```

---

## ✅ Before Submission

- [ ] System separates Customer, Agent, and Admin roles.
- [ ] The `feedback_reviews` table uses a `UNIQUE` constraint on `ticket_id` to enforce a 1-to-1 relationship.
- [ ] Customers are prevented from reviewing tickets that belong to other people.
- [ ] The Admin leaderboard uses SQL `AVG()`, `COUNT()`, `GROUP BY`, and `HAVING` to calculate rankings dynamically.
- [ ] Code is on GitHub.

**Success:** You have built an analytics-driven feedback engine!
