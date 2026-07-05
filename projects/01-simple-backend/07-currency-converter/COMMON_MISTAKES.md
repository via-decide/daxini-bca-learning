# 💱 Currency Converter API: Learn By Building

**"Build a fast, precise API that converts between global currencies by fetching and caching live exchange rates."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Floating Point Math

**Wrong:**
```javascript
const converted = req.query.amount * rate;
res.json({ result: converted }); 
// Sometimes returns 10.500000000000004
```
*Why it's bad:* In a financial app, returning `.000004` cents breaks UI layouts, causes database strict-type errors, and makes accounting reconciliation fail.

**Right:**
Use a library like `decimal.js`.
```javascript
const Decimal = require('decimal.js');
const amount = new Decimal(req.query.amount);
const converted = amount.times(rate).toFixed(2); // Outputs exact string "10.50"
res.json({ result: parseFloat(converted) });
```

### ❌ Mistake 2: Missing Cross-Calculation Logic

**Wrong:**
```javascript
// User asks for EUR to GBP
const response = await fetch(`https://api.exchangeratesapi.io/latest?base=EUR`);
const rate = response.rates['GBP'];
```
*Why it's bad:* You are paying for a new API request every time someone picks a new "From" currency! If there are 170 currencies, you have to cache 170 different base rate sheets.

**Right:**
Always fetch and cache ONE base currency (e.g., USD). Use math to figure out the rest.
```javascript
// You have cached: USD->EUR (0.85) and USD->GBP (0.72)
// User wants EUR to GBP

const amountInUSD = amount / rate_EUR; 
const finalAmount = amountInUSD * rate_GBP;
```

### ❌ Mistake 3: Vulnerability to Query Param Injection

**Wrong:**
```javascript
const amount = req.query.amount;
const converted = amount * rate; 
```
*Why it's bad:* What if the user sends `?amount=hello` or `?amount=-500`? `hello * 0.85` is `NaN`. The API will crash or return garbage data.

**Right:**
```javascript
const amount = parseFloat(req.query.amount);
if (isNaN(amount) || amount <= 0) {
  return res.status(400).json({ error: "Amount must be a positive number" });
}
```

---
