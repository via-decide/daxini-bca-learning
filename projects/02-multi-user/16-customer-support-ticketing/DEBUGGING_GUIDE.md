## 🛠️ Debugging & Verification

**Test 1: Internal Notes**
- Agent adds an `is_internal_note = true` comment.
- Fetch the ticket as the Customer. The API MUST filter out the internal note.

**Test 2: Status Auto-Updates**
- Customer replies to a "Pending" ticket. The system should auto-update the ticket status to "Open" so agents know it needs attention.
