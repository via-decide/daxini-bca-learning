## 🔌 API Design: Plan Before Coding

### 1. Cast Vote
**POST `/api/polls/:poll_id/vote`**
- **Body**: `{ "option_id": "123" }`
- **Logic**: Use a Transaction.
  1. `INSERT INTO user_votes` (If this fails due to Unique Constraint, abort! User already voted).
  2. `UPDATE poll_options SET vote_count = vote_count + 1 WHERE id = :option_id`.
