# 🔐 Password Strength Checker: Learn By Building

**"Build a stateless API that analyzes a given password and returns a score, a list of vulnerabilities, and estimated time to crack."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Wait, think about it... does a password strength checker *need* to store anything?

If a user submits `SuperSecret123!` to check its strength, should you save it to the database?
**NO! ABSOLUTELY NOT!** Saving raw passwords submitted by users is a massive security risk, even for a testing tool. If your database is compromised, you just leaked a bunch of passwords people might actually use.

This project is unique: **It is completely STATELESS.** There is no database.

### Step 2: The Logic Architecture (How to calculate "Strength")

**Question: How do you mathematically determine if a password is strong?**

**Bad Idea (Regex Only):**
```javascript
// Has 8 chars, 1 upper, 1 lower, 1 number, 1 symbol
const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
return regex.test(password);
```
*Why it's bad:* `Password1!` passes this regex and gets a "Strong" rating. But `Password1!` is literally the most commonly guessed password in the world and takes 0.001 seconds to crack.

**Good Idea (Entropy Calculation + Dictionary Matching):**
1. **Length & Character Set:** Calculate mathematical entropy (possibilities ^ length).
2. **Dictionary Attack:** Check if it contains common words ("password", "qwerty", "admin", "123456").
3. **Pattern Matching:** Detect sequences ("abcde", "654321").
4. **Data Breaches:** (Optional) Check if the password has already been compromised in a known data breach (e.g., using the HaveIBeenPwned API).

**Decision:** We will use the industry standard `zxcvbn` algorithm (developed by Dropbox) which implements all of the above to give a realistic score from 0-4.

---

### Step 3: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML)             │
│  ┌──────────────────────────────────────┐  │
│  │ Password Input Field                 │  │
│  │ Strength Meter (Red/Yellow/Green)    │  │
│  │ List of suggestions/feedback         │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP POST Request (JSON)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ API Layer                            │  │
│  │  - POST /api/check-strength          │  │
│  ├──────────────────────────────────────┤  │
│  │ Analysis Engine                      │  │
│  │  - Calculate Length/Complexity       │  │
│  │  - Run zxcvbn dictionary matching    │  │
│  │  - Calculate estimated crack time    │  │
│  │  - Check HaveIBeenPwned API (opt)    │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
         (NO DATABASE!)
```

---

### Step 4: The HIBP (HaveIBeenPwned) API Integration

If a password is mathematically strong (e.g., `CorrectHorseBatteryStaple`), but it was leaked in a database breach 5 years ago, it is completely insecure. Hackers will try it immediately.

**How to safely check a 3rd party API without leaking the password:**
1. Hash the password using SHA-1 on your backend.
   - Example: `password` -> `5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8`
2. Take ONLY the first 5 characters of the hash (`5baa6`).
3. Send those 5 characters to the HIBP API.
4. The API returns a list of *hundreds* of leaked password hashes that start with `5baa6`.
5. Your backend searches that list for the full hash. 
6. Result: You securely checked if a password was breached without *ever* sending the full password over the internet! This is called "k-Anonymity".
