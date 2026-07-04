## 🛠️ Debugging & Verification

**Test 1: Pagination**
- Create 15 jobs.
- Request page 1 with limit 10. You should get 10 jobs.
- Request page 2 with limit 10. You should get 5 jobs.

**Test 2: Salary Overlap**
- Job pays 40k - 60k.
- User searches for `min_salary=50000`. The job SHOULD appear.
