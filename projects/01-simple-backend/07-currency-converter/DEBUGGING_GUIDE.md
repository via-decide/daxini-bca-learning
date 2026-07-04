# Currency Converter API: Learn By Building

**"Build a fast API that converts between currencies by aggregating live exchange rates and handling precise math operations securely."**

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
