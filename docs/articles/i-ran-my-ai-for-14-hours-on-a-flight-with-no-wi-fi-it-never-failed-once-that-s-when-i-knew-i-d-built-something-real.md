# I ran my AI for 14 hours on a flight with no Wi-Fi. It never failed once. That's when I knew I'd built something real.


I ran my AI for 14 hours on a flight with no Wi-Fi. It never failed once. That's when I knew I'd built something real.

Developers panicked. Workflows broke. Slack channels lit up with

◆

Engineering

◆

Systems

By

Dharam Daxini

· April 9, 2026

Read more at →

◆ daxini.xyz

OpenAI went down last month.

Developers panicked. Workflows broke. Slack channels lit up with "is it down for you too?"

I was in the middle of a research session.

I didn't notice for three hours.

Because my AI doesn't live on OpenAI's servers.

It lives on my machine.

Let me back up.

Eighteen months ago, I was a heavy cloud AI user. GPT-4 for reasoning. Claude for writing. Pinecone for vectors. AWS for everything else. I had built what looked like a serious technical workflow.

Then one night at 2am — mid-project, mid-thought — I hit a rate limit.

The work stopped. Not because I ran out of ideas. Because a server somewhere decided I'd used enough tokens for the evening.

I sat there and thought:

why am I renting my own intelligence?

That question changed everything.

The Daxini Stack

— a local-first AI system that runs entirely on your own hardware.

No subscriptions. No API keys. No cloud provider between you and your own reasoning.

The core of it is

Zayvora

— a reasoning engine I built on quantized Llama 3. It doesn't autocomplete your questions. It actually works through them, in six structured stages:

DECOMPOSE → RETRIEVE → SYNTHESIZE → CALCULATE → VERIFY → REVISE

Let me tell you why each one matters.

When you send a message to ChatGPT, here's the uncomfortable truth about what happens:

Tokens are generated. Left to right. One after another. In a single forward pass.

The model doesn't stop to check itself. It doesn't verify whether its conclusion is consistent with its first sentence. It produces text that

sounds

complete — because it's been trained to sound complete — whether or not it actually

is.

For writing an email? Fine.

For an engineering decision where being confidently wrong costs you something real? That's a problem.

There's a failure mode nobody talks about: the AI that states correct facts and then draws completely wrong conclusions from them. No hallucination flag. No warning. Just a structurally broken answer dressed in fluent prose.

I built the 6-stage loop because I needed something better than fluent prose.

Stage 1 — DECOMPOSE:

Your question gets broken into sub-problems. Not paraphrased. Actually decomposed. "What chunking strategy for 12,000 books?" isn't one question. It's four. Zayvora finds them before it proceeds.

Stage 2 — RETRIEVE:

Zayvora pulls evidence from Nex — my local RAG engine running over 12,000+ technical books stored on my own machine. Dense embeddings + BM25 + Reciprocal Rank Fusion. The top 8 chunks feed the next stage. Nothing leaves my hardware.

Stage 3 — SYNTHESIZE:

Each sub-problem gets its own draft answer. Separately. Because errors in reasoning for sub-problem A cannot be allowed to contaminate sub-problem C.

Stage 4 — CALCULATE:

Units are tracked through every arithmetic step. If they don't resolve, the stage flags it. The system doesn't paper over the discrepancy and produce a number anyway.

Stage 5 — VERIFY:

Three tests. Internal consistency. Formula-result consistency within 5% tolerance. Assumption transparency — every assumed value is flagged inline. If any test fails, the loop produces no output.

Stage 6 — REVISE:

When verification finds a failure, the system routes back to the earliest stage where the failure originated and re-runs from there. Not from the beginning. From the source of the problem.

The loop terminates one of two ways:

✅ All three verification checks pass.

Or:

🔴 The system says clearly:

"I don't know, and here's exactly why."

That second output is not a failure. It is the most honest thing a reasoning system can produce.

Most AI systems are trained to avoid saying "I don't know" because it feels like a bad user experience.

I designed mine to say it loudly when it's true.

The 6-stage loop is expensive. It takes longer than a single forward pass. Uses more compute.

In a cloud system, that cost is passed to you in tokens billed. The provider has a financial incentive to keep the loop short — or skip it entirely and give you a fast, fluent, single-pass answer that

feels

complete.

When the loop runs on your own hardware, there's no billing incentive. No rate limit that makes depth expensive. No company whose margin depends on keeping your inference fast at the cost of correctness.

Zayvora is 4.7GB. It runs on 8GB of RAM.

\

I want to say this carefully because it's often misread:

This is not about distrust of cloud companies.

It's about what reliable infrastructure actually looks like.

If your AI reasoning depends on a remote API, you have introduced a single point of failure you don't control. You cannot audit the system prompt running against your data. You cannot pin the model version without paying for a tier. You cannot run it in an air-gapped environment, on a plane, at sea, or anywhere your internet is unavailable.

A zero-dependency system has none of these vulnerabilities.

It runs today exactly as it ran the day it was deployed.

No supply chain update breaks it. No provider migration requires your attention. No terms of service change revokes your access.

That's not a political statement.

That's what engineers call reliable.

Both went live on Amazon this week.

📘

The Daxini Stack: Engineering a Local-First AI System

(\$5.00)

The honest account. The decisions, the failures, the architecture that finally held. Every dead end I hit and why I hit it.

📗

The daxini.space Handbook: Build Sovereign. Deploy Local. Own Your Stack

.

(\$9.99)

The step-by-step blueprint. If the first book is the

why

, this is the

how

. Available in hardcover for those who want their references physical and permanent.

I'm an engineer from Gandhidham, Kutch, Gujarat.

Not a Silicon Valley company. Not a funded startup. Not a team.

One person, a laptop, and a question that wouldn't leave me alone:

Why am I renting my own intelligence?

If you've ever asked yourself the same thing — the stack is yours to build.

Run Zayvora:

ollama.com/daxini2404/zayvora

Build sovereign. Deploy local. Own your stack.

♻️ Repost this if you know an engineer who's hit a rate limit at 2am and thought:

there has to be a better way.

#LocalAI #AIEngineering #BuildInPublic #LLM #Ollama #MachineLearning #SoftwareEngineering #RAG #OpenSource #AITools #IndieHacker #TechIndia #ArtificialIntelligence #MLOps