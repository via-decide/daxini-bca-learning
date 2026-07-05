## ⚠️ Common Mistakes

❌ **Mistake 1: Storing all messages in memory**
If you just push messages to an array in Node.js, they will disappear when the server restarts. Always persist messages to a database (PostgreSQL/MongoDB) before broadcasting them.

❌ **Mistake 2: Not handling disconnections**
If a user closes their laptop, the socket disconnects. If you don't listen for the `disconnect` event to update their status to 'offline', they will permanently look online.\n