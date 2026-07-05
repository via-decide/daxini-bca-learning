## 🔌 API Design: Plan Before Coding

### 1. Signaling: Offer/Answer (WebSockets)
- **Host Emits:** `webrtc_offer(roomId, sdpOffer)`
- **Server:** Routes offer to Viewer.
- **Viewer Emits:** `webrtc_answer(roomId, sdpAnswer)`
- **Server:** Routes answer to Host.

### 2. ICE Candidate Exchange
- **Client Emits:** `ice_candidate(roomId, candidate)`
- **Server:** Routes candidate to the other peer so they can establish a direct connection through firewalls.\n