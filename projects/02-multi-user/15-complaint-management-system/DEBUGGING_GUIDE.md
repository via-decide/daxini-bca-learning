## 🛠️ Debugging & Verification

**Test 1: The Audit Trail**
- Admin moves complaint from 'submitted' to 'in_progress'.
- Admin moves complaint from 'in_progress' to 'resolved'.
- Hit the GET `/api/complaints/:id/history` endpoint. It MUST return 2 distinct rows detailing the exact timestamps of those transitions.

**Test 2: RBAC Protection**
- Attempt to hit the status update endpoint using a JWT token belonging to a standard Citizen user. It MUST return `403 Forbidden`.
