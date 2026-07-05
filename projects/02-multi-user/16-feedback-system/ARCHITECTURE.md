# 🗣️ Customer Support Feedback System: Learn By Building

**"Build a multi-user API where Customers leave reviews for specific Support Agents, and Admins view aggregated performance scores to identify top employees."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. Customer Charlie is helped by Support Agent Alice.
2. Charlie is sent a link to rate Alice.
3. Charlie leaves a 5-star rating and a comment: "Very helpful!".
4. Admin Dave logs in at the end of the month to see who the highest-rated agent is.

**What data do you need for each?**

After thinking, here's the data model:

```
Table: Users (Admins, Agents, Customers)
├─ id (UUID)
├─ email (String)
├─ password_hash (String)
└─ role (Enum: 'admin', 'agent', 'customer')

Table: Support_Tickets
├─ id (UUID)
├─ customer_id (Foreign Key -> Users)
├─ agent_id (Foreign Key -> Users)
├─ issue_description (String)
└─ resolved_at (DateTime)

Table: Feedback_Reviews
├─ id (UUID)
├─ ticket_id (Foreign Key -> Support_Tickets - Ensures 1 review per ticket)
├─ customer_id (Foreign Key -> Users)
├─ agent_id (Foreign Key -> Users) -- Redundant, but makes querying MUCH faster
├─ rating (Integer: 1 to 5)
├─ comments (String)
└─ created_at (DateTime)
```

---

### Step 2: One-to-One Relationships (The Review Constraint)

**Question: How do you stop Charlie from leaving fifty 5-star reviews for the same support ticket to artificially boost Alice's score?**

**Bad Idea:** Fetch all reviews for that ticket into Node.js, count them, and if `length > 0`, return an error. (Subject to race conditions).

**Good Idea:** The Database handles it. A `Support_Ticket` can have a maximum of ONE `Feedback_Review`. This is a strict **1-to-1 relationship**. You enforce this by placing a `UNIQUE` constraint on the `ticket_id` column inside the `Feedback_Reviews` table.

---

### Step 3: Complex Aggregation (The Leaderboard)

When Admin Dave wants to see the best agents, he needs the average rating.

**Bad Idea:** Fetch all 10,000 reviews into Javascript, group them by agent in a massive object, and divide by the count.

**Good Idea:** Let SQL calculate the averages instantly.

```sql
SELECT 
  u.full_name as agent_name,
  AVG(f.rating) as average_rating,
  COUNT(f.id) as total_reviews
FROM feedback_reviews f
JOIN users u ON f.agent_id = u.id
GROUP BY f.agent_id
ORDER BY average_rating DESC;
```

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Customer Form (Star Rating)          │  │
│  │ Agent Dashboard (My Scores)          │  │
│  │ Admin Leaderboard (Rankings)         │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP requests with JWT (RBAC)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. RBAC Validation                   │  │
│  │ 2. 1-to-1 Booking Enforcement        │  │
│  │ 3. Analytics Engine (AVG/COUNT)      │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (PostgreSQL/MySQL)         │
│  - users, tickets, reviews tables          │
└────────────────────────────────────────────┘
```
