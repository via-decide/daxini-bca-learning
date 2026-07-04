# Password Strength Checker: Learn By Building

**"Build a security utility that evaluates password complexity, entropy, and checks against known data breaches."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Hashing Algorithms** - How SHA-1 and k-Anonymity are used to safely check passwords against breaches
✅ **Information Entropy** - Calculating the true mathematical strength of a password beyond just "add a symbol"
✅ **Regex (Regular Expressions)** - Writing robust patterns to validate character classes (uppercase, lowercase, numbers, symbols)
✅ **Third-Party API Integration** - Querying the Have I Been Pwned API securely
✅ **Stateless Architecture** - Building a pure utility API that doesn't need a database

---

## 📋 Project Overview

### The Problem
Users consistently choose terrible passwords like `Password123!`. Standard validation rules (must have 1 capital, 1 number) are no longer enough to stop modern password cracking tools. We need a system that checks for actual entropy, common dictionary words, and whether the password was already exposed in a massive data breach.

### Who Uses It
```
End User:
├─ Types a potential password into the UI
└─ Sees real-time feedback: "Weak: Too common" or "Strong: 85/100"

Authentication System (Backend):
├─ Calls this API during user registration
└─ Rejects signups if the password score is below 50
```

### The Big Picture

```text
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  User Input  │ ──> │ Backend API  │ ──> │ Entropy Math │
│ ("P@ssw0rd") │     │ (Controller) │     │ (zxcvbn lib) │
└──────────────┘     └──────┬───────┘     └──────────────┘
                            │
                            V
                     ┌──────────────┐
                     │ Have I Been  │
                     │ Pwned API    │
                     └──────────────┘
```

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data

**Question: What information must the system store?**
- Do we want to store the passwords users are checking? Absolutely NOT. That's a massive security risk.
- Do we need a database? No! This is a "Stateless" API. It takes an input, processes it, returns an output, and immediately forgets it.

**After thinking, here's the data model:**
- No database tables required.
- We will rely entirely on pure functions and external API calls.

### Step 2: Architecture Diagram

```text
1. Client POSTs password -> API Server
2. Server checks basic length/regex rules (Fast fail)
3. Server calculates Entropy Score (Dictionary check)
4. Server hashes password using SHA-1
5. Server sends first 5 characters of Hash to HIBP API (k-Anonymity)
6. HIBP API returns list of compromised hash suffixes
7. Server checks if full hash is in the compromised list
8. Server returns final combined score to Client
```

### Step 3: Data Flow
1. User enters `dragon123`.
2. Backend checks length: 9 chars (Passes minimum of 8).
3. Backend runs Entropy check: Dictionary word "dragon" detected. Score drops.
4. Backend hashes `dragon123` -> `935B5B5E14...`
5. Backend sends `935B5` to Have I Been Pwned.
6. HIBP says `935B5` has been seen in 400,000 breaches.
7. User sees a big red "COMPROMISED" warning.

---

## 🗄️ Database: Design, Don't Code

### Schema Design (Think Before SQL)

*No database required for this specific microservice!*

### Design Questions

1. **Why is it dangerous to send the raw password to the HIBP API?**
   If Have I Been Pwned is monitoring network traffic, or gets hacked, the attacker would see exactly what password your user is trying to set. 

2. **How does k-Anonymity solve this?**
   You hash the password using SHA-1. You only send the *first 5 characters* of the hash to the API. The API returns thousands of passwords that happen to start with those 5 characters. Your server then checks the list locally to see if your full hash is on it. The external API never knows which of the thousands of passwords you were actually checking.

---

## 🔌 API Design: Plan Before Coding

### Endpoint 1: Evaluate Password

**POST `/api/evaluate`**
- **Purpose**: Calculate strength and check for breaches.
- **Request**: `{ "password": "MySuperSecretPassword42!" }`
- **Response**: 
```json
{
  "score": 85,
  "feedback": {
    "warning": "",
    "suggestions": ["Add another word or two"]
  },
  "is_breached": false,
  "breach_count": 0,
  "time_to_crack": "3 centuries"
}
```

---

## 🧠 Implementation: Pseudocode First

```text
FUNCTION evaluate_password(raw_password):
    // 1. Basic Checks
    IF length(raw_password) < 8:
        RETURN { score: 0, warning: "Too short" }
        
    // 2. Entropy Check (using a library like zxcvbn)
    entropy_result = calculate_entropy(raw_password)
    
    // 3. k-Anonymity Breach Check
    full_hash = uppercase(sha1(raw_password))
    prefix = substring(full_hash, 0, 5)
    suffix = substring(full_hash, 5, end)
    
    // Call external API
    hibp_data = HTTP.GET("https://api.pwnedpasswords.com/range/" + prefix)
    
    // Check if our suffix is in the returned text
    breach_count = 0
    FOR EACH line IN hibp_data:
        IF line starts with suffix:
            breach_count = extract_count(line)
            BREAK
            
    // 4. Calculate Final Score
    final_score = entropy_result.score
    IF breach_count > 0:
        final_score = 0 // Automatically fail breached passwords
        
    RETURN {
        score: final_score,
        is_breached: breach_count > 0,
        breach_count: breach_count,
        time_to_crack: entropy_result.crack_times_display
    }
```

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Logging Passwords
**What's wrong:** Writing `console.log("Checking password: ", req.body.password)` in your server code.
**Why it's bad:** Your server logs are usually stored in plain text in services like Datadog or AWS CloudWatch. If you log passwords, anyone with access to the logs can steal them.
**How to fix:** Never log raw passwords, ever. 

### ❌ Mistake 2: Only Using Regex (Complexity vs Entropy)
**What's wrong:** Assuming `Tr0ub4dor&3` is a strong password because it has a capital, a number, and a symbol.
**Why it's bad:** It's a common pattern. An entropy checker knows this is easy to crack. `correct horse battery staple` has no numbers or symbols but has massive mathematical entropy because of its length.
**How to fix:** Combine basic regex rules with a real entropy library (like Dropbox's `zxcvbn`).

---

## 🧪 Testing: How to Verify

### Test 1: Breach Detection
- Submit `password123`.
- The API should instantly return `is_breached: true` with a massive `breach_count`.

### Test 2: High Entropy Detection
- Submit a 30-character random string `xKw9$2mPq!8vLz@4fJc#7nRtbYh5`.
- The API should return `is_breached: false` and a `score` of 100/100, with a `time_to_crack` in millions of years.

---

## 🛠️ Debugging: When Things Break

### Problem: HIBP API returns 400 Bad Request
**Root Cause:** You are sending the full SHA-1 hash instead of just the 5-character prefix. The k-Anonymity API strictly requires exactly 5 characters.
**Solution:** Ensure you are correctly slicing the hash string before making the external HTTP request.

---

## 📚 Resources

- **k-Anonymity & Passwords**: Troy Hunt's blog on Have I Been Pwned
- **Entropy Library**: zxcvbn (Available for Node, Python, etc.)
- **Hashing**: Crypto built-in modules for your language

---

## ✅ Before Submission

- [ ] Does the API successfully prevent breached passwords from passing?
- [ ] Is k-anonymity correctly implemented (only 5 chars sent)?
- [ ] Are you certain no passwords are being saved to a database or logged to the console?
- [ ] Does it correctly grade long passphrases as strong, even if they lack symbols?

---

**Build this and learn: Cryptography basics, stateless architecture, and modern authentication security.**
