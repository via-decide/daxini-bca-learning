# 💼 Freelancer Marketplace API: Learn By Building

**"Build a multi-user API where Clients post freelance jobs, Freelancers bid on those jobs, and Clients accept a bid to initiate a contract."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Atomic State Transitions** - Using the database `WHERE` clause as a concurrency lock to prevent double-booking a single resource.  
✅ **Cascading State Updates** - How to use a Transaction to update one record (the winning bid) while simultaneously updating multiple other records (rejecting the losing bids).  
✅ **Asymmetric Access Control** - Building endpoints where different roles have different visibility into the exact same dataset (Blind Bidding).

---

## 📋 Project Overview

### The Problem

A Freelancer Marketplace involves a 1-to-N-to-1 lifecycle. 
1 Client posts 1 Project.
N Freelancers submit N Bids.
1 Client accepts 1 Bid (and rejects N-1 Bids).

The primary technical challenge is the acceptance phase. You cannot allow a client to accept two bids for a project that only needs one person. You must build a transaction that locks the project, accepts the winner, and rejects the losers, all in one unbreakable motion.

**Your job:** Build an API that handles blind bidding safely, strictly enforces project ownership, and perfectly executes the contract initiation transaction.

### Who Uses It

```
Freelancer:
├─ GET /api/projects (Finds work)
└─ POST /api/projects/:id/bids (Submits a blind bid)

Client:
├─ POST /api/projects (Posts work)
├─ GET /api/projects/:id/bids (Reviews proposals)
└─ PUT /api/bids/:id/accept (Initiates the contract)
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. Asymmetric Visibility (Viewing Bids)

Only the Client who owns the project can see all the bids.

```pseudocode
GET /api/projects/:id/bids:
  middlewares: [authenticateUser, requireRole(['client'])]
  
  project_id = request.params.id
  
  // 1. Deep Ownership Check
  project = db.query("SELECT client_id FROM projects WHERE id = ?", project_id)
  
  if (!project || project.client_id !== req.user.id):
    return 403 "Forbidden. You do not own this project."
    
  // 2. Fetch the bids
  bids = db.query(`
    SELECT b.id, u.full_name as freelancer_name, b.amount, b.delivery_days, b.proposal_text
    FROM bids b
    JOIN users u ON b.freelancer_id = u.id
    WHERE b.project_id = ?
    ORDER BY b.amount ASC
  `, project_id)
  
  return 200 { bids: bids }
```

### 2. The Contract Initiation (The Heavy Transaction)

This is the most critical logic in the application.

```pseudocode
PUT /api/bids/:id/accept:
  middlewares: [authenticateUser, requireRole(['client'])]
  
  target_bid_id = request.params.id
  
  // 1. Look up the bid to find the project_id
  bid = db.query("SELECT project_id FROM bids WHERE id = ?", target_bid_id)
  if (!bid) return 404 "Bid not found"
  
  // 2. Start the atomic block
  db.execute("BEGIN TRANSACTION")
  
  try:
    // 3. Lock the Project (The most important line of code)
    // We only update if the client owns it AND it is currently open.
    result = db.query(`
      UPDATE projects 
      SET status = 'in_progress' 
      WHERE id = ? AND client_id = ? AND status = 'open'
    `, [bid.project_id, req.user.id])
    
    // If affectedRows is 0, someone already accepted a bid, OR the client doesn't own it.
    if result.affectedRows === 0:
      throw new Error("Project cannot be modified or you lack permission.")
      
    // 4. Accept the winning bid
    db.query(`
      UPDATE bids SET status = 'accepted' WHERE id = ?
    `, target_bid_id)
    
    // 5. Reject all other bids for this project
    db.query(`
      UPDATE bids SET status = 'rejected' WHERE project_id = ? AND id != ?
    `, [bid.project_id, target_bid_id])
    
    // 6. Success!
    db.execute("COMMIT")
    return 200 "Bid accepted and contract initiated."
    
  catch (error):
    db.execute("ROLLBACK")
    return 400 error.message
```

---

## ✅ Before Submission

- [ ] System handles `client` and `freelancer` roles securely.
- [ ] Freelancers cannot see bids submitted by other freelancers.
- [ ] Accepting a bid uses an atomic SQL `UPDATE` to prevent double-booking the project.
- [ ] Accepting a bid automatically rejects all other competing bids in the same transaction.
- [ ] Freelancers cannot submit multiple bids to the same project (Unique constraint).
- [ ] Code is on GitHub.

**Success:** You have built a robust two-sided marketplace transaction engine!
