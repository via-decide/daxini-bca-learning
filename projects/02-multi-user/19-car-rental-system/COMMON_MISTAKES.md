## ⚠️ Common Mistakes

❌ **Mistake 1: Bad Overlap Logic**
Developers often try to write complex logic to check if dates overlap (checking if start falls between, or end falls between). 
The universal math for "Do Range 1 and Range 2 overlap?" is incredibly simple:
`(Start1 <= End2) AND (Start2 <= End1)`

❌ **Mistake 2: Not checking status**
If User A booked a car but then Cancelled it, that car IS available. Make sure your overlap queries only check for `status = 'confirmed'`.
