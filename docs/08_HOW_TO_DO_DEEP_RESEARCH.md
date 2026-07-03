# 🔍 The VIA-Decide Methodology: How to Do Deep Research

Most students approach a project like this: they Google a tutorial, copy-paste the code, get it running on `localhost`, and call it a day. 

**That is not how you become a senior engineer or a founder.**

To truly master software engineering, you must understand the *"Why"* and the *"System"* before you ever write the *"How"*. Here is the exact research methodology used by Dharam Daxini and the VIA-Decide team to build robust, scalable, and sovereign systems.

---

## 🧠 Phase 1: The "Why" (Business & Competitor Analysis)
Before you write a single line of code, you must understand why this software needs to exist. Software solves human problems.

**The Strategy:**
1. **Find the Top 3 Live Products:** If you are building a URL Shortener, look at Bitly, TinyURL, and Rebrandly. If you are building Gym Software, look at Mindbody and Zen Planner.
2. **Deconstruct Them:** Analyze them across these specific dimensions:
   - **UI / UX:** Is it clunky? Is it mobile-first?
   - **Code & Infra:** Are they using Single Page Apps (React)? Are they relying on edge-caching?
   - **Scale:** How do they handle 1 million users?
   - **Revenue Mechanism:** How do they actually make money? (Freemium, Subscriptions, Ads?)
   - **Auth Level:** Do they use OAuth (Google/GitHub login) or standard JWT?

*If you don't know how the giants make money and scale, you are just building a toy.*

---

## ⚖️ Phase 2: The "Rules" (Legal & Compliance)
Code does not exist in a vacuum. It exists in the real world with real laws.

**The Strategy:**
For every project, ask yourself:
- **Data Privacy:** Am I storing user emails, passwords, or phone numbers? If yes, you must understand basic privacy laws (like the DPDP Act in India or GDPR). How are you encrypting passwords (bcrypt)?
- **Payments:** If the app takes money, you cannot just store credit cards in a text file. You must use PCI-compliant gateways (Razorpay, Stripe) and understand RBI guidelines on recurring payments.
- **Terms & Conditions:** What happens if someone uses your URL Shortener to link to illegal content? You need an acceptable use policy.

---

## 🗺️ Phase 3: The "Map" (Architecture & Visual Thinking)
Never code blind. The VIA-Decide methodology relies heavily on visual mapping before touching the IDE.

**The Strategy:**
1. **Think in Neural Networks (3-Layer Architecture):** 
   - **Input Layer:** Where does the data come from? (User typing in a form, an IoT sensor in a gym).
   - **Hidden/Processing Layer:** What happens to the data? (Validation, API logic, background queues like Celery).
   - **Outcome Layer:** Where does it go? (Saved to PostgreSQL, sent as an email, returned as a dashboard graph).
2. **Use Mermaid.js:** Write your diagrams in plain text using Mermaid.
   - Draw **System Architecture** flowcharts.
   - Draw **ER Diagrams** (Entity-Relationship) so you know exactly how your database tables connect.
   - Draw **Sequence Diagrams** to map out complex flows (like a user logging in and getting a JWT token).

---

## 🤖 Phase 4: The "Tech" (Stack & AI Selection)
Now that you know what you are building, you research *how* to build it.

**The Strategy:**
- Use the **Right AI Model** (See our [AI Guide](./07_HOW_TO_CHOOSE_AN_AI_MODEL.md)). Feed Claude or GPT-4 your Mermaid diagrams and ask: *"What are the edge cases I missed?"* or *"What is the most efficient database for this specific ER diagram?"*
- **Avoid Hype:** Don't use a massive Kubernetes microservices cluster for a simple To-Do app. Understand *why* you are choosing SQL vs NoSQL, or when to introduce Redis for caching.

---

## 🚀 Phase 5: The "What's Next?" (Continuous Evolution)
A project is never truly "done". 

**The Strategy:**
When you finish a project, immediately ask:
- *"How do I host this?"* (See our [Hosting Guide](./02_WHERE_TO_HOST_YOUR_PROJECTS.md)).
- *"How would I scale this if 10,000 people logged in right now?"*
- *"Can I run this locally and sovereignly without depending on expensive cloud providers?"* (The Zayvora Local-First philosophy).

---

## 📚 Appendix: The Deep Research Library (126 Articles)

As you progress through the BCA curriculum, you will hit a wall where standard tutorials stop helping. You will need to understand *why* systems break at scale. 

Below is the **VIA-Decide Master Archive of 126 Articles** (all deployed at `https://daxini.xyz/articles/`). 

### 🎯 Recommended Reading (Mapped to this Repo)

If you are just starting, do not read all 126. Read these specifically curated articles based on what you are learning:

#### 1. Backend & Infrastructure (Database & Auth)
*Read these when building APIs, Databases, or Login Systems.*
- **Local-First Authentication with IndexedDB** ([SSD-15](https://daxini.xyz/articles/sovereign-stack-diaries-15-local-first-authentication-with-indexeddb.html))
- **Scaling Node.js Without Memory Leaks** ([SSD-09](https://daxini.xyz/articles/sovereign-stack-diaries-09-scaling-node-modules-without-memory-leaks.html))
- **SQLite & WAL Mode for Hardiness** ([SSD-36](https://daxini.xyz/articles/sovereign-stack-diaries-36-local-database-storage-sqlite-and-wal-mode-hardiness.html))
- **Security Headers & Hardening CSP** ([SSD-37](https://daxini.xyz/articles/sovereign-stack-diaries-37-security-headers-hardening-csp-on-local-gateways.html))

#### 2. System Architecture & Design
*Read these when designing your Mermaid diagrams (Phase 3).*
- **The Cost of Shared State** ([Live](https://daxini.xyz/articles/the-cost-of-shared-state-why-institutional-ownership-requires-expensive-coordination.html))
- **Executor Isolation: The Danger of Sandboxing** ([Live](https://daxini.xyz/articles/executor-isolation-the-danger-of-sandboxing.html))
- **Speed or Determinism Paradox** ([Live](https://daxini.xyz/articles/you-can-have-speed-or-determinism-the-parallel-execution-paradox.html))

#### 3. Sovereign AI & Local-First (The Mindset)
*Read these before attempting the Advanced AI projects (like the Nex Research Agent).*
- **The Sovereign Shift: Why I stopped sending my code to SF** ([Live](https://daxini.xyz/articles/the-sovereign-shift-why-i-stopped-sending-my-code-to-san-francisco.html))
- **Why Local-First Is Not About Rejecting the Cloud** ([Live](https://daxini.xyz/articles/why-local-first-is-not-about-rejecting-the-cloud.html))
- **Local Inference via Ollama & Llama 3** ([SSD-21](https://daxini.xyz/articles/sovereign-stack-diaries-21-local-inference-optimization-via-ollama-and-llama-3.html))

<details>
<summary><strong>📂 Click to Expand the Full 126-Article Archive</strong></summary>

### 🔥 Core Thought Pieces (26)
1. The Zayvora Manifesto - [Link](https://daxini.xyz/articles/the-zayvora-manifesto.html)
2. The Coming Ownership Economy - [Link](https://daxini.xyz/articles/the-coming-ownership-economy.html)
3. The 80-Day Sovereign - [Link](https://daxini.xyz/articles/the-80-day-sovereign-how-agentic-orchestration-shattered-the-1-year-development-myth.html)
4. The Illusion of Premium - [Link](https://daxini.xyz/articles/the-illusion-of-premium-what-i-learned-building-a-20-month-tool-in-one-night-from-kutch.html)
5. The Founder's Paradox - [Link](https://daxini.xyz/articles/the-founder-s-paradox.html)
6. The Loneliest Skill in Tech - [Link](https://daxini.xyz/articles/the-loneliest-skill-in-tech-nobody-talks-about.html)
7. The Sovereign Shift - [Link](https://daxini.xyz/articles/the-sovereign-shift-why-i-stopped-sending-my-code-to-san-francisco.html)
8. The Difference Between Answering and Reasoning - [Link](https://daxini.xyz/articles/the-difference-between-answering-and-reasoning.html)
9. The Hidden Cost of Invisible Tools - [Link](https://daxini.xyz/articles/the-hidden-cost-of-invisible-tools-why-limits-are-where-real-learning-begins.html)
10. The Resume Is a Broken Format - [Link](https://daxini.xyz/articles/the-resume-is-a-broken-format-we-built-something-better.html)
11. The Ownership Gap in Educational Software - [Link](https://daxini.xyz/articles/the-ownership-gap-in-educational-software.html)
12. Invisible Systems - [Link](https://daxini.xyz/articles/invisible-systems.html)
13. Why AI Makes Your Judgment More Valuable - [Link](https://daxini.xyz/articles/why-ai-makes-your-judgment-more-valuable-not-less.html)
14. Why Most AI Builders Never Ship - [Link](https://daxini.xyz/articles/why-most-ai-builders-never-ship.html)
15. Why Local-First Is Not About Rejecting the Cloud - [Link](https://daxini.xyz/articles/why-local-first-is-not-about-rejecting-the-cloud.html)
16. Why We Stopped Using Auth Libraries - [Link](https://daxini.xyz/articles/why-we-stopped-using-auth-libraries-and-what-we-learned-about-trust-when-you-build-something-yourself.html)
17. Most Creators Are Stuck in a Loop - [Link](https://daxini.xyz/articles/most-creators-are-stuck-in-a-loop.html)
18. Most AI-Generated Content Has No Structure - [Link](https://daxini.xyz/articles/most-ai-generated-content-has-no-structure-here-s-the-protocol-that-fixes-that.html)
19. We Teach Knowledge As a List, It's Actually a Map - [Link](https://daxini.xyz/articles/we-teach-knowledge-as-a-list-it-s-actually-a-map.html)
20. Breaking Free: Sovereign AI Infrastructure - [Link](https://daxini.xyz/articles/breaking-free-how-sovereign-ai-infrastructure-replaces-the-20-month-illusion.html)
21. Build vs Buy Your AI Stack - [Link](https://daxini.xyz/articles/build-vs-buy-your-ai-stack-the-privacy-decision-nobody-s-making.html)
22. AI Hallucinations: Why Your Cloud AI Keeps Lying - [Link](https://daxini.xyz/articles/ai-hallucinations-why-your-cloud-ai-keeps-lying-and-why-zayvora-doesn-t.html)
23. AI Is Not a Textbox, It Is an Execution Layer - [Link](https://daxini.xyz/articles/ai-is-not-a-textbox-it-is-an-execution-layer.html)
24. Constitutional AI Has a Gap - [Link](https://daxini.xyz/articles/constitutional-ai-has-a-gap-i-found-it-by-working-with-claude.html)
25. Local-First Infrastructure Is Not a Feature - [Link](https://daxini.xyz/articles/local-first-infrastructure-is-not-a-feature-it-s-survival.html)
26. Execution Governance and the Legibility Moat - [Link](https://daxini.xyz/articles/execution-governance-and-the-legibility-moat.html)

### 📔 Sovereign Stack Diaries (50)
1. Silicon Autonomy in Kutch - [SSD-01](https://daxini.xyz/articles/sovereign-stack-diaries-01-silicon-autonomy-in-kutch-why-i-chose-a-mac-mini-m4.html)
2. The Zero-Cloud Dream - [SSD-02](https://daxini.xyz/articles/sovereign-stack-diaries-02-the-zero-cloud-dream-designing-the-sovereign-edge.html)
3. Layer 1: Semantic Reasoning Engine - [SSD-03](https://daxini.xyz/articles/sovereign-stack-diaries-03-layer-1-the-semantic-reasoning-engine-core.html)
4. Layer 2: Symbolic Execution - [SSD-04](https://daxini.xyz/articles/sovereign-stack-diaries-04-layer-2-symbolic-execution-with-sympy-and-pint.html)
5. Layer 3: Physics Guardian - [SSD-05](https://daxini.xyz/articles/sovereign-stack-diaries-05-layer-3-hard-boundary-enforcement-with-physics-guardian.html)
6. CEA-0000 Protocol Invariants - [SSD-06](https://daxini.xyz/articles/sovereign-stack-diaries-06-the-cea-0000-protocol-invariants.html)
7. Training the Authority Deck - [SSD-07](https://daxini.xyz/articles/sovereign-stack-diaries-07-training-the-authority-deck-traces-of-a-gatekeeper.html)
8. Physical Keys & Aporaksha NFC - [SSD-08](https://daxini.xyz/articles/sovereign-stack-diaries-08-physical-keys-and-aporaksha-nfc-authentication.html)
9. Scaling Node.js Without Memory Leaks - [SSD-09](https://daxini.xyz/articles/sovereign-stack-diaries-09-scaling-node-modules-without-memory-leaks.html)
10. Cache-Control Paradox at Cloudflare - [SSD-10](https://daxini.xyz/articles/sovereign-stack-diaries-10-the-cache-control-paradox-at-the-cloudflare-edge.html)
11. Zero-Ad Distribution - [SSD-11](https://daxini.xyz/articles/sovereign-stack-diaries-11-zero-ad-distribution-building-direct-trust-networks.html)
12. Soil Sensors & RS-485 - [SSD-12](https://daxini.xyz/articles/sovereign-stack-diaries-12-soil-sensors-and-rs-485-interfaces-on-the-mac-mini.html)
13. Designing for 8GB RAM - [SSD-13](https://daxini.xyz/articles/sovereign-stack-diaries-13-designing-for-8gb-ram-base-tiers.html)
14. PM2 Orchestration for 6 Nodes - [SSD-14](https://daxini.xyz/articles/sovereign-stack-diaries-14-pm2-orchestration-for-6-sovereign-edge-nodes.html)
15. Local-First Auth with IndexedDB - [SSD-15](https://daxini.xyz/articles/sovereign-stack-diaries-15-local-first-authentication-with-indexeddb.html)
16. PWA Offline-First Sync - [SSD-16](https://daxini.xyz/articles/sovereign-stack-diaries-16-pwa-offline-first-sync-strategies.html)
17. Bypassing Vercel 10s Limits - [SSD-17](https://daxini.xyz/articles/sovereign-stack-diaries-17-bypassing-the-vercel-10-second-function-limits.html)
18. Building the LogicHub Editor - [SSD-18](https://daxini.xyz/articles/sovereign-stack-diaries-18-building-the-logichub-visual-prompt-editor.html)
19. Replicable Environments & SSD - [SSD-19](https://daxini.xyz/articles/sovereign-stack-diaries-19-replicable-environments-workspace-ssd-strategies.html)
20. API Pricing Curves Collapse - [SSD-20](https://daxini.xyz/articles/sovereign-stack-diaries-20-why-api-pricing-curves-collapse-long-term-margin.html)
21. Local Inference via Ollama & Llama 3 - [SSD-21](https://daxini.xyz/articles/sovereign-stack-diaries-21-local-inference-optimization-via-ollama-and-llama-3.html)
22. Structured Logic Under CEA-0000 - [SSD-22](https://daxini.xyz/articles/sovereign-stack-diaries-22-structuring-structured-logic-outputs-under-cea-0000.html)
23. Nexus Interface: CAN Bus & Modbus - [SSD-23](https://daxini.xyz/articles/sovereign-stack-diaries-23-the-nexus-interface-can-bus-and-modbus-protocols.html)
24. Auto Document Shredding - [SSD-24](https://daxini.xyz/articles/sovereign-stack-diaries-24-automatic-temporary-document-shredding-for-privacy.html)
25. Preventing Hallucinations - [SSD-25](https://daxini.xyz/articles/sovereign-stack-diaries-25-preventing-hallucinations-in-system-synthesis.html)
26. Decoupling Logic from Generative Models - [SSD-26](https://daxini.xyz/articles/sovereign-stack-diaries-26-decoupling-logic-from-probabilistic-generative-models.html)
27. Unit-Aware Computations - [SSD-27](https://daxini.xyz/articles/sovereign-stack-diaries-27-unit-aware-computations-and-safety-engineering.html)
28. Self-Hosting Cloudflare Tunnels - [SSD-28](https://daxini.xyz/articles/sovereign-stack-diaries-28-self-hosting-cloudflare-tunnels-for-secure-routing.html)
29. Stale-While-Revalidate Caching - [SSD-29](https://daxini.xyz/articles/sovereign-stack-diaries-29-stale-while-revalidate-caching-for-articles-dispatches.html)
30. Compiling APKs via LogicHub - [SSD-30](https://daxini.xyz/articles/sovereign-stack-diaries-30-compiling-apks-autonomously-via-logichub-and-android-sdk.html)
31. Sovereign Developer's Toolkit - [SSD-31](https://daxini.xyz/articles/sovereign-stack-diaries-31-the-sovereign-developer%E2%80%99s-toolkit-tools-that-don%E2%80%99t-leak-data.html)
32. Soil Chemistry & Water Monitoring - [SSD-32](https://daxini.xyz/articles/sovereign-stack-diaries-32-soil-chemistry-and-water-level-monitoring-engines.html)
33. Cryptographic Asset Ownership - [SSD-33](https://daxini.xyz/articles/sovereign-stack-diaries-33-cryptographic-asset-ownership-on-aporaksha-core.html)
34. V8 Garbage Collection in Loops - [SSD-34](https://daxini.xyz/articles/sovereign-stack-diaries-34-memory-management-v8-garbage-collection-in-continuous-loops.html)
35. Namespace Partitioning - [SSD-35](https://daxini.xyz/articles/sovereign-stack-diaries-35-namespace-partitioning-for-parallel-agent-tasks.html)
36. SQLite & WAL Mode - [SSD-36](https://daxini.xyz/articles/sovereign-stack-diaries-36-local-database-storage-sqlite-and-wal-mode-hardiness.html)
37. Security Headers & CSP - [SSD-37](https://daxini.xyz/articles/sovereign-stack-diaries-37-security-headers-hardening-csp-on-local-gateways.html)
38. Fallback Pattern: Trace Recovery - [SSD-38](https://daxini.xyz/articles/sovereign-stack-diaries-38-the-fallback-pattern-trace-recovery-in-build_dataset.html)
39. Butterfly Calibration - [SSD-39](https://daxini.xyz/articles/sovereign-stack-diaries-39-butterfly-calibration-hardening-models-against-drift.html)
40. Dynamic Forms: Zero 3rd-Party - [SSD-40](https://daxini.xyz/articles/sovereign-stack-diaries-40-dynamic-form-submissions-via-clean-js-zero-third-party-libs.html)
41. Scaling from Bharat - [SSD-41](https://daxini.xyz/articles/sovereign-stack-diaries-41-scaling-from-bharat-infrastructure-tailored-for-rural-connectivity.html)
42. Energy Auditing: Solar & UPS - [SSD-42](https://daxini.xyz/articles/sovereign-stack-diaries-42-energy-auditing-powering-a-base-tier-node-on-solar-and-ups.html)
43. Version-Injected PWA Assets - [SSD-43](https://daxini.xyz/articles/sovereign-stack-diaries-43-version-injected-assets-for-dynamic-pwa-updates.html)
44. Self-Validating Compiler - [SSD-44](https://daxini.xyz/articles/sovereign-stack-diaries-44-the-self-validating-compiler-verification-pipelines.html)
45. XML & RSS Without APIs - [SSD-45](https://daxini.xyz/articles/sovereign-stack-diaries-45-standardizing-xml-and-rss-feeds-without-external-apis.html)
46. Zero-Tracking Analytics - [SSD-46](https://daxini.xyz/articles/sovereign-stack-diaries-46-building-a-zero-tracking-analytics-layer-in-js.html)
47. Shredding Base64 in Memory - [SSD-47](https://daxini.xyz/articles/sovereign-stack-diaries-47-how-to-shred-base64-documents-in-memory-safely.html)
48. Local Traces for Retraining - [SSD-48](https://daxini.xyz/articles/sovereign-stack-diaries-48-structuring-local-system-traces-for-retraining-loops.html)
49. Multi-Device Sync - [SSD-49](https://daxini.xyz/articles/sovereign-stack-diaries-49-multi-device-synchronization-on-a-local-first-domain.html)
50. The Long Game: Capital Autonomy - [SSD-50](https://daxini.xyz/articles/sovereign-stack-diaries-50-the-long-game-solo-engineering-and-capital-autonomy.html)

### 🛠️ Builder Journey (20)
1. I Built 44 Browser Tools - [Live](https://daxini.xyz/articles/i-built-44-browser-tools-in-a-few-months-here-s-what-s-actually-live-and-what-s-coming-no-fluff-here-s-what-exists-what-it-does-and-who-it-s-for.html)
2. I Built a Business Directory for Kutch in 3 Hours - [Live](https://daxini.xyz/articles/i-built-a-business-directory-for-kutch-in-3-hours-here-s-what-s-actually-inside-it-and-why-it-exists-in-the-first-place.html)
3. I Built My Own OpenClaw Alternative - [Live](https://daxini.xyz/articles/i-built-my-own-openclaw-alternative-here-s-why-you-should-too.html)
4. I Built One AI Model, Then Split It Into Three - [Live](https://daxini.xyz/articles/i-built-one-ai-model-then-i-split-it-into-three-here-s-what-changed.html)
5. I Built My Own AI Brain - [Live](https://daxini.xyz/articles/i-got-tired-of-forgetting-everything-i-read-so-i-built-my-own-ai-brain-one-person-one-mac-mini-12-000-books-and-a-growing-conviction-that-the-to.html)
6. I Ran My AI for 14 Hours on a Flight - [Live](https://daxini.xyz/articles/i-ran-my-ai-for-14-hours-on-a-flight-with-no-wi-fi-it-never-failed-once-that-s-when-i-knew-i-d-built-something-real.html)
7. I Spent ₹1 Lakh on a Local AI Stack - [Live](https://daxini.xyz/articles/i-spent-1-lakh-to-build-a-local-ai-stack-here-s-exactly-what-that-bought.html)
8. I Spent 8 Hours Building India's AI OS - [Live](https://daxini.xyz/articles/i-spent-8-hours-building-the-ai-operating-system-india-doesn-t-know-it-needs-yet.html)
9. I Spent 8 Hours Not Building Features - [Live](https://daxini.xyz/articles/i-spent-8-hours-today-doing-what-most-developers-avoid-not-building-new-features.html)
10. I Stopped Asking My AI Questions - [Live](https://daxini.xyz/articles/i-stopped-asking-my-ai-questions-i-gave-it-a-repository-instead.html)
11. I Stopped Paying for LLMs - [Live](https://daxini.xyz/articles/i-stopped-paying-for-llms-built-my-own-for-4-000-month-savings.html)
12. I Train My AI on My Own Mistakes - [Live](https://daxini.xyz/articles/i-train-my-ai-on-my-own-mistakes-here-s-why-that-matters.html)
13. I Tried a 24-Hour Product Sprint - [Live](https://daxini.xyz/articles/i-tried-a-24-hour-product-sprint-here-s-what-actually-happened.html)
14. AI Has an Orchestration Problem - [Live](https://daxini.xyz/articles/i-used-to-think-ai-had-a-limits-problem-it-has-an-orchestration-problem.html)
15. Building a Decision Engine for the Internet - [Live](https://daxini.xyz/articles/building-a-decision-engine-for-the-internet.html)
16. Building ViaDecide: What I've Learned - [Live](https://daxini.xyz/articles/building-viadecide-what-i-ve-learned-so-far.html)
17. Building Smarter Growth - [Live](https://daxini.xyz/articles/building-smarter-growth-in-a-fast-changing-world.html)
18. From Swipe Experiments to System Thinking - [Live](https://daxini.xyz/articles/from-swipe-experiments-to-system-thinking-documenting-the-viadecide-builder-journey.html)
19. Interactive Founder Documentary - [Live](https://daxini.xyz/articles/how-i-turned-building-viadecide-into-an-interactive-founder-documentary.html)
20. Something Is About to Go Live - [Live](https://daxini.xyz/articles/something-is-about-to-go-live-you-re-seeing-it-first.html)

### 🔬 Zayvora Technical & Runtime Logs (6)
1. Zayvora Runtime Log 002: Environment Was the Product - [Live](https://daxini.xyz/articles/zayvora-runtime-log-002-the-environment-was-always-the-product.html)
2. Zayvora Runtime Log 003: Constraint Preservation - [Live](https://daxini.xyz/articles/zayvora-runtime-log-003-constraint-preservation.html)
3. Zayvora vs Perplexity - [Live](https://daxini.xyz/articles/zayvora-vs-perplexity-why-they-re-not-competitors-i-built-zayvora-perplexity-is-killing-it-and-that-s-exactly-why-they-re-not-competitors.html)
4. Daxini Stack Architecture Journal - [Live](https://daxini.xyz/articles/daxini-stack-architecture-journal.html)
5. Daxini.xyz as a PWA - [Live](https://daxini.xyz/articles/daxini-xyz-as-a-progressive-web-app-why-zayvora-needs-an-offline-first-interface-zayvora-newsletter-april-20-2026.html)
6. From Prompts to Pipelines - [Live](https://daxini.xyz/articles/from-prompts-to-pipelines-the-evolution-of-ai-systems.html)

### 🧠 Architecture Theory (8)
1. Branch Legibility - [Live](https://daxini.xyz/articles/branch-legibility-why-abstract-codebases-stop-being-computable.html)
2. Executor Isolation: Sandboxing Danger - [Live](https://daxini.xyz/articles/executor-isolation-the-danger-of-sandboxing.html)
3. Local-First Coordination Protocol - [Live](https://daxini.xyz/articles/local-first-coordination-the-distributed-truth-protocol.html)
4. Retries Create Parallel Truth - [Live](https://daxini.xyz/articles/retries-create-parallel-truth-and-that-s-why-your-system-lies-to-you.html)
5. The Cost of Shared State - [Live](https://daxini.xyz/articles/the-cost-of-shared-state-why-institutional-ownership-requires-expensive-coordination.html)
6. Workspace Pollution - [Live](https://daxini.xyz/articles/workspace-pollution-why-long-running-agents-slowly-destroy-their-own-environments.html)
7. Speed or Determinism Paradox - [Live](https://daxini.xyz/articles/you-can-have-speed-or-determinism-the-parallel-execution-paradox.html)
8. When Deployment Limits Become Clarity - [Live](https://daxini.xyz/articles/when-deployment-limits-become-clarity-why-i-stopped-using-platforms-as-black-boxes.html)

### 📦 Product & Platform (16)
1. Beyond the Resume: SkillHex - [Live](https://daxini.xyz/articles/beyond-the-resume-how-skillhex-is-rewiring-the-future-of-hiring.html)
2. A STEM Kit Is a Systems Problem - [Live](https://daxini.xyz/articles/a-stem-kit-is-a-systems-problem-before-it-becomes-a-product-problem.html)
3. A New Space for Ideas Inside ViaDecide - [Live](https://daxini.xyz/articles/a-new-space-for-ideas-inside-the-viadecide-blog-platform.html)
4. Decision Infrastructure: Missing Layer - [Live](https://daxini.xyz/articles/decision-infrastructure-the-missing-layer-in-small-commerce.html)
5. Five Domains, One Pipeline, Built for Bharat - [Live](https://daxini.xyz/articles/five-domains-one-pipeline-built-for-bharat.html)
6. From Static Guide to 720-Combination StudyOS - [Live](https://daxini.xyz/articles/from-a-static-guide-to-a-720-combination-learning-os-in-a-single-html-file-the-evolution-of-studyos-viadecide.html)
7. GN8R Bot: Next Era of Generative Intelligence - [Live](https://daxini.xyz/articles/gn8rbot-unleashing-the-next-era-of-generative-intelligence-and-autonomous-innovation.html)
8. One Remotion File, 100 Videos - [Live](https://daxini.xyz/articles/one-remotion-file-100-videos-this-is-how-educational-content-should-be-made.html)
9. 3 Games In, Now the Real Build Starts - [Live](https://daxini.xyz/articles/3-games-in-now-the-real-build-starts-total-games-made-till-now-3.html)
10. Everything Looked Built, Nothing Worked - [Live](https://daxini.xyz/articles/everything-looked-built-nothing-worked-here-s-what-i-learned-about-systems-vs-screens.html)
11. Copy: Building a Decision Engine - [Live](https://daxini.xyz/articles/copy-of-building-a-decision-engine-for-the-internet.html)
12. Copy: Everything Looked Built - [Live](https://daxini.xyz/articles/copy-of-everything-looked-built-nothing-worked-here-s-what-i-learned-about-systems-vs-screens.html)
13. Copy: Swipe Experiments - [Live](https://daxini.xyz/articles/copy-of-from-swipe-experiments-to-system-thinking-documenting-the-viadecide-builder-journey.html)
14. Copy: Founder Documentary - [Live](https://daxini.xyz/articles/copy-of-how-i-turned-building-viadecide-into-an-interactive-founder-documentary.html)
15. Copy: Invisible Systems - [Live](https://daxini.xyz/articles/copy-of-invisible-systems.html)
16. Copy: Why AI Makes Your Judgment More Valuable - [Live](https://daxini.xyz/articles/copy-of-why-ai-makes-your-judgment-more-valuable-not-less.html)

</details>

---

### Summary
**Stop copy-pasting.** Research the business, understand the laws, map the architecture, and *then* write the code. That is how you build real systems.
