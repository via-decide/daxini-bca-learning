## ⚠️ Common Mistakes

❌ **Mistake 1: Not bounding the rating**
If the UI shows 5 stars, but the API accepts a JSON payload of `{ "rating": 9000 }`, a malicious user can ruin the average score instantly. Always use a `CHECK` constraint in the database.

❌ **Mistake 2: Ranking without minimums**
If Entity A has one 5-star review, and Entity B has ten thousand 4.9-star reviews, Entity A will show up as the "Best Rated". You must add a minimum review threshold (`WHERE total_reviews > 10`) when building leaderboards.
