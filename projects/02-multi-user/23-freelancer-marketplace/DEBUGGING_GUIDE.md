## 🛠️ Debugging & Verification

**Test 1: Closed Project Bidding**
- Client accepts Bid A (Project status -> Awarded).
- Freelancer B attempts to submit a bid on the project. Must return `400 Bad Request: Project no longer open`.

**Test 2: Escrow Release**
- Ensure that releasing a milestone creates a corresponding ledger entry in your global `Transactions` table (moving money from Platform Escrow to Freelancer Balance).
