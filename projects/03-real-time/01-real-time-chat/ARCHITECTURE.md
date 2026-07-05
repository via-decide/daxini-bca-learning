# Real-Time Chat App

## 🏗️ Architecture: Design Before Coding

**The Problem:**
Users need to send and receive messages instantly without refreshing the page. Traditional HTTP request-response cycles are too slow and inefficient for real-time communication because the client has to constantly poll the server for new messages.

**The Solution:**
Use WebSockets (via Socket.io or native WebSockets) to maintain a persistent, bidirectional connection between the client and server. 

**Database Architecture:**
```text
Users
├─ id
├─ username
└─ status (ENUM: Online, Offline)

Rooms
├─ id
├─ name
└─ created_at

Messages
├─ id
├─ room_id
├─ sender_id
├─ content (TEXT)
└─ sent_at (TIMESTAMP)
```\n