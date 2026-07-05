# 📝 Notes API: Learn By Building

**"Build a robust API for a note-taking application (like Google Keep or Evernote) that allows users to create, search, label, and securely store notes."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Tagging Workflow

```
1. Login and get JWT.
2. Create Note A ("Grocery List"). Note the ID.
3. Create Tag "Shopping". Note the ID.
4. Hit POST /api/notes/<note_a_id>/tags with `{"tag_id": "<shopping_tag_id>"}`.
5. Expected: Returns 200 OK.
6. Hit the same endpoint again (attach the same tag twice).
7. Expected: 409 Conflict ("Tag already attached"). The `PRIMARY KEY (note_id, tag_id)` constraint should throw a SQL error. Catch it!
```

### Scenario 2: Data Isolation (Tags)

```
1. User A creates a Tag named "Work". (ID: 100)
2. User B tries to attach Tag 100 to their own note.
3. Expected: 403 Forbidden or 404 Not Found.
4. Verify: Your `POST /api/notes/:id/tags` route MUST verify that User B actually owns the tag they are trying to attach.
```

### Scenario 3: Cascading Deletes

```
1. Create a Note, create a Tag, attach them.
2. Delete the Tag (`DELETE /api/tags/:id`).
3. Expected: Returns 200 OK.
4. Verify: Fetch the Note. The tag should disappear from the note's data! The `ON DELETE CASCADE` in the `note_tags` table handles this automatically.
```

### Scenario 4: The Complex `GET /api/notes` Response

```
1. Create 3 notes. Attach 2 tags to Note 1.
2. Fetch `GET /api/notes`.
3. Expected: The response for Note 1 should have a nested array `tags: [...]`.
4. Verify: Ensure you didn't accidentally return the Note 1 object twice in the JSON array (a common mistake when using SQL JOINs without proper data grouping).
```

---
