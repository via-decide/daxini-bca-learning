# Designing for 8GB RAM Base Tiers


Designing for 8GB RAM Base

Tiers

While the Mac Mini M4 has a base RAM of 16GB, many on-premise nodes operate on older 8GB hardware. To ensure Zayvora is accessible, we optimized the entire...

◆

Engineering

◆

Systems

By

Dharam Daxini

· June 14, 2026

Read more at →

◆ daxini.xyz

While the Mac Mini M4 has a base RAM of 16GB, many on-premise nodes operate on older 8GB hardware. To ensure Zayvora is accessible, we optimized the entire stack to run comfortably within a tight 8GB memory envelope.

First, we split the reasoning steps into sequential phases, unloading model weights from RAM between operations. We also configured SQLite with strict memory limits and optimized WAL mode to write to disk aggressively, preventing database cache bloat.

These optimizations keep our edge processes running at around 50MB of RAM each, leaving ample headroom for Ollama's local inference. Designing for hardware constraints ensures our software remains highly performant and accessible on consumer-grade machines.

Built using: LogicHub · Aporaksha · Daxini · Zayvora