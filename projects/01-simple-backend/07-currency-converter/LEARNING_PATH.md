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


## ✅ Before Submission

- [ ] Does the API correctly convert strings to uppercase?
- [ ] Are you caching the rate list for at least 1 hour?
- [ ] Are you using integer math (cents) to avoid floating point errors?
- [ ] Does it return a 400 error for unknown currency codes?

---

**Build this and learn: Safe financial math, third-party API proxying, and data normalization.**
