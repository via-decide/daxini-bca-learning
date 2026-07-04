## ⚠️ Common Mistakes

❌ **Mistake 1: Storing Comma-Separated Strings**
Storing tags as a string `"Vegan, Quick, Easy"` in the database. When someone searches for "Vegan", you have to do `LIKE '%Vegan%'`. This is slow, cannot be indexed, and matches "Non-Vegan".

❌ **Mistake 2: Over-normalizing Instructions**
Creating an `Instruction_Steps` table with columns `(id, recipe_id, step_number, instruction_text)`. It's technically pure SQL, but overkill. Since you never query "Find all recipes where step 3 is 'Boil water'", storing instructions as a JSON array is perfectly fine.
