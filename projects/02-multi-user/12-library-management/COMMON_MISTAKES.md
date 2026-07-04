## ⚠️ Common Mistakes

❌ **Mistake 1: Storing "available_copies" as a column on the Book**
If you have a column `available_copies` on the `Books` table and you update it every time someone borrows a book, it will eventually get out of sync with the actual `Borrowing_Records` table due to bugs. Always calculate availability dynamically: `total_copies - (count of active borrows)`.

❌ **Mistake 2: Missing Return Date Constraints**
Allowing a user to borrow a book they currently already have checked out. You must check if the user has an active, unreturned record for this specific `book_id` before issuing a new one.
