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


## ✅ Before Submission

- [ ] Does the API successfully prevent breached passwords from passing?
- [ ] Is k-anonymity correctly implemented (only 5 chars sent)?
- [ ] Are you certain no passwords are being saved to a database or logged to the console?
- [ ] Does it correctly grade long passphrases as strong, even if they lack symbols?

---

**Build this and learn: Cryptography basics, stateless architecture, and modern authentication security.**
