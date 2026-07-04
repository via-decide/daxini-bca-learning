## 🛠️ Debugging & Verification

**Test 1: Insufficient Funds**
- Try to transfer $200 from an account with $100. Should return `400 Bad Request`.

**Test 2: Concurrency Bomb**
- Write a script to hit the transfer endpoint 10 times concurrently, trying to transfer $10 from an account with $50.
- Check the final balance. It MUST be $0, and exactly 5 transactions should have succeeded, and 5 should have failed.
