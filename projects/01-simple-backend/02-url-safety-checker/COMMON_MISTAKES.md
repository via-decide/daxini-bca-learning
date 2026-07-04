# URL Safety Checker: Learn By Building

**"Build a security tool that scans URLs for phishing, malware, and malicious redirects."**

---


## ⚠️ Common Mistakes

### ❌ Mistake 1: Not Validating the URL First
**What's wrong:** Passing user input directly to the external API without checking if it's a real URL.
**Why it's bad:** Attackers can send malformed strings or SQL injection payloads. The external API will throw errors, or worse, your app crashes.
**How to fix:** Always run the input through a strict URL parser (like Node's `new URL(input)`) before doing anything else.

### ❌ Mistake 2: Missing Timeout Handling
**What's wrong:** Waiting indefinitely for the Google API to respond.
**Why it's bad:** If the external API goes down, your server keeps connections open waiting for a response until it runs out of memory and crashes.
**How to fix:** Set a strict timeout (e.g., 3000ms) on external HTTP requests.

---
