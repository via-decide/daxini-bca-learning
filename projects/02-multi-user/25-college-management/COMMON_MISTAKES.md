## ⚠️ Common Mistakes

❌ **Mistake 1: Broken Access Control**
If a student grabs an `assignment_id` from a course they aren't enrolled in, and hits the Submit endpoint, your API must block them. Always join back to the `Enrollments` table to verify membership.

❌ **Mistake 2: Denormalizing Course ID**
Don't put `course_id` on the `Submissions` table. The `assignment_id` already points to the `Assignments` table, which points to the `Courses` table. Adding it to `Submissions` creates duplicate data paths that can get out of sync.
