## ⚠️ Common Mistakes

❌ **Mistake 1: Circular Dependencies**
Allowing User A to say "Task 1 depends on Task 2", and then "Task 2 depends on Task 1". Neither can ever be finished. You must write an algorithm (like DFS) to check for cycles before inserting a dependency.

❌ **Mistake 2: Soft Deleting Projects**
If a project is deleted, but you don't cascade the delete to Sprints and Tasks, your database will fill up with orphaned tasks that have no project.
