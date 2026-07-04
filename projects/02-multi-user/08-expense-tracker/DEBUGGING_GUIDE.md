## 🛠️ Debugging & Verification

**Test 1: Budget Alert**
- Set Food budget to $100.
- Log $50 (No warning).
- Log $45 (Warning! Reached 95% of budget).
- Log $10 (Warning! Exceeded budget).

**Test 2: Precision**
- Log $10.01, $10.02, $10.03. Ensure the sum is exactly $30.06.
