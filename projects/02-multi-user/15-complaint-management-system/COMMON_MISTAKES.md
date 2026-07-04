## ⚠️ Common Mistakes

❌ **Mistake 1: Overwriting Status without a Ledger**
If a complaint sits at "In Progress" for 6 months, and you just have a single `current_status` column, the citizen has no idea *when* it was looked at. The `Complaint_History` table acts as a timeline (like FedEx package tracking) to provide transparency.

❌ **Mistake 2: Missing Admin Authentication**
If you don't enforce strict Role-Based Access Control (RBAC) on the `PUT /status` endpoint, any citizen can use Postman to mark their own complaints as "Resolved" or delete them.
