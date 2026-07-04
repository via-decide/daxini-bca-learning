## ⚠️ Common Mistakes

❌ **Mistake 1: Over-normalizing document data**
If you make a table for `Resume_Bullet_Points`, you have gone too far. If you don't need to write a query like `SELECT * FROM bullet_points WHERE text LIKE '%Javascript%'`, it shouldn't be its own table. JSONB is perfect here.

❌ **Mistake 2: Blocking the API with PDF Generation**
Generating a PDF with Puppeteer takes 1-3 seconds and uses a lot of RAM. If 50 users click "Export" at the same time, your server will crash. For a production app, PDF generation should be sent to a background worker queue (like Redis/BullMQ).
