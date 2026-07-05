# 💱 Currency Converter API: API Design

**"Build a fast, precise API that converts between global currencies by fetching and caching live exchange rates."**

---

## 🔗 API Endpoints

```
GET    /api/convert                   → Convert an amount between two currencies
GET    /api/rates/:base               → Get all exchange rates for a base currency
```

---

## 📦 Request/Response Examples

### 1. Perform a Conversion

**Request:**
```http
GET /api/convert?from=USD&to=EUR&amount=150.50 HTTP/1.1
```

**Response (200):**
```json
{
  "query": {
    "from": "USD",
    "to": "EUR",
    "amount": 150.50
  },
  "info": {
    "rate": 0.8524,
    "timestamp": "2026-10-01T10:00:00Z"
  },
  "result": 128.29
}
```

### 2. Get All Rates

**Request:**
```http
GET /api/rates/USD HTTP/1.1
```

**Response (200):**
```json
{
  "base": "USD",
  "date": "2026-10-01",
  "rates": {
    "EUR": 0.8524,
    "GBP": 0.7215,
    "JPY": 110.45,
    "INR": 82.50
  }
}
```

---

## ⚠️ Error Responses

```json
// 400 Bad Request (Invalid currency code)
{ "error": "Invalid currency code provided. Must be a valid 3-letter ISO code (e.g., USD)." }

// 400 Bad Request (Invalid amount)
{ "error": "Amount must be a positive number." }

// 502 Bad Gateway (3rd Party API is down and cache is empty)
{ "error": "Exchange rate provider is currently unavailable." }
```
