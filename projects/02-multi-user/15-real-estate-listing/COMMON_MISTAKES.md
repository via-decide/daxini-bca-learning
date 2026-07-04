## ⚠️ Common Mistakes

❌ **Mistake 1: Downloading everything and filtering in code**
Running `SELECT * FROM properties`, downloading 10,000 houses into your Node.js server, and calculating the distance in a JavaScript `for` loop. Your server will crash out of memory. The Database must do the math and filtering.

❌ **Mistake 2: Missing the Primary Image Flag**
If you have 10 images for a house, the Search Results page only needs 1 thumbnail. If you don't track which image `is_primary`, you'll have to download all 10 images just to show the thumbnail.
