# Scaling Node modules without Memory Leaks


Scaling Node modules without Memory

Leaks

During continuous integration, our Node.js edge servers suffered from severe Out-of-Memory (OOM) crashes. An audit of the heap trace revealed that the syst...

◆

Engineering

◆

Systems

By

Dharam Daxini

· June 10, 2026

Read more at →

◆ daxini.xyz

During continuous integration, our Node.js edge servers suffered from severe Out-of-Memory (OOM) crashes. An audit of the heap trace revealed that the system was retaining thousands of duplicate module evaluations in RAM.

The culprit was a dynamic cache-busting query string appended to ES module imports: \

We resolved this by replacing dynamic imports with a version-controlled serverless routing mechanism. By standardizing paths and using clean reloads, we allowed V8 to garbage-collect unused modules, stabilizing RAM usage to a flat 55MB line.

Built using: LogicHub · Aporaksha · Daxini · Zayvora