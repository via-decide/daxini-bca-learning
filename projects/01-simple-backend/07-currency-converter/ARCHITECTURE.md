# Currency Converter API: Learn By Building

**"Build a fast API that converts between currencies by aggregating live exchange rates and handling precise math operations securely."**

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
