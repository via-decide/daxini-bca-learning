# 💼 Freelancer Marketplace API: Learn By Building

**"Build a multi-user API where Clients post freelance jobs, Freelancers bid on those jobs, and Clients accept a bid to initiate a contract."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Double Acceptance Race Condition

```
1. Client Clara posts Project A.
2. Freelancer Frank bids $450. (Bid ID 1)
3. Freelancer Fiona bids $300. (Bid ID 2)
4. Clara opens two instances of Postman.
5. She simultaneously sends `PUT /api/bids/1/accept` and `PUT /api/bids/2/accept`.
6. Expected: One request MUST succeed (200 OK). The other MUST fail (400 Bad Request or 409 Conflict) because the project's status changed from 'open' to 'in_progress' during the first transaction, preventing the second from completing. Only ONE bid can be accepted.
```

### Scenario 2: The Asymmetric Privacy Test

```
1. Frank bids on Project A.
2. Fiona bids on Project A.
3. Login as Frank.
4. Attempt to `GET /api/projects/A/bids`.
5. Expected: The server MUST return 403 Forbidden. Frank is not the client who owns Project A. He should not be able to see Fiona's bid.
```

### Scenario 3: Bidding on Closed Projects

```
1. Clara posts Project A.
2. Clara accepts Frank's bid (Project A is now 'in_progress').
3. Login as Fiona.
4. Attempt to `POST /api/projects/A/bids`.
5. Expected: The server MUST reject the bid (400 Bad Request) because the project is no longer 'open'.
```

### Scenario 4: The Multi-Row State Update

```
1. Clara posts Project A.
2. Bids arrive from Frank, Fiona, and Felix.
3. Clara accepts Frank's bid.
4. Check the Database `bids` table.
5. Expected: Frank's bid status is 'accepted'. Fiona's and Felix's bid statuses MUST automatically be updated to 'rejected'. (Your API should handle this cleanup inside the transaction).
```

---
