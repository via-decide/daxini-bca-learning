# 👔 Project Management System: Learn By Building

**"Build a multi-user project board (like Jira or Trello) where Managers create projects, Assignees move tasks across columns, and Watchers receive updates, requiring complex multi-table relationships."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Cascading Delete

```
1. Create a Project (ID: 1)
2. Create a Ticket (ID: A) inside Project 1.
3. Create a Comment (ID: X) on Ticket A.
4. Verify all three exist in the database.
5. DELETE Project 1 (`/api/projects/1`).
6. Query the database for Ticket A. Expected: It MUST NOT exist.
7. Query the database for Comment X. Expected: It MUST NOT exist.
```
*(If the ticket or comment still exists, your `ON DELETE CASCADE` is broken, and you have corrupted your database).*

### Scenario 2: Data Transformation for the Frontend

```
1. Create a Project.
2. Add 3 tickets with status 'to_do'.
3. Add 1 ticket with status 'done'.
4. GET `/api/projects/:id`.
5. Expected: The response JSON should be grouped perfectly into columns (e.g., `tickets: { to_do: [...], in_progress: [], review: [], done: [...] }`).
6. Verify: If the API just returns a flat array of 4 tickets, the frontend developer has to do extra work. A good API shapes data for its consumer.
```

### Scenario 3: Access Control (Who owns what?)

```
1. User A creates Project 1.
2. Login as User B. Get JWT.
3. User B attempts to DELETE Project 1 (`/api/projects/1`).
4. Expected: Server MUST reject with 403 Forbidden.
5. User B attempts to add a Ticket to Project 1.
6. Expected: Server should ALLOW it (if you design projects to be open to any logged-in user) OR REJECT it (if you implemented strict project-member lists). Choose one and test it!
```

### Scenario 4: The State Machine Constraint

```
1. PUT to update a ticket status to "super_done".
2. Expected: Server MUST reject it. (Your DB `CHECK` constraint and API validation should both block this).
```

---
