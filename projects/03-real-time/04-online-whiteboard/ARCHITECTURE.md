# Online Whiteboard (Figma/Miro Clone)

## 🏗️ Architecture: Design Before Coding

**The Problem:**
Drawing on a canvas produces hundreds of mouse coordinates per second. Broadcasting all of them is bandwidth-heavy.

**The Solution:**
WebSocket broadcasting of SVG or Canvas drawing commands (paths, lines, shapes) rather than pixels. 

**Database Architecture:**
```text
Boards
├─ id
├─ name
└─ created_at

Board_Elements
├─ id
├─ board_id
├─ type (ENUM: Line, Rectangle, Text)
├─ properties (JSONB - e.g., color, x, y, width)
└─ z_index (INT)
```\n