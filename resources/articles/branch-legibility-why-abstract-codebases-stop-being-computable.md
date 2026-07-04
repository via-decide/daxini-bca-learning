# Branch Legibility: Why Abstract Codebases Stop Being Computable


Branch Legibility: Why Abstract Codebases Stop Being

Computable

While testing the NEX Engineering Knowledge Index, I deployed an autonomous agent to refactor a deeply abstracted frontend architecture.

◆

Engineering

◆

Systems

By

Dharam Daxini

· June 22, 2026

Read more at →

◆ daxini.xyz

While testing the NEX Engineering Knowledge Index, I deployed an autonomous agent to refactor a deeply abstracted frontend architecture.

The agent was given full filesystem access and a massive context window. Yet, it failed completely. It couldn't figure out where a specific button was rendered because the architecture used six layers of component abstraction: \

The concrete problem: Abstraction creates logic branches that exist across physical file boundaries. Human engineers tolerate this by holding the architecture map in their heads.

The deeper the directory structure and the more abstracted the logic, the harder it is for any agent (human or AI) to compute the execution path.

To increase legibility, you must flatten the hierarchy and accept code duplication.

You cannot have deeply abstracted, perfectly DRY code that is also instantly computable by an external observer.

This tension between abstraction and legibility defines the lifecycle of all complex systems.

Enterprise Architecture:

Microservice architectures achieve isolated deployments but completely obscure the overall request flow. When a user clicks "Buy," the request bounces across 12 services. No single developer knows the entire path without looking at a distributed tracing dashboard like DataDog.

File System Compaction:

Organizing files into a deep taxonomy (e.g., \

Primary Pattern: The Graph Traversal Degradation

Definition:

The exponential increase in computation required to trace logic or relationships as architectural abstraction (branch depth) increases.

Architectural Statement:

The legibility of a system is inversely proportional to its level of abstraction. The more logic is modularized and scattered across a hierarchy, the more external indexing is required to make sense of the whole.

Constraints:

Flat code is highly legible but repetitive.

Abstracted code is DRY but illegible.

You cannot achieve perfect modularity without imposing a massive cognitive/computational tax on graph traversal.

Guarantees:

If you optimize for maximum abstraction (Deep Hierarchy):

• Code duplication is minimized ✓

• Individual components are simple ✓

• System-wide execution tracing is nearly impossible without tools ✗

• AI agents fail to navigate the context effectively ✗

If you optimize for maximum legibility (Flat Hierarchy):

• Execution paths are obvious and self-contained ✓

• AI agents can ingest entire flows easily ✓

• Code duplication increases significantly ✗

• Global refactors become tedious ✗

Failure Modes:

1.

The Shotgun Surgery

— Because logic is so abstracted, changing one core behavior requires modifying 15 different files across 4 directories.

2.

Context Window Exhaustion

— An AI attempting to trace a deeply nested component must load all 15 files into context, immediately blowing past token limits and losing focus.

3.

The Zombie Component

— Deeply nested files that are no longer used by the main application but are too abstract to safely delete because developers cannot compute the dependency graph.

Secondary Pattern: The Required Index

Definition:

The architectural inevitability that deeply abstracted systems eventually require a secondary, central index (like NEX or distributed tracing) just to remain usable.

In the NEX Engineering Knowledge Index, we had to solve this to make codebases accessible to autonomous agents.

Instead of forcing the agent to jump from file to file like a human developer, we introduced an indexing compilation step. The NEX engine pre-computes the dependency graph, analyzing ASTs (Abstract Syntax Trees) to flatten the abstraction.

When the agent asks, "Where is the checkout logic?", NEX does not return 12 nested files. It returns a flattened, synthesized trace of the execution path, stripping away the artificial boundaries of the folder structure.

The React Higher-Order Component Hell:

Early React architectures relied heavily on HOCs (\

What This Pattern Does Not Explain:

1.

Binary/Compiled Systems

— Compilers automatically flatten abstraction into highly legible (to the machine) machine code. This pattern applies to source code and human/agent interpretability.

2.

Security Abstractions

— Cryptographic layers or secure enclaves intentionally use abstraction to obscure logic and prevent unauthorized traversal.

The Graph Traversal Degradation problem leads to a controversial architectural mandate:

If AI agents execute better on flat, legible codebases, should we stop writing DRY code?

This leads directly to the exploration of "Agent-Optimized Codebases"—architectures designed not for human readability, but for LLM context window efficiency.

This leads to the next discovery:

Forcing Flat Hierarchies

.

For decades, software engineering has worshiped abstraction. We were taught that the pinnacle of design is a system where no logic is ever repeated and every function does exactly one thing.

But abstraction has a hidden cost: branch legibility. Every time you split a file into two, you sever the visual and contextual link between cause and effect. You force the observer to hold the architecture in their memory.

As we transition to agentic engineering, this cognitive tax becomes a computational failure. Agents cannot guess architecture; they must trace it. And in deeply abstract codebases, the trace is simply too long.