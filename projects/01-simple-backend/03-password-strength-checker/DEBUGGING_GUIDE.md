# 🔐 Password Strength Checker: Learn By Building

**"Build a stateless API that analyzes a given password and returns a score, a list of vulnerabilities, and estimated time to crack."**

---

## 🧪 Testing Scenarios

### Scenario 1: The "Complex" Weak Password

```
1. POST to /api/check-strength with `password = "Password123!"`
2. Expected: `score` should be 0, 1, or 2 (Weak). 
3. Expected: `metrics.has_uppercase` and `metrics.has_symbols` should be true.
4. Verify: The feedback should warn that this is a common dictionary word combined with predictable numbers.
```

### Scenario 2: The "Simple" Strong Password (Passphrase)

```
1. POST to /api/check-strength with `password = "correct horse battery staple"`
2. Expected: `score` should be 4 (Very Strong).
3. Expected: `metrics.has_symbols` is false, `metrics.has_numbers` is false.
4. Verify: It correctly identifies that length and randomness (entropy) beat special characters.
```

### Scenario 3: Checking Breaches (k-Anonymity)

```
1. POST to /api/check-strength with `password = "admin123"`
2. Expected: `is_breached` is true. `breach_count` should be in the millions.
3. Verify Network Tab: Ensure your backend is making an outbound request to `https://api.pwnedpasswords.com/range/{prefix}`, where `{prefix}` is the first 5 chars of the SHA-1 hash of "admin123".
```

### Scenario 4: User Information Leakage

```
1. POST to /api/check-strength with `password = "JohnDoe2026"` and `user_inputs = ["John", "Doe"]`
2. Expected: `score` drops significantly because it detects the user's name inside the password.
3. Verify: Feedback should mention "Avoid using names or emails in passwords".
```

---
