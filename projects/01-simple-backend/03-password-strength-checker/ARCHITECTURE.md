# Password Strength Checker: Learn By Building

**"Build a security utility that evaluates password complexity, entropy, and checks against known data breaches."**

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
