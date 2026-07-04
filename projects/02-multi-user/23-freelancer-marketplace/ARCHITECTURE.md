# Freelancer Marketplace (Upwork Clone)

## 🏗️ Architecture: Design Before Coding

**The Problem:**
A client posts a project. Freelancers bid on it. The client accepts a bid. The freelancer submits work. The client approves and pays.

**The Solution:**
A workflow-heavy schema. The `Projects` table has a status. The `Bids` table connects Freelancers to Projects. A `Milestones` table handles the escrow/payment steps.

**Database Architecture:**
```text
Projects
├─ id
├─ client_id
├─ title
├─ budget (DECIMAL)
└─ status (ENUM: Open, Awarded, Completed)

Bids
├─ id
├─ project_id
├─ freelancer_id
├─ amount (DECIMAL)
└─ is_accepted (BOOLEAN)

Milestones
├─ id
├─ project_id
├─ description
├─ amount (DECIMAL)
└─ status (ENUM: Funded, Released)
```
