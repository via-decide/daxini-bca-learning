# 🔐 Password Strength Checker: Learn By Building

**"Build a stateless API that analyzes a given password and returns a score, a list of vulnerabilities, and estimated time to crack."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Validating only with Regex

**Wrong:**
```javascript
// Validates that it has 1 upper, 1 lower, 1 number, 1 special char, 8+ length
const isValid = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/.test(password);

if (isValid) {
  return res.json({ score: 4, message: "Strong Password" });
}
```
*Why it's bad:* Hackers know these rules too. `Tr0ub4dor&3` passes this test, but is easily cracked. Meanwhile, `correct horse battery staple` fails this test (no numbers/symbols) despite being mathematically impossible to crack in our lifetimes.

**Right:**
Use an entropy-based library like `zxcvbn`. It calculates how many guesses a computer would need to crack it, which is the only true measure of strength.

### ❌ Mistake 2: Leaking Passwords to the HIBP API

**Wrong:**
```javascript
// Checking HaveIBeenPwned API by sending the whole password (or full hash)
const hash = sha1(password);
const response = await fetch(`https://api.pwnedpasswords.com/pwnedpassword/${hash}`);
```
*Why it's bad:* If you send the full hash, you are telling the API provider exactly what your user's password hash is. You broke their privacy.

**Right (k-Anonymity):**
```javascript
const hash = sha1(password).toUpperCase();
const prefix = hash.substring(0, 5); // "5BAA6"
const suffix = hash.substring(5);    // "1E4C9..."

// Send ONLY the first 5 characters
const response = await fetch(`https://api.pwnedpasswords.com/range/${prefix}`);
const text = await response.text();

// The API returns ~500 hashes that start with "5BAA6". 
// You check if YOUR suffix is in that list LOCALLY.
const isBreached = text.includes(suffix);
```

### ❌ Mistake 3: Storing Passwords in Database or Logs

**Wrong:**
```javascript
app.post('/api/check-strength', (req, res) => {
  // Logging the request body to the terminal for debugging
  console.log("Checking password for:", req.body.password);
  
  // Saving analytics
  db.insert("analytics", { p: req.body.password, ip: req.ip });
});
```
*Why it's bad:* Server logs are often sent to third-party tools (like Datadog or AWS CloudWatch). You just leaked plaintext passwords to a third party.

**Right:**
NEVER log the password string.
```javascript
app.post('/api/check-strength', (req, res) => {
  console.log(`Checking password of length ${req.body.password.length}...`);
});
```

---
