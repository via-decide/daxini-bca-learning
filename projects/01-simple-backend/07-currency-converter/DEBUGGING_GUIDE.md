# 💱 Currency Converter API: Learn By Building

**"Build a fast, precise API that converts between global currencies by fetching and caching live exchange rates."**

---

## 🧪 Testing Scenarios

### Scenario 1: Precision Test

```
1. Add a hardcoded rate to your cache: USD to FAKE = 1.05.
2. Request a conversion of 10.00 USD to FAKE.
3. Expected: Result should be exactly 10.50.
4. Request a conversion of 0.10 USD.
5. Expected: Result should be exactly 0.105 (or rounded to 0.11 depending on your spec). It MUST NOT be 0.10500000000000001.
```

### Scenario 2: Cache Hit vs Cache Miss

```
1. Request `/api/convert?from=USD&to=EUR&amount=10`
2. Expected: Response takes ~500ms (Cache Miss).
3. Check database: The `exchange_rates_cache` table has a new row.
4. Request `/api/convert?from=USD&to=EUR&amount=10` again.
5. Expected: Response takes ~10ms (Cache Hit).
```

### Scenario 3: Cross-Conversion Math

If you only cached base USD (e.g., USD->EUR = 0.85, USD->GBP = 0.72), and the user asks to convert 100 EUR to GBP...
```
1. Request `/api/convert?from=EUR&to=GBP&amount=100`
2. Expected: Result should be ~84.70.
3. Verify: The backend should mathematically calculate (100 / 0.85) * 0.72 = 84.70, without needing to make a new API request to fetch an EUR-based rate sheet.
```

### Scenario 4: Error Handling

```
1. Request `/api/convert?from=XXX&to=YYY&amount=100`
2. Expected: 400 Bad Request ("Invalid currency code").
3. Verify: The backend DOES NOT make a request to the 3rd party API for fake currencies.
```

---
