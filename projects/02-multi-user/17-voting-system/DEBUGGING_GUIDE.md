## 🛠️ Debugging & Verification

**Test 1: Race Condition Test**
- Use a tool like Apache JMeter or write a script to fire 100 identical POST requests to the voting endpoint at the exact same time using the same Auth token.
- Check the database. `user_votes` should only have 1 row. `vote_count` should only be 1.
