# Currency Converter API: Learn By Building

**"Build a fast API that converts between currencies by aggregating live exchange rates and handling precise math operations securely."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Third-Party API Integration** - Fetching live exchange rates from external services securely.
✅ **Caching Mechanisms** - Caching daily/hourly exchange rates to prevent rate-limit exhaustion.
✅ **Floating Point Math** - Handling currency math without losing precision (avoiding standard floating-point errors).
✅ **Data Normalization** - Standardizing currency codes (ISO 4217) and handling edge cases like missing currencies.
✅ **Graceful Fallbacks** - Using a secondary API or stale cache if the primary exchange rate service goes down.

---

## 📋 Project Overview

### The Problem
Converting USD to EUR isn't as simple as multiplying by a static number. Exchange rates change constantly. However, if your frontend fetches rates directly from an API like ExchangeRate-API, you expose your API keys. Additionally, if you get 1,000 users converting currencies simultaneously, you'll burn through your API quota in minutes. You need a backend proxy that caches the rates and does the math for the user.

### Who Uses It
```
E-Commerce Checkout (Frontend):
├─ Requests: "Convert 50.00 USD to INR"
└─ Receives: Clean JSON { "result": 4152.50, "rate": 83.05 }

Backend Proxy (You):
├─ Hides the exchange rate API key
├─ Checks if USD-to-INR rate is in cache (less than 1 hour old)
├─ Does the precise math
└─ Returns the result instantly
```

### The Big Picture

```text
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Web Client  │ ──> │ Your Backend │ ──> │ Redis/Memory │
│  (Frontend)  │ <── │ (Calculator) │ <── │ (1 Hour TTL) │
└──────────────┘     └──────┬───────┘     └──────────────┘
                            │
                            │ (Cache Miss)
                            V
                     ┌──────────────┐
                     │ External     │
                     │ Exchange API │
                     └──────────────┘
```

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data

**Question: Do we need to store every conversion ever made?**
- No, conversions are stateless. We just return the result.
- We DO need to store exchange rates temporarily. The key should be the base currency.

**Data Model (Cache):**
- Key: `rates:{base_currency}`
- Value: JSON map of all target currencies and their rates.

### Step 2: Architecture Diagram

```text
1. Client requests GET /api/convert?from=USD&to=EUR&amount=100
2. API validates inputs (Are they real ISO codes? Is amount a positive number?)
3. API checks Cache for key "rates:USD"
4. IF CACHE HIT -> Extract EUR rate, calculate, return.
5. IF CACHE MISS -> 
     a. Fetch USD rates from External API
     b. Save all USD rates to Cache with 3600 seconds TTL
     c. Extract EUR rate, calculate, return.
```

### Step 3: Floating Point Math
**Never use standard floats for money.**
If you do `0.1 + 0.2` in JavaScript, you get `0.30000000000000004`. If you scale this to millions, you lose real money. 
**Solution:** Multiply amounts by 100 to convert to cents (integers), do the math, and divide by 100 before returning.

---

## 🗄️ Database: Design, Don't Code

### Schema Design

We use an in-memory key-value store (like Redis or local map).

```text
Key Format: rates:{base_currency_uppercase}
Example Key: rates:USD
Value: '{"EUR": 0.92, "INR": 83.05, "GBP": 0.79}'
TTL (Expiration): 3600 seconds (1 hour)
```

### Design Questions

1. **Why fetch all rates for USD instead of just USD-to-EUR?**
   External APIs usually return all rates for a base currency in a single request. By caching the whole map, if the next user asks for USD-to-GBP, it's already in the cache!

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

## 🧠 Implementation: Pseudocode First

```text
FUNCTION convert_currency(request):
    from_curr = uppercase(request.query.from)
    to_curr = uppercase(request.query.to)
    amount_raw = request.query.amount
    
    // 1. Validation
    IF not is_valid_number(amount_raw) or amount_raw <= 0:
        RETURN 400 "Invalid amount"
    IF not is_valid_currency_code(from_curr) or not is_valid_currency_code(to_curr):
        RETURN 400 "Invalid currency code"
        
    cache_key = "rates:" + from_curr
    
    // 2. Fetch Rates (Cache or API)
    rates_data = Redis.get(cache_key)
    IF rates_data is NULL:
        api_key = ENV.EXCHANGE_API_KEY
        response = HTTP.GET("https://api.exchangerate.host/latest?base=" + from_curr)
        rates_data = response.rates
        Redis.setex(cache_key, 3600, to_json(rates_data))
        
    // 3. Calculation
    rate = rates_data[to_curr]
    IF rate is NULL:
        RETURN 400 "Target currency not supported"
        
    // Integer math to avoid precision issues
    amount_cents = integer(amount_raw * 100)
    converted_cents = integer(amount_cents * rate)
    final_amount = converted_cents / 100
    
    RETURN {
        from: from_curr,
        to: to_curr,
        amount: amount_raw,
        converted_amount: final_amount,
        exchange_rate: rate
    }
```

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Floating Point Math
**What's wrong:** Doing `amount * rate` using standard programming language floats.
**Why it's bad:** It introduces rounding errors that fail financial auditing.
**How to fix:** Convert to the smallest currency unit (cents, paisa) as integers before doing multiplication.

### ❌ Mistake 2: Not Normalizing Inputs
**What's wrong:** Letting users query `?from=usd` and checking the cache for `rates:usd`.
**Why it's bad:** You'll get cache misses because you stored it as `rates:USD`.
**How to fix:** Always `.toUpperCase()` inputs immediately.

---

## 🧪 Testing: How to Verify

### Test 1: Math Precision
- Request `amount=10.05` with a rate of `1.12`.
- Calculate manually on paper. Ensure the API returns the exact 2-decimal rounded number.

### Test 2: Cache TTL Verification
- Request a conversion. Look at the exchange rate.
- Wait a few minutes and request again. The rate should be identical.
- Force flush the cache, request again. The rate should update.

---

## 🛠️ Debugging: When Things Break

### Problem: API returns "NaN" for converted_amount
**Root Cause:** The `amount` query parameter is being parsed as a String, not a Number. `String * Number = NaN`.
**Solution:** Explicitly cast `amount` to a Float/Decimal before doing the cents conversion.

---

## 📚 Resources

- **Currency Math**: "Why you shouldn't use floats for money" (Article)
- **Exchange Rates**: Open Exchange Rates API / ExchangeRate-API documentation.

---

## ✅ Before Submission

- [ ] Does the API correctly convert strings to uppercase?
- [ ] Are you caching the rate list for at least 1 hour?
- [ ] Are you using integer math (cents) to avoid floating point errors?
- [ ] Does it return a 400 error for unknown currency codes?

---

**Build this and learn: Safe financial math, third-party API proxying, and data normalization.**
