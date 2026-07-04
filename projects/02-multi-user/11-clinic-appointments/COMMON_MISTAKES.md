## ⚠️ Common Mistakes

❌ **Mistake 1: Relying on SELECT before INSERT to prevent double-booking**
If Patient A and Patient B hit the "Book" button at the exact same millisecond, they both run `SELECT count(*) FROM appointments WHERE time = '9:00'`. Both get 0. Both proceed to INSERT. Now the doctor has two patients at 9:00. The Database `UNIQUE` constraint is mandatory here.

❌ **Mistake 2: Timezone Confusion**
A patient in India books a remote doctor in London for 10:00 AM. Who's 10:00 AM? Always pass times from frontend to backend in UTC format (`2024-10-10T10:00:00Z`), and store it as UTC in the DB.
