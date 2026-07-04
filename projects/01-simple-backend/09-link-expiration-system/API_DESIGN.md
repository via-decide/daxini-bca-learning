# Link Expiration System: Learn By Building

**"Build a secure file/resource sharing API that automatically deletes access after a specific time limit or view count is reached."**

---


## 🔌 API Design: Plan Before Coding

### Endpoint 1: Create Secret
**POST `/api/secrets`**
- **Body**:
```json
{
  "message": "My bank password is 1234",
  "max_views": 1,
  "expires_in_hours": 1
}
```
- **Response**: `201 Created`
```json
{
  "id": "8f2c...",
  "url": "http://localhost:3000/api/secrets/8f2c..."
}
```

### Endpoint 2: Read Secret
**GET `/api/secrets/:id`**
- **Response (Valid)**: `200 OK`
```json
{ "message": "My bank password is 1234" }
```
- **Response (Expired/Invalid)**: `410 Gone`
```json
{ "error": "This secret has expired or reached its view limit." }
```

---
