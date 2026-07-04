## ⚠️ Common Mistakes

❌ **Mistake 1: The Read-Modify-Write Anti-Pattern**
```javascript
// BAD CODE:
let option = await db.getOption(id);
let newCount = option.vote_count + 1;
await db.updateOption(id, newCount);
```
If 100 people do this at the exact same millisecond, they will all read `vote_count = 5`, and all write `vote_count = 6`. You just lost 99 votes. Always use `SET vote_count = vote_count + 1` directly in SQL.

❌ **Mistake 2: Checking if user voted in code**
If you do `SELECT * FROM user_votes WHERE user = X`, check the length, and then `INSERT`, a user can fire two HTTP requests simultaneously, bypass the `SELECT` check, and vote twice. The database `PRIMARY KEY` must handle the enforcement.
