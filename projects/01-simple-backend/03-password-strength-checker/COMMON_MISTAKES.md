# Password Strength Checker: Learn By Building

**"Build a security utility that evaluates password complexity, entropy, and checks against known data breaches."**

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
