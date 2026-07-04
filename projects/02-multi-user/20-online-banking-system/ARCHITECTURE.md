# Online Banking System

## 🏗️ Architecture: Design Before Coding

**The Problem:**
User A transfers $100 to User B. The system deducts $100 from A. Then the server crashes. User B never gets the money. The money vanished.

**The Solution:**
Database ACID Transactions (`BEGIN`, `COMMIT`, `ROLLBACK`). Furthermore, never store balances as a static number. Use a Double-Entry Ledger (Credits and Debits) so every cent is accountable.

**Database Architecture:**
```text
Accounts
├─ id
├─ user_id
└─ balance (INT CENTS) -- Cached, but verifiable

Transactions
├─ id
├─ from_account_id (Nullable for Deposits)
├─ to_account_id (Nullable for Withdrawals)
├─ amount (INT CENTS)
└─ timestamp
```
