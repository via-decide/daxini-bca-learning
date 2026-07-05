# 🗣️ Customer Support Feedback System: API Design

**"Build a multi-user API where Customers leave reviews for specific Support Agents, and Admins view aggregated performance scores to identify top employees."**

---

## 🔗 API Endpoints

*(All routes require Authentication via JWT)*

**Customer Operations (Requires 'customer' role):**
```
GET    /api/tickets/me         → View my past support tickets
POST   /api/feedback           → Submit a review for a specific ticket
```

**Agent Operations (Requires 'agent' role):**
```
GET    /api/agents/me/stats    → View my personal average score and recent reviews
```

**Admin Operations (Requires 'admin' role):**
```
GET    /api/reports/leaderboard → View all agents ranked by average score
GET    /api/agents/:id/reviews  → Drill down into a specific agent's reviews
```

---

## 📦 Request/Response Examples

### 1. Submit Feedback (Customer)

**Request:**
```json
POST /api/feedback
{
  "ticket_id": "ticket-123",
  "rating": 5,
  "comments": "Alice was incredibly patient and solved my billing issue!"
}
```

**Response (201):**
```json
{
  "message": "Feedback submitted successfully",
  "feedback": {
    "id": "feed-999",
    "ticket_id": "ticket-123",
    "rating": 5
  }
}
```

### 2. View Personal Stats (Agent)

**Request:**
```http
GET /api/agents/me/stats HTTP/1.1
```

**Response (200):**
```json
{
  "agent_id": "agent-alice",
  "name": "Alice Smith",
  "metrics": {
    "average_rating": 4.85,
    "total_reviews": 142,
    "five_star_percentage": "90%"
  },
  "recent_comments": [
    "Alice was incredibly patient...",
    "Fast response, very helpful."
  ]
}
```

### 3. Generate Leaderboard (Admin)

The backend calculates the ranking dynamically using SQL aggregation.

**Request:**
```http
GET /api/reports/leaderboard?min_reviews=10 HTTP/1.1
```

**Response (200):**
```json
{
  "period": "All Time",
  "rankings": [
    {
      "rank": 1,
      "agent_id": "agent-alice",
      "agent_name": "Alice Smith",
      "average_rating": 4.85,
      "total_reviews": 142
    },
    {
      "rank": 2,
      "agent_id": "agent-bob",
      "agent_name": "Bob Jones",
      "average_rating": 4.20,
      "total_reviews": 89
    }
  ]
}
```

---

## ⚠️ Error Responses

```json
// 409 Conflict (Customer tries to submit a second review for the same ticket)
{ "error": "Feedback has already been submitted for this ticket." }

// 400 Bad Request (Customer sends a 6-star rating)
{ "error": "Rating must be an integer between 1 and 5." }

// 403 Forbidden (Customer tries to review a ticket that belongs to someone else)
{ "error": "You do not have permission to review this ticket." }
```
