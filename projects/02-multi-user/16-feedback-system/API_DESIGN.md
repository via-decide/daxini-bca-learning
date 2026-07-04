## 🔌 API Design: Plan Before Coding

### 1. Submit Review
**POST `/api/reviews`**
- **Body**: `{ "entity_id": "123", "rating": 5, "comment": "Great!" }`
- **Logic**: Use a Transaction.
  1. Insert into `reviews`.
  2. `UPDATE entities SET total_reviews = total_reviews + 1, average_rating = (SELECT AVG(rating) FROM reviews WHERE entity_id = 123) WHERE id = 123`.

### 2. Get Top Rated
**GET `/api/entities/top-rated`**
- **Logic**: `SELECT * FROM entities WHERE total_reviews > 10 ORDER BY average_rating DESC LIMIT 10`.
