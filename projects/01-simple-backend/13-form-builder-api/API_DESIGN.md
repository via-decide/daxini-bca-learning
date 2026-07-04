# Form Builder API: Learn By Building

**"Build a dynamic API that allows users to define custom form fields (JSON schemas), and then strictly validates incoming submissions against those user-defined rules."**

---


## 🔌 API Design: Plan Before Coding

### Endpoint 1: Create a Form
**POST `/api/forms`**
- **Body**:
```json
{
  "title": "Event Registration",
  "fields": [
    { "id": "name", "type": "string", "required": true },
    { "id": "age", "type": "number", "min": 18, "required": true }
  ]
}
```

### Endpoint 2: Submit a Form
**POST `/api/forms/:id/submit`**
- **Body**:
```json
{
  "answers": {
    "name": "Alice",
    "age": 16
  }
}
```
- **Response**: `400 Bad Request`
```json
{ "error": "Validation failed: 'age' must be at least 18." }
```

---
