# ✂️ Salon Booking API: Learn By Building

**"Build a scheduling API for a salon where Customers book distinct Services (like Haircuts or Coloring) with specific Stylists, managing varying service durations and preventing overlap."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Exact Overlap

```
1. Create a 60-minute appointment from 10:00 to 11:00.
2. Attempt to book a 30-minute appointment from 10:15 to 10:45.
3. Expected: Server MUST reject it (409 Conflict).
```

### Scenario 2: The Partial Overlap (Edges)

```
1. Create a 60-minute appointment from 10:00 to 11:00.
2. Attempt to book a 30-minute appointment from 09:45 to 10:15.
   - Expected: Server MUST reject it. (Overlaps by 15 mins).
3. Attempt to book a 30-minute appointment from 10:45 to 11:15.
   - Expected: Server MUST reject it. (Overlaps by 15 mins).
```

### Scenario 3: The Boundary Test (Back-to-Back)

```
1. Create a 60-minute appointment from 10:00 to 11:00.
2. Attempt to book a 30-minute appointment from 09:30 to 10:00.
   - Expected: Server should ALLOW it. (One ends exactly as the next begins).
3. Attempt to book a 30-minute appointment from 11:00 to 11:30.
   - Expected: Server should ALLOW it.
```

### Scenario 4: Capability Validation

```
1. Assign Stylist Sarah to ONLY offer Service A.
2. Customer attempts to book Service B with Sarah.
3. Expected: Server MUST reject it with a 400 Bad Request.
```

---
