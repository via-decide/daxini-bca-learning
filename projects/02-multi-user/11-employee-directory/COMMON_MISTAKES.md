## ⚠️ Common Mistakes

❌ **Mistake 1: Multiple Tables for Hierarchy**
Creating a `Managers` table and an `Employees` table. What happens when an Employee gets promoted to Manager? You have to move data between tables. What if a Manager also has a Manager? It breaks down. Always use self-referencing tables for hierarchies.

❌ **Mistake 2: Infinite Loops**
If Employee A is Employee B's manager, and you accidentally set Employee B as Employee A's manager, your recursive queries will run forever and crash the database.
