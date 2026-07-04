# Currency Converter API: Learn By Building

**"Build a fast API that converts between currencies by aggregating live exchange rates and handling precise math operations securely."**

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
