# How to Shred Base64 Documents in Memory Safely


How to Shred Base64 Documents in Memory

Safely

In Node.js, simple garbage collection does not guarantee that sensitive data is cleared from RAM immediately. Strings can remain in memory long after their...

◆

Engineering

◆

Systems

By

Dharam Daxini

· July 18, 2026

Read more at →

◆ daxini.xyz

In Node.js, simple garbage collection does not guarantee that sensitive data is cleared from RAM immediately. Strings can remain in memory long after their references are deleted, posing a security risk.

To mitigate this, we process sensitive base64 documents inside isolated buffers. Once the analysis is complete, we fill the buffer with zero bytes, physically overwriting the sensitive data in RAM.

Overwriting buffers before releasing them ensures that sensitive document data cannot be leaked through memory dumps or process inspection, hardening our local application security.

Built using: LogicHub · Aporaksha · Daxini · Zayvora