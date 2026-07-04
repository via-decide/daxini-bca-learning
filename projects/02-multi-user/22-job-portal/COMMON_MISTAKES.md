## ⚠️ Common Mistakes

❌ **Mistake 1: Missing Authorization on Applications**
If your API lets anyone do `GET /api/applications/:id`, Applicant A can guess the ID and look at Applicant B's resume. You MUST check that `req.user.id == application.applicant_id` OR `req.user.id == company.owner_id`.

❌ **Mistake 2: Soft Deletes on Jobs**
If an employer deletes a Job, DO NOT `DELETE FROM jobs`. If you do, it will cascade and delete all the historical applications, ruining the job seeker's history. Use `is_active = false`.
