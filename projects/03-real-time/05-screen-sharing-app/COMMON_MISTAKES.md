## ⚠️ Common Mistakes

❌ **Mistake 1: Trying to send video through WebSockets**
Never read a video frame, turn it into base64, and send it through Socket.io. It is insanely slow and inefficient. You MUST use WebRTC for peer-to-peer media.

❌ **Mistake 2: Forgetting STUN/TURN servers**
WebRTC needs to know your public IP address to connect peers. If both users are behind corporate firewalls, a basic WebRTC setup will fail. You must configure Google's free STUN servers in your RTCPeerConnection config.\n