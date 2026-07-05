# Live Notification System

## 🏗️ Architecture: Design Before Coding

**The Problem:**
A user needs to know immediately when someone likes their post, comments on their photo, or sends them a friend request, regardless of what page they are on.

**The Solution:**
A Pub/Sub (Publish/Subscribe) model over Server-Sent Events (SSE) or WebSockets. Since notifications are mostly one-way (Server -> Client), SSE is a lightweight and excellent choice.

**Database Architecture:**
```text
Users
├─ id
└─ name

Notifications
├─ id
├─ user_id (Recipient)
├─ actor_id (Who triggered it)
├─ type (ENUM: Like, Comment, Mention)
├─ entity_id (Post ID or Comment ID)
├─ is_read (BOOLEAN)
└─ created_at
```\n