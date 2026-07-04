# Hospital Management System: Learn By Building

**"Build a multi-user system for managing patient records, doctor appointments, and hospital administration with strict access controls."**

---


## 🧪 Testing: How to Verify

### Test 1: Role Isolation
- Login as Patient A. Try to hit a Doctor-only endpoint (like adding a prescription). Ensure it returns `403 Forbidden`.
- Try to fetch Patient B's records. Ensure it returns `403 Forbidden`.

### Test 2: Double Booking Prevention
- Login as Patient A. Book Doctor X for Monday at 9 AM.
- Login as Patient B. Attempt to book Doctor X for Monday at 9 AM. Ensure it returns an error.

---


