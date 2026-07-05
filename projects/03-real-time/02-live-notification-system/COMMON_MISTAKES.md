## ⚠️ Common Mistakes

❌ **Mistake 1: Using WebSockets for purely one-way data**
WebSockets are bidirectional. If the client never needs to send real-time data back to the server, Server-Sent Events (SSE) are much easier to implement and use standard HTTP.

❌ **Mistake 2: N+1 Notification Queries**
Don't run a query to fetch the actor's profile picture for every single notification in a loop. Use a SQL `JOIN` to fetch the notification and the actor's details in one go.\n