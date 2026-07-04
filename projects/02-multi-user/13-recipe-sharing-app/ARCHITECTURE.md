# Recipe Sharing App

## 🏗️ Architecture: Design Before Coding

**The Problem:**
Recipes have complex data: a list of ingredients, a list of steps, and multiple tags (Vegan, Gluten-Free). How do we store lists efficiently so we can search "Find all recipes that use Garlic and are Vegan"?

**The Solution:**
Use PostgreSQL's native `JSONB` or `ARRAY` data types for things like instructions, and use a dedicated joining table (or array indexing) for Ingredients and Tags to allow fast searching.

**Database Architecture:**
```text
Recipes
├─ id
├─ title
├─ author_id
├─ instructions (JSONB or ARRAY)
└─ prep_time_mins (INT)

Tags
├─ id
└─ name (UNIQUE)

Recipe_Tags
├─ recipe_id
└─ tag_id
```
