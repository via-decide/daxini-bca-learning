# Customer Support Ticketing System (Zendesk Clone)

## 🏗️ Architecture: Design Before Coding

**The Problem:**
Customers submit tickets. Agents need to claim them, reply to them, and change statuses. An agent shouldn't accidentally reply to a ticket someone else is already handling.

**The Solution:**
A core `Tickets` table with status enums and an `assignee_id`. A separate `Ticket_Comments` table tracks the conversation history (both customer replies and agent replies). 

**Database Architecture:**
```text
Tickets
├─ id
├─ customer_id
├─ assignee_id (Agent)
├─ subject
├─ status (ENUM: Open, Pending, Resolved)
└─ priority (ENUM: Low, Medium, High)

Ticket_Comments
├─ id
├─ ticket_id
├─ user_id (Can be Customer OR Agent)
├─ message (TEXT)
└─ is_internal_note (BOOLEAN)
```
