# Self-Hosting Cloudflare Tunnels for Secure Routing


Self-Hosting Cloudflare Tunnels for Secure

Routing

Exposing local servers to the internet usually requires opening ports on your router, which exposes your network to port scanners and DDoS attacks. We avoi...

◆

Engineering

◆

Systems

By

Dharam Daxini

· June 29, 2026

Read more at →

◆ daxini.xyz

Exposing local servers to the internet usually requires opening ports on your router, which exposes your network to port scanners and DDoS attacks. We avoid this security risk by using self-hosted Cloudflare Tunnels.

A lightweight cloudflared daemon runs locally, establishing a secure outbound connection to Cloudflare's edge network. Public traffic is routed through this tunnel directly to our local PM2 edge ports, with no open inbound ports required.

This setup provides robust protection against network-level attacks. It also allows us to run our entire multi-domain web ecosystem behind a standard residential internet connection without needing a static public IP.

Built using: LogicHub · Aporaksha · Daxini · Zayvora