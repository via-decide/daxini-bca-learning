## ⚠️ Common Mistakes

❌ **Mistake 1: Storing the GPA in the Students table**
If a professor changes a grade from C to B, and you stored the GPA in the `Students` table, you have to remember to update it. If you forget, the data is corrupted. Always calculate GPA dynamically on read, or use a materialized view.

❌ **Mistake 2: Forgetting the Semester in the Primary Key**
If your PK on Enrollments is just `(student_id, course_id)`, a student can never retake a class they failed.
