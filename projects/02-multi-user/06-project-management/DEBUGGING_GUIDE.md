## 🛠️ Debugging & Verification

**Test 1: Cycle Detection**
- Create Task A, B, C.
- Make B depend on A.
- Make C depend on B.
- Try to make A depend on C. The API MUST return a `400 Bad Request: Cycle Detected`.

**Test 2: Status Blocking**
- Try to complete Task B while Task A is still "in_progress". Should return `403 Forbidden: Dependencies not met`.
