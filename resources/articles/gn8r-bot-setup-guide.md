# Building the GN8R Bot: A Guide to the Antigravity Apex Engine

The **GN8R Bot** (often referred to as the Antigravity Apex Engine or Synthesis Orchestrator) is a Telegram-based GitHub orchestration and file generation agent. It's designed to automate tedious engineering tasks, synthesize traces, and manage codebase architecture strictly via Telegram commands, all while adhering to ironclad Standard Operating Procedures (SOPs).

If you want to set up a `gn8r`-style orchestration bot, this guide breaks down the core architecture, process management, and strict compliance rules required.

---

## 1. Core Tech Stack & Requirements

The bot is built on modern JavaScript, specifically designed to run on a stable server (or a Raspberry Pi/local Linux box) with high uptime.

- **Environment**: Node.js v20 or higher.
- **Paradigm**: ES Modules (Ensure `"type": "module"` is set in your `package.json`).
- **Core Dependencies**:
  - `node-fetch`: For API calls to Telegram and GitHub.
  - `dotenv`: For managing API keys securely.
  - `formdata-node`: For handling complex payload structures if file uploading is required.

---

## 2. Directory & Architecture Structure

A robust orchestration bot requires clean separation of concerns. The `gn8r` bot relies on the following structural foundation:

```text
gn8r-bot/
├── .env                  # Secret keys (Telegram Bot Token, GitHub PAT)
├── package.json          # Dependencies and scripts (type: module)
├── SOP.md                # The Codex: Pre-Modification Protocol
├── src/
│   ├── index.js          # Main entry point (initializes services)
│   ├── telegram-bot.js   # Handles the Telegram long-polling / webhook logic
│   └── config.js         # Configuration and constant values
├── scripts/
│   └── test-flow.js      # Utility for running simulated end-to-end tests
└── templates/
    └── task-template.md  # Standardized templates for agent output
```

### Essential NPM Scripts
Your `package.json` should include standard hooks for development and production:
```json
"scripts": {
  "start": "node src/index.js",
  "dev": "node --watch src/index.js",
  "check": "node --check src/index.js src/telegram-bot.js src/config.js",
  "test:flow": "node scripts/test-flow.js"
}
```

---

## 3. Process Management with PM2

Because this bot is expected to listen for commands 24/7, you cannot rely on a simple terminal session. **PM2** (Process Manager 2) is the industry standard for keeping Node.js applications alive indefinitely.

*Requirement: PM2 version 6.0.14+*

**Key PM2 Commands for the GN8R Bot:**
- **Start the bot:** `pm2 start src/index.js --name "gn8r"`
- **Check Status:** `pm2 list` or `pm2 status` (Ensure the status says `online`).
- **Restart (after config changes):** `pm2 restart gn8r`
- **View Live Logs:** `pm2 logs gn8r`
- **Diagnostics:** If PM2 seems frozen, run `pm2 ping` to wake the daemon.

*Fallback Verification:* If PM2 lists are unresponsive, you can verify the node process manually in Linux via:
`ps aux | grep "src/index.js" | grep -v grep`

---

## 4. The Codex: SOP & Compliance Rules

What separates the `gn8r` bot from a standard ChatGPT script is its strict adherence to the **Pre-Modification Protocol (SOP)**. The bot is bound by a `SOP.md` file that it must read into context before executing orchestration tasks.

### Core Principles of the GN8R Codex:
1. **Strict Adherence:** The bot must strictly adhere to the explicit instructions provided by the user via Telegram. No optimizations or "clever" changes are permitted without user authorization.
2. **Mandatory Clarification:** If a Telegram command is ambiguous, the bot must pause execution, paraphrase its understanding, and ask the user for confirmation.
3. **Proposals, Not Actions:** If the bot detects a better architectural approach, it must present it as a *proposal* with a clear "Why" and impact analysis. It cannot write the code until the user says "Yes".
4. **Security First:** The bot must immediately flag security vulnerabilities (e.g., hardcoded keys, unsafe command execution) in the codebase.

## Summary

Setting up a `gn8r` type bot isn't just about hooking up a Telegram API to OpenAI. It's about building a robust, PM2-managed ES Module infrastructure that obeys strict operational protocols (`SOP.md`). When properly configured, this bot becomes the Apex Engine of your continuous learning and development workflow.
