# 🔐 Password Strength Checker: Learn By Building

**"Build a stateless API that analyzes a given password and returns a score, a list of vulnerabilities, and estimated time to crack."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Cryptographic Hashing** - Using SHA-1 to securely hash data one-way.  
✅ **k-Anonymity** - How to check data against a massive database (HIBP) without revealing the data itself.  
✅ **Password Entropy** - Why "Tr0ub4dor&3" is weak and "correct horse battery staple" is strong.  
✅ **Stateless APIs** - Building an API that doesn't rely on a database, scaling infinitely.  
✅ **Privacy by Design** - Learning to explicitly NOT log or store sensitive data.

---

## 📋 Project Overview

### The Problem

Many websites force users to create passwords like "1 Capital, 1 Number, 1 Symbol". This results in everyone creating passwords like `Password123!`. These are mathematically weak because they are completely predictable. We need a modern checker that calculates the actual time a computer would take to guess it.

**Your job:** Build the logic engine that evaluates true password strength.

### Who Uses It

```
The Frontend UI:
├─ User types "P" -> Gets score 0 (Weak)
├─ User types "Pa" -> Gets score 0
├─ User types "Password123" -> Gets score 1 (Warning: Dictionary word)
└─ User types "MyDogAteMyHomework" -> Gets score 4 (Strong)
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. The Core API

```pseudocode
POST /api/check-strength(password, user_inputs):
  Step 1: Validate
    if password is empty or length > 100:
      return 400 Bad Request
      
  Step 2: Basic Metrics
    metrics = {
      length: password.length,
      has_upper: containsUpperCase(password),
      has_lower: containsLowerCase(password),
      has_numbers: containsNumbers(password),
      has_symbols: containsSymbols(password)
    }
    
  Step 3: Analyze Entropy (Using zxcvbn)
    // Pass the password and any known data (like their email) so the 
    // algorithm can penalize them if they use their name as the password.
    analysis = zxcvbn(password, user_inputs)
    
  Step 4: Check HaveIBeenPwned (k-Anonymity)
    is_breached, breach_count = await checkHIBP(password)
    
    // Penalize the score if it's breached, regardless of math strength!
    if is_breached:
      analysis.score = 0
      analysis.feedback.warning = "This password has been leaked in a data breach!"
      
  Step 5: Return result
    return {
      score: analysis.score,
      crack_time: analysis.crack_times_display.offline_fast_hashing_1e10_per_second,
      feedback: analysis.feedback,
      metrics: metrics,
      is_breached: is_breached
    }
```

### 2. The HIBP k-Anonymity Check

```javascript
async function checkHIBP(password) {
  // 1. Hash with SHA-1
  const hash = crypto.createHash('sha1').update(password).digest('hex').toUpperCase();
  
  // 2. Split into Prefix (5 chars) and Suffix (the rest)
  const prefix = hash.slice(0, 5);
  const suffix = hash.slice(5);
  
  // 3. Request the range
  const response = await fetch(`https://api.pwnedpasswords.com/range/${prefix}`);
  const text = await response.text();
  
  // 'text' looks like:
  // 1E4C9B93F3F0682250B6CF8331B7EE68FD8:12345
  // 1E4C9B93F3F0682250B6CF8331B7EE68FD9:1
  
  // 4. Check if our suffix is in the returned list
  const lines = text.split('\n');
  for (const line of lines) {
    const [lineSuffix, count] = line.split(':');
    if (lineSuffix === suffix) {
      return { is_breached: true, breach_count: parseInt(count, 10) };
    }
  }
  
  return { is_breached: false, breach_count: 0 };
}
```

---

## ✅ Before Submission

- [ ] API accepts a password and returns a score from 0-4.
- [ ] Uses the `zxcvbn` algorithm (or similar) instead of just regular expressions.
- [ ] Securely implements the HaveIBeenPwned API using k-Anonymity (only sends first 5 chars of hash).
- [ ] The backend has ZERO database connections (Stateless).
- [ ] No `console.log` statements output the raw password to the terminal.
- [ ] Code is on GitHub.

**Success:** A production-ready microservice that could be integrated into any signup form in the world to enforce better security.
