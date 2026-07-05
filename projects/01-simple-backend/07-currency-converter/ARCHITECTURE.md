# 💱 Currency Converter API: Learn By Building

**"Build a fast, precise API that converts between global currencies by fetching and caching live exchange rates."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. User wants to convert 100 USD to EUR.
2. Your backend checks its database for the current USD to EUR rate (e.g., 0.85).
3. Your backend returns 85.00 EUR.
4. An hour later, the exchange rate changes on the global market.
5. Your backend needs to update its database to the new rate (0.86).

**What data do you need for each?**

After thinking, here's the data model:

```
Exchange_Rates (The Core Cache)
├─ base_currency (e.g., "USD" - Primary Key)
├─ rates (JSON object containing all conversion rates)
└─ updated_at (Timestamp)

Conversion_History (Optional: For analytics)
├─ id (UUID)
├─ from_currency
├─ to_currency
├─ amount
├─ result
├─ ip_address (Optional)
└─ created_at
```

---

### Step 2: The Precision Problem (Floating Point Math)

**Question: How do you store and calculate money?**

**Bad Idea (Floating Point Math):**
```javascript
const amount = 0.1;
const rate = 0.2;
console.log(amount + rate); // Output: 0.30000000000000004
```
*Why it's bad:* Computers cannot accurately represent decimal fractions in binary. If you use floating-point numbers (`float` or `double`) for currency, you will slowly lose or gain pennies, which is illegal in financial systems.

**Good Idea (Integers or specialized Decimal types):**
```javascript
// Method 1: Convert everything to the smallest unit (e.g. cents)
const amountInCents = 10; // $0.10
const rateMultiplier = 2; // 0.2 * 10 (needs careful handling for exchange rates)

// Method 2 (Better for APIs): Use strings and a specialized math library like `decimal.js` or `currency.js`
const Decimal = require('decimal.js');
const amount = new Decimal('0.1');
const rate = new Decimal('0.2');
console.log(amount.plus(rate).toString()); // Output: '0.3'
```

**Decision:** The backend MUST use a decimal math library, and the API should accept and return amounts as exact Numbers (rounded to 2 or 4 decimal places) or Strings to prevent frontend floating-point errors.

---

### Step 3: The Caching Strategy (Why not fetch live every time?)

If a user converts USD to EUR, and you call the 3rd-party Exchange Rate API every time:
1. It is slow (500ms delay).
2. You will hit the 3rd-party API rate limit (e.g. 1000 requests/month free tier) in one day.

**The Solution:**
Fetch the rates for a base currency (like USD) once, save it to your database, and use that cached data for all users for the next 60 minutes.

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Amount Input Field                   │  │
│  │ "From" Dropdown (USD)                │  │
│  │ "To" Dropdown (EUR)                  │  │
│  │ Result Display                       │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP GET /api/convert?from=USD&to=EUR&amount=100
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. Validate Input (Are currencies    │  │
│  │    valid 3-letter ISO codes?)        │  │
│  │ 2. Check Cache for Base Currency     │  │
│  │ 3. If Cache is stale (> 1 hour):     │  │
│  │    Fetch from 3rd Party API & Save   │  │
│  │ 4. Perform Exact Math (Decimal.js)   │  │
│  │ 5. Return JSON to Frontend           │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (SQLite/PostgreSQL)        │
│  - Stores the cached rates                 │
└────────────────────────────────────────────┘
```
