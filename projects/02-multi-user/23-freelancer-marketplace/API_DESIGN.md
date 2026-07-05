# 💼 Freelancer Marketplace API: API Design

**"Build a multi-user API where Clients post freelance jobs, Freelancers bid on those jobs, and Clients accept a bid to initiate a contract."**

---

## 🔗 API Endpoints

*(All routes require Authentication via JWT)*

**Client Operations (Requires 'client' role):**
```
POST   /api/projects           → Post a new freelance project
GET    /api/projects/my        → List projects I have created
GET    /api/projects/:id/bids  → View all bids on my specific project
PUT    /api/bids/:id/accept    → Accept a specific bid (Locks the project)
```

**Freelancer Operations (Requires 'freelancer' role):**
```
GET    /api/projects           → Search 'open' projects
POST   /api/projects/:id/bids  → Submit a bid on an open project
GET    /api/bids/my            → View status of my submitted bids
```

---

## 📦 Request/Response Examples

### 1. Submit a Bid (Freelancer)

**Request:**
```json
POST /api/projects/proj-123/bids
{
  "amount": 450.00,
  "delivery_days": 3,
  "proposal_text": "I have 5 years of experience building similar websites."
}
```

**Response (201):**
```json
{
  "message": "Bid submitted successfully",
  "bid": {
    "id": "bid-999",
    "status": "pending",
    "amount": 450.00
  }
}
```

### 2. View Bids (Client)

The Client fetches bids for their project. They see everything. (If a freelancer calls this endpoint, they should get a 403 Forbidden).

**Request:**
```http
GET /api/projects/proj-123/bids HTTP/1.1
```

**Response (200):**
```json
{
  "project_title": "Build a website",
  "bids": [
    {
      "bid_id": "bid-999",
      "freelancer_name": "Frank",
      "amount": 450.00,
      "delivery_days": 3,
      "proposal": "I have 5 years...",
      "status": "pending"
    },
    {
      "bid_id": "bid-888",
      "freelancer_name": "Fiona",
      "amount": 300.00,
      "delivery_days": 7,
      "proposal": "I can do this cheaply.",
      "status": "pending"
    }
  ]
}
```

### 3. Accept a Bid (Client)

This is a transactional endpoint. It marks the bid as 'accepted', marks all other bids for this project as 'rejected', and marks the project as 'in_progress'.

**Request:**
```json
PUT /api/bids/bid-999/accept
{}
```

**Response (200):**
```json
{
  "message": "Bid accepted. Contract initiated with Frank.",
  "project_status": "in_progress"
}
```

---

## ⚠️ Error Responses

```json
// 409 Conflict (Freelancer tries to submit a second bid on the same project)
{ "error": "You have already placed a bid on this project." }

// 400 Bad Request (Freelancer tries to bid on a project that is already 'in_progress')
{ "error": "This project is no longer accepting bids." }

// 403 Forbidden (Client tries to accept a bid for a project they did not create)
{ "error": "You do not have permission to manage this project." }
```
