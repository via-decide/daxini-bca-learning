## 🛠️ Debugging & Verification

**Test 1: Instant Badge Update**
- Keep the UI open. Trigger a notification via a cURL POST request to your backend. The red badge counter on the UI should increment instantly.

**Test 2: Read Status**
- Click a notification. The red dot should disappear, and a refresh should keep it disappeared (proving database persistence).\n