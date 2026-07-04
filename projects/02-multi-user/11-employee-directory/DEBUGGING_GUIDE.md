## 🛠️ Debugging & Verification

**Test 1: Self-Join**
- Insert CEO (id=1, manager=NULL).
- Insert VP (id=2, manager=1).
- Query VP. Ensure the response includes `{ "manager_name": "CEO" }`.

**Test 2: Cycle Prevention**
- Try to make the CEO report to the VP. The system should reject this to prevent circular reporting lines.
