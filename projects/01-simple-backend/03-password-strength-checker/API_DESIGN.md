# Password Strength Checker: Learn By Building

**"Build a security utility that evaluates password complexity, entropy, and checks against known data breaches."**

---


## 🔌 API Design: Plan Before Coding

### Endpoint 1: Evaluate Password

**POST `/api/evaluate`**
- **Purpose**: Calculate strength and check for breaches.
- **Request**: `{ "password": "MySuperSecretPassword42!" }`
- **Response**: 
```json
{
  "score": 85,
  "feedback": {
    "warning": "",
    "suggestions": ["Add another word or two"]
  },
  "is_breached": false,
  "breach_count": 0,
  "time_to_crack": "3 centuries"
}
```

---
