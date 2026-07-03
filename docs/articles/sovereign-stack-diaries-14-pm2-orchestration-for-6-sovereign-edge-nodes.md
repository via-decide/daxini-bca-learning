# PM2 Orchestration for 6 Sovereign Edge Nodes


PM2 Orchestration for 6 Sovereign Edge

Nodes

Running a multi-domain ecosystem requires robust process orchestration. We use PM2 to manage 6 autonomous edge nodes, including LogicHub, Aporaksha, VIA, a...

◆

Engineering

◆

Systems

By

Dharam Daxini

· June 15, 2026

Read more at →

◆ daxini.xyz

Running a multi-domain ecosystem requires robust process orchestration. We use PM2 to manage 6 autonomous edge nodes, including LogicHub, Aporaksha, VIA, and Daxini Space, on a single Mac Mini server.

Each edge node runs as an independent Express server, mapped to a dedicated local port from 7001 to 7006. PM2 monitors these processes in real-time, automatically restarting them if memory limits are exceeded or if a crash occurs.

We route external domains through a self-hosted Cloudflare tunnel, which maps incoming web traffic directly to the corresponding PM2 ports. This setup provides a robust, zero-configuration hosting platform that runs entirely within our local environment.

Built using: LogicHub · Aporaksha · Daxini · Zayvora