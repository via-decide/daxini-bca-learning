## ⚠️ Common Mistakes

❌ **Mistake 1: Trusting the Frontend Timer**
If you write JavaScript `setTimeout(submitExam, 60000)` and trust it, a student can just open Chrome DevTools, type `clearTimeout()`, and take 5 hours to do the exam. Always validate time on the backend.

❌ **Mistake 2: Sending Correct Answers to the Client**
If the API payload for `/api/exams/:id/questions` includes the `correct_option` field, students will inspect the network tab and get 100%. Exclude the correct answer from the frontend entirely.
