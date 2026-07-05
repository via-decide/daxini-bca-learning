# Screen Sharing App

## 🏗️ Architecture: Design Before Coding

**The Problem:**
Routing massive amounts of raw video data (a 1080p screen share) through a centralized Node.js server will cost a fortune in bandwidth and introduce massive latency.

**The Solution:**
WebRTC (Web Real-Time Communication). The server only acts as a "Signaling Server" to help the two browsers find each other. Once connected, the video stream goes Peer-to-Peer (directly from Browser A to Browser B).

**Database Architecture:**
*(Very minimal, mostly for signaling state)*
```text
Rooms
├─ id
└─ active_host_id

-- Note: The actual video data is NEVER stored in the database.
```\n