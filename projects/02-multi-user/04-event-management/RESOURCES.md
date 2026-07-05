# 🎟️ Event Management System: Learn By Building

**"Build a platform where organizers can create events, manage ticket sales, and attendees can browse and register for events."**

---

## 📚 Resources

**Concurrency & Race Conditions (CRITICAL):**
- What is a Race Condition? https://en.wikipedia.org/wiki/Race_condition#Computing
- ACID Transactions in SQL: https://www.databricks.com/glossary/acid-transactions
- Row-Level Locking (`SELECT ... FOR UPDATE`): https://www.postgresql.org/docs/current/explicit-locking.html#LOCKING-ROWS

**Security & Randomness:**
- Cryptographically Secure Pseudo-Random Number Generators (CSPRNG): https://nodejs.org/api/crypto.html#cryptorandombytessize-callback (Used for generating unguessable ticket QR codes).

**Database Constraints:**
- SQL CHECK Constraints: https://www.w3schools.com/sql/sql_check.asp (Essential for preventing `sold_count > capacity`).

**Real-World Inspiration:**
- Eventbrite API: https://www.eventbrite.com/platform/api
- Ticketmaster architecture case studies (handling high-demand flash sales).
---
