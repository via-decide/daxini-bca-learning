# 💼 Freelancer Marketplace API: Learn By Building

**"Build a multi-user API where Clients post freelance jobs, Freelancers bid on those jobs, and Clients accept a bid to initiate a contract."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. Client Clara signs up.
2. Clara posts a Project: "Build a website" with a budget of $500.
3. Freelancer Frank searches for "website" and finds Clara's project.
4. Frank submits a Bid: "I will do it for $450 in 3 days."
5. Freelancer Fiona submits a Bid: "I will do it for $300 in 7 days."
6. Clara reviews the bids and clicks "Accept" on Frank's bid.
7. The Project's status changes to "in_progress", and a Contract is formed with Frank. Fiona's bid is now irrelevant.

**What data do you need for each?**

After thinking, here's the data model:

```
Table: Users (Clients, Freelancers)
├─ id (UUID)
├─ email (String)
├─ password_hash (String)
└─ role (Enum: 'client', 'freelancer')

Table: Projects (The Job Posting)
├─ id (UUID)
├─ client_id (Foreign Key -> Users)
├─ title (String)
├─ description (String)
├─ budget (Decimal)
└─ status (Enum: 'open', 'in_progress', 'completed')

Table: Bids (The Proposals)
├─ id (UUID)
├─ project_id (Foreign Key -> Projects)
├─ freelancer_id (Foreign Key -> Users)
├─ amount (Decimal)
├─ delivery_days (Integer)
├─ proposal_text (String)
└─ status (Enum: 'pending', 'accepted', 'rejected')
```

---

### Step 2: Preventing Double Acceptance (The Transaction)

**Question: Clara has 10 bids on her project. She opens two tabs. In Tab 1, she accepts Frank's bid. In Tab 2, at the exact same millisecond, she accepts Fiona's bid. How do you prevent her from accidentally hiring two people for the same job?**

**Bad Idea:**
```javascript
const project = db.query("SELECT status FROM projects...");
if (project.status === 'open') { 
   db.query("UPDATE bids SET status = 'accepted'...");
   db.query("UPDATE projects SET status = 'in_progress'...");
}
```
If two requests hit the `SELECT` at the same time, they both see `'open'`. Clara just hired two people.

**Good Idea:**
Use a Database Transaction with an atomic state check on the `UPDATE` query itself.
```sql
-- Attempt to lock the project ONLY if it's currently open
UPDATE projects SET status = 'in_progress' WHERE id = ? AND status = 'open';
-- If the affectedRows is 0, someone else already accepted a bid! Rollback!
```

---

### Step 3: Authorization (Blind Bidding vs Open Bidding)

**Question: Can Fiona see Frank's bid?**

In most freelance platforms (like Upwork), freelancers cannot see each other's bids to prevent a race to the bottom.

**Rule:**
- Clients can see ALL bids for their own projects.
- Freelancers can ONLY see their own bids.
Your backend must enforce this strictly in the `GET /api/projects/:id/bids` route.

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Client Dashboard (Review Bids)       │  │
│  │ Freelancer Board (Search & Bid)      │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP requests with JWT (RBAC)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. Asymmetric Access Control (Bids)  │  │
│  │ 2. Idempotent Bid Submission         │  │
│  │ 3. Transactional Bid Acceptance      │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (PostgreSQL/MySQL)         │
│  - users, projects, bids tables            │
└────────────────────────────────────────────┘
```
