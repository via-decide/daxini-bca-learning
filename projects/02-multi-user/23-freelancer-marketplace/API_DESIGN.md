## 🔌 API Design: Plan Before Coding

### 1. Accept Bid
**POST `/api/bids/:id/accept`**
- **Logic**: (Client Only). 
  1. `UPDATE bids SET is_accepted = true WHERE id = X`.
  2. `UPDATE projects SET status = 'awarded' WHERE id = bid.project_id`.

### 2. Place Bid
**POST `/api/projects/:id/bids`**
- **Logic**: 
  1. Check if `project.status == 'open'`. If not, reject.
  2. Insert into `bids`.
