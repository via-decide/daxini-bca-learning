## 🛠️ Debugging & Verification

**Test 1: Haversine Math**
- Insert Property A exactly 5km away.
- Insert Property B exactly 15km away.
- Search with radius 10km. Only Property A should return.

**Test 2: Image Joins**
- Ensure the GET Property API returns the images as an array: `images: ["url1", "url2"]`, rather than returning duplicate property rows.
