# Currency Converter API: Learn By Building

**"Build a fast API that converts between currencies by aggregating live exchange rates and handling precise math operations securely."**

---


## 🔌 API Design: Plan Before Coding

### Endpoint 1: Convert Currency
**GET `/api/convert?from=USD&to=INR&amount=50`**
- **Purpose**: Converts a specific amount.
- **Response**: `200 OK`
```json
{
  "from": "USD",
  "to": "INR",
  "amount": 50,
  "converted_amount": 4152.50,
  "exchange_rate": 83.05,
  "last_updated": "2024-10-24T12:00:00Z"
}
```

---
