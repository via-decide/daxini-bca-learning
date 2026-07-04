## 🛠️ Debugging & Verification

**Test 1: Check Constraints**
- Send a POST request with `rating: 6`. DB should throw a Constraint Violation.
- Send a POST request with `rating: -1`. DB should throw a Constraint Violation.

**Test 2: Math Verification**
- Give an entity a 5 star review. Average = 5.0.
- Give it a 1 star review. Average MUST accurately compute to 3.0.
