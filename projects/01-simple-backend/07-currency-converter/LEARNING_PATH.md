# 💱 Currency Converter API: Learn By Building

**"Build a fast, precise API that converts between global currencies by fetching and caching live exchange rates."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Financial Precision** - Why `0.1 + 0.2 != 0.3` in JavaScript and how to safely calculate currency.  
✅ **Cross-Calculation Math** - Using a single base exchange rate sheet to calculate conversions between any two currencies.  
✅ **API Rate Limiting & Caching** - Respecting the limits of 3rd party providers by locally storing their data for 1 hour.  
✅ **JSON in SQL** - Storing complex JSON objects in a single text column.

---

## 📋 Project Overview

### The Problem

If you are building an e-commerce site, you need to display prices in the user's local currency. You cannot query a 3rd party API on every single page load, and you absolutely cannot have floating-point errors (where $19.99 becomes $19.989999999). 

**Your job:** Build the reliable conversion microservice that powers the storefront.

### Who Uses It

```
The Frontend:
├─ Needs to display $100 as Euros.
└─ Sends: GET /api/convert?from=USD&to=EUR&amount=100
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. The Cache & Fetch Logic

```pseudocode
function getExchangeRates(base_currency):
  // 1. Check local DB
  cache = database.query("SELECT * FROM exchange_rates_cache WHERE base_currency = ?", base_currency)
  
  // 2. Is it fresh? (Less than 1 hour old)
  if cache and (NOW() - cache.updated_at < 3600 seconds):
    return JSON.parse(cache.rates_json)
    
  // 3. Cache Miss / Stale Cache. Fetch from external API!
  try:
    response = http.get(`https://api.exchangerate-api.com/v4/latest/${base_currency}`)
    rates = response.rates
    
    // 4. Save to DB (UPSERT)
    database.execute(`
      INSERT INTO exchange_rates_cache (base_currency, rates_json, updated_at)
      VALUES (?, ?, CURRENT_TIMESTAMP)
      ON CONFLICT(base_currency) DO UPDATE SET
        rates_json = excluded.rates_json,
        updated_at = CURRENT_TIMESTAMP
    `, base_currency, JSON.stringify(rates))
    
    return rates
    
  catch error:
    // If the 3rd party is down, but we have STALE data, return the stale data!
    if cache: return JSON.parse(cache.rates_json)
    throw new Error("Currency API is down")
```

### 2. The Conversion Endpoint

```pseudocode
GET /api/convert:
  Step 1: Validate
    from = query.from
    to = query.to
    amount = parseFloat(query.amount)
    
    if isNaN(amount) or amount < 0: return 400 error
    if length(from) != 3 or length(to) != 3: return 400 error
    
  Step 2: Get Rates (Always using USD as our base to save money)
    rates = getExchangeRates("USD")
    
  Step 3: Perform Cross-Calculation
    // E.g. User wants EUR -> GBP
    // rates = { EUR: 0.85, GBP: 0.72 }
    
    if not rates[from] or not rates[to]:
      return 400 "Invalid currency"
      
    // Math: Convert 'from' to USD, then USD to 'to'
    amount_in_usd = new Decimal(amount).dividedBy(rates[from])
    final_amount = amount_in_usd.times(rates[to])
    
  Step 4: Format and Return
    // Round to 2 decimal places
    return 200 {
      query: { from, to, amount },
      result: final_amount.toFixed(2)
    }
```

---

## ✅ Before Submission

- [ ] Backend correctly validates that `amount` is a positive number.
- [ ] Backend fetches data from a 3rd-party provider (like ExchangeRate-API or Frankfurter).
- [ ] Backend CACHES the data for at least 1 hour (Subsequent requests are instant).
- [ ] Backend uses a Decimal library (or integer math) to prevent floating-point errors.
- [ ] Backend can convert between any two currencies using a single base cache (Cross-calculation).
- [ ] Code is on GitHub.

**Success:** A production-ready financial microservice!
