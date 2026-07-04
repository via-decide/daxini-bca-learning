## 🛠️ Debugging & Verification

**Test 1: Double Application**
- Apply to Job A.
- Send the exact same POST request again. The DB must reject it due to the unique constraint.

**Test 2: Employer Authorization**
- Employer A creates a Job.
- Employer B attempts to update the status of an application on Employer A's job. Must return `403 Forbidden`.
