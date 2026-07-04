## 🔌 API Design: Plan Before Coding

### 1. Create Recipe
**POST `/api/recipes`**
- **Body**: `{ "title": "Pasta", "tags": ["Italian", "Dinner"], "instructions": ["Boil water", "Add pasta"] }`
- **Logic**: Insert the recipe. Then check if the tags exist in the `tags` table; insert them if they don't, then map them in `recipe_tags`.

### 2. Search by Tags
**GET `/api/recipes?tags=Vegan,Quick`**
- **Logic**: Join `recipes` to `recipe_tags` to `tags` and filter where the tag name matches the query.
