## ⚠️ Common Mistakes

❌ **Mistake 1: Trusting the frontend end_time**
If the frontend sends both `start_time` and `end_time` in the JSON body, a malicious user could say they want a 120-minute Hair Coloring, but pass an `end_time` that is only 5 minutes after the `start_time`. Always calculate the `end_time` on the server using the master `Services` table.

❌ **Mistake 2: Bad Overlap Math**
If a haircut is 10:00 to 10:30, can someone book a beard trim starting at exactly 10:30? YES. Make sure your overlap logic uses `<` and `>`, not `<=` and `>=`, so adjoining appointments don't register as overlapping.
