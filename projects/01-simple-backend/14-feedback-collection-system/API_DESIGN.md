# Feedback Collection System API: Learn By Building

**"Build an embeddable widget API that accepts feedback ratings, aggressively blocks spam using IP rate-limiting, and calculates real-time averages."**

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
