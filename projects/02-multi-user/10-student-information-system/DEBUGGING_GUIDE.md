## 🛠️ Debugging & Verification

**Test 1: GPA Calculation**
- Student gets an A (4.0) in a 4-credit course, and a C (2.0) in a 2-credit course.
- GPA = (16 + 4) / 6 = 3.33. Ensure the API returns exactly 3.33.

**Test 2: Double Enrollment**
- Try to enroll a student in CS101 for Fall 2024 twice. Should fail with a Constraint Error.
