## ⚠️ Common Mistakes

❌ **Mistake 1: Not Throttling Events**
If you emit a websocket event for every single `mousemove` pixel, you will send thousands of events per second. Use a throttle function (e.g., max 30 times a second) to batch coordinate updates.

❌ **Mistake 2: Raster over Vector**
Don't try to sync a base64 encoded PNG image of the canvas. You must sync the vector commands (e.g., "Draw line from x1,y1 to x2,y2 with color red").\n