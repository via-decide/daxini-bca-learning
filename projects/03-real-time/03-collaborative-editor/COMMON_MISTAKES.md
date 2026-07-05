## ⚠️ Common Mistakes

❌ **Mistake 1: Saving to DB on every keystroke**
Writing to PostgreSQL every time someone hits the spacebar will crash your database. You must keep the hot state in memory (or Redis) and perform batched, periodic saves.

❌ **Mistake 2: Overwriting Full State**
If the payload is `{ content: "the entire document..." }`, the last person to type wins and erases everyone else. You must send diffs (deltas), e.g., "Insert 'X' at position 54".\n