# 📝 Feedback Collection System: API Design

**"Build an API that allows a business to create multiple feedback forms (e.g. 'Website Redesign', 'Customer Support'), generate unique links for them, and securely collect and aggregate user responses."**

---

## 🔗 API Endpoints

**Admin Routes (Should be protected in reality, but we'll leave open for this project):**
```
POST   /api/forms                → Create a new feedback form
GET    /api/forms/:id/analytics  → Get aggregated stats (average rating, total responses)
GET    /api/forms/:id/responses  → Get the actual text comments (paginated)
```

**Public Routes (For the end-users):**
```
GET    /api/forms/:id            → Get form details (to display the title on the frontend)
POST   /api/forms/:id/responses  → Submit a response
```

---

## 📦 Request/Response Examples

### 1. Create a Form (Admin)

**Request:**
```json
POST /api/forms
{
  "id": "website-redesign-2026",
  "title": "What do you think of our new website?"
}
```

**Response (201):**
```json
{
  "message": "Form created",
  "form": {
    "id": "website-redesign-2026",
    "title": "What do you think of our new website?",
    "is_active": true,
    "url": "http://localhost:3000/api/forms/website-redesign-2026"
  }
}
```

### 2. Submit a Response (Public User)

**Request:**
```json
POST /api/forms/website-redesign-2026/responses
{
  "rating": 4,
  "comment": "Looks great, but the fonts are a bit small."
}
```

**Response (201):**
```json
{
  "message": "Thank you for your feedback!"
}
```

### 3. View Analytics (Admin)

**Request:**
```http
GET /api/forms/website-redesign-2026/analytics HTTP/1.1
```

**Response (200):**
```json
{
  "form_id": "website-redesign-2026",
  "title": "What do you think of our new website?",
  "analytics": {
    "total_responses": 142,
    "average_rating": 4.2,
    "rating_breakdown": {
      "5": 80,
      "4": 40,
      "3": 10,
      "2": 5,
      "1": 7
    }
  }
}
```
*(Notice how the backend does all the heavy math. The frontend just takes these numbers and puts them directly into a Pie Chart or Bar Graph).*

---

## ⚠️ Error Responses

```json
// 400 Bad Request (Validation)
{ "error": "Rating must be an integer between 1 and 5." }

// 404 Not Found (User clicked a bad link)
{ "error": "Form not found." }

// 403 Forbidden (Form was turned off by admin)
{ "error": "This feedback form is no longer accepting responses." }

// 429 Too Many Requests (Spam prevention triggered)
{ "error": "You have already submitted feedback for this form." }
```
