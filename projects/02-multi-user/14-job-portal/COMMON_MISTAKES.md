## ⚠️ Common Mistakes

❌ **Mistake 1: Storing Files in the Database**
Storing PDF bytes in a `BLOB` column balloons your database size, makes backups take hours, and burns database memory. Files go on disk/S3. Databases only hold the file path.

❌ **Mistake 2: Missing Pagination**
If you just run `SELECT * FROM jobs` and return 5,000 rows to the frontend, the browser will freeze. Always implement `LIMIT` and `OFFSET`.
