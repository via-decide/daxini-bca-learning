# 🔐 Password Strength Checker: API Design

**"Build a stateless API that analyzes a given password and returns a score, a list of vulnerabilities, and estimated time to crack."**

---

## 🔗 API Endpoints

### The Analysis Endpoint

```
POST   /api/check-strength      → Analyze a password and return comprehensive metrics
```

---

## 📦 Request/Response Examples

### 1. Check a Weak Password

**Request:**
```json
POST /api/check-strength
{
  "password": "Password123!",
  "user_inputs": ["john.doe@gmail.com", "John", "Doe"] // Optional: words the password shouldn't contain
}
```

**Response (200):**
```json
{
  "score": 1, 
  "score_label": "Weak",
  "crack_time_display": "less than a second",
  "crack_time_seconds": 0.05,
  "feedback": {
    "warning": "This is a top-100 common password.",
    "suggestions": [
      "Add another word or two. Uncommon words are better.",
      "Avoid predictable number sequences like '123'."
    ]
  },
  "metrics": {
    "length": 12,
    "has_uppercase": true,
    "has_lowercase": true,
    "has_numbers": true,
    "has_symbols": true
  },
  "is_breached": true,
  "breach_count": 145920 
}
```
*(Notice how it has uppercase, lowercase, numbers, and symbols, yet the score is only 1! This demonstrates why regex validation is flawed compared to dictionary analysis.)*

### 2. Check a Strong Password

**Request:**
```json
POST /api/check-strength
{
  "password": "RedOctopusDancesInTheRain2026!"
}
```

**Response (200):**
```json
{
  "score": 4, 
  "score_label": "Very Strong",
  "crack_time_display": "centuries",
  "crack_time_seconds": 9.8e15,
  "feedback": {
    "warning": null,
    "suggestions": []
  },
  "metrics": {
    "length": 30,
    "has_uppercase": true,
    "has_lowercase": true,
    "has_numbers": true,
    "has_symbols": true
  },
  "is_breached": false,
  "breach_count": 0
}
```

---

## ⚠️ Error Responses

```json
// 400 Bad Request
{ "error": "Password field is required and must be a string." }

// 413 Payload Too Large
{ "error": "Password exceeds maximum length of 100 characters." }
```
