## 🛠️ Debugging & Verification

**Test 1: Late Submission**
- Start a 1-minute exam.
- Wait 2 minutes.
- Send the submit API request via Postman. Ensure it returns `403 Forbidden: Time expired`.

**Test 2: Double Submission**
- Submit the exam.
- Click submit again. Ensure it says "Exam already submitted."
