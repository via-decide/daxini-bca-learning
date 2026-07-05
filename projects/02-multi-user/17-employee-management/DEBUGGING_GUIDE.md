# 🏢 Employee Management System (HRIS): Learn By Building

**"Build a multi-user API where Admins manage company departments, Managers oversee their assigned employees, and Employees can view the company directory."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Circular Dependency Setup

```
1. Login as Admin.
2. `POST /api/departments` to create "Engineering". (Success)
3. `POST /api/users` to create User "Alice" as a 'manager', passing `department_id: <Engineering ID>`. (Success)
4. `PUT /api/departments/<Engineering ID>` to set `manager_id = <Alice ID>`. (Success)
5. Verify: Alice's department_id points to Engineering, and Engineering's manager_id points to Alice.
```

### Scenario 2: Manager Scope Restriction

```
1. Manager Alice is the manager of "Engineering".
2. Employee Bob works in "Sales".
3. Alice attempts to `PUT /api/users/<Bob ID>/title` to change his title.
4. Expected: Server MUST reject it (403 Forbidden). Alice's `department_id` does not match Bob's `department_id`.
```

### Scenario 3: Manager Self-Scope

```
1. Manager Alice works in "Engineering".
2. Alice attempts to `PUT /api/users/<Alice ID>/title` to change her own title to "Supreme Overlord".
3. Expected: Server MUST reject it (403 Forbidden). Even though Alice is in Engineering, managers usually shouldn't be able to change their own titles (only Admins can). If your business logic allows it, that's fine, but it should be a conscious choice.
```

### Scenario 4: The Directory Search (LIKE Query)

```
1. Create employees: "John Smith", "Jane Doe", "Smithsonian Johnson".
2. Employee calls `GET /api/directory?name=Smith`.
3. Expected: Should return "John Smith" and "Smithsonian Johnson". Ensure you are using `%Smith%` in your SQL `LIKE` clause.
```

---
