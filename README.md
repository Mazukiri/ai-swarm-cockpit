# AI Swarm Cockpit

A portable terminal cockpit for running 4 AI coding CLIs in one project folder with a shared live chat.

Designed for setups like:

- AGY / Gemini as orchestrator
- Claude as architect and reviewer
- Codex as backend or main implementer
- DeepSeek / CM CLI as frontend, test, or component implementer

The goal is not to replace your existing CLIs. This repo gives them a shared room:

- one tmux layout
- four agent panes
- one live chat pane
- a small router that forwards messages such as `@Claude`, `@Codex`, `@DeepSeek`, `@AGY`
- a collaboration protocol so they do not overwrite each other

---

## What it looks like

```txt
┌──────────────────────┬──────────────────────┐
│ AGY Orchestrator     │ Claude Architect      │
├──────────────────────┼──────────────────────┤
│ Codex Implementer    │ DeepSeek Implementer  │
├──────────────────────┴──────────────────────┤
│ Live shared chat: tail -f .swarm/chat.log    │
└──────────────────────────────────────────────┘
```

Agents talk by running commands such as:

```bash
say claude "Please design the interview-session API contract."
say codex "Please implement POST /api/interview-sessions."
say deepseek "Backend endpoint is ready. Please wire the frontend practice screen."
say agy "Task WEB-001 is done and ready for review."
broadcast "MVP sprint started. Please inspect your assigned areas."
```

The router watches `.swarm/messages.jsonl` and pushes each message into the correct tmux pane.

---

## Install into any project

After this repo is on your machine:

```bash
git clone https://github.com/<your-user>/ai-swarm-cockpit ~/tools/ai-swarm-cockpit
cd /path/to/your/project
~/tools/ai-swarm-cockpit/install-to-project.sh .
```

Then edit:

```bash
.swarm/agents.env
```

Set the actual commands for your CLIs:

```bash
AGY_CMD='agy'
CLAUDE_CMD='claude'
CODEX_CMD='codex'
DEEPSEEK_CMD='codex'
```

Start the cockpit:

```bash
.swarm/bin/swarm-start
```

Stop it:

```bash
.swarm/bin/swarm-stop
```

---

## Requirements

You need:

- `tmux`
- `python3`
- your AI CLIs installed and logged in: `agy`, `claude`, `codex`, CM CLI, etc.

Optional but useful:

- `git`
- `gh` GitHub CLI
- `just`

---

## Recommended agent roles

| Agent | Role | Main responsibility |
|---|---|---|
| AGY | Orchestrator | Break tasks, update board, coordinate agents |
| Claude | Architect / Reviewer | Data model, API contract, review, risk detection |
| Codex | Main Implementer | Backend, integration, tests |
| DeepSeek | UI / Tests / Docs | Frontend, reusable components, test states, docs |

You can change these roles in:

```bash
.swarm/prompts/agy.md
.swarm/prompts/claude.md
.swarm/prompts/codex.md
.swarm/prompts/deepseek.md
```

---

## How live chat works

The cockpit has three simple pieces:

1. `.swarm/chat.log` — readable live chat for humans
2. `.swarm/messages.jsonl` — machine-readable message bus
3. `.swarm/bin/swarm-router` — router that sends messages into the target tmux panes

When an agent runs:

```bash
say claude "Please review this API contract."
```

The message appears in `.swarm/chat.log` and is routed into Claude's pane.

To watch chat manually:

```bash
.swarm/bin/watch-chat
```

---

## Important limitation

This toolkit cannot magically capture every word printed by each AI CLI and turn it into a message. Instead, the agents are instructed to communicate through the provided commands:

```bash
say <agent> "message"
broadcast "message"
```

This is much more stable than trying to scrape terminal output.

---

## First prompt to AGY

After starting the cockpit, send this to AGY:

```txt
You are the orchestrator. Read AI_COLLAB.md and .swarm/prompts/agy.md. Coordinate Claude, Codex, and DeepSeek to complete the current MVP. Use say/broadcast for live communication. Keep .swarm/BOARD.md, .swarm/LOCKS.md, .swarm/DECISIONS.md, and .swarm/QA.md updated.
```

Then AGY should start sending messages to other agents.

---

## Example workflow

```txt
User -> AGY:
Coordinate the team to finish the interview-prep MVP.

AGY -> Claude:
Design the MVP domain model and API contract.

Claude -> Codex:
Implement the interview-session backend module.

Codex -> DeepSeek:
Backend endpoints are ready. Please wire the practice screen.

DeepSeek -> AGY:
Frontend is done. Please request review.

AGY -> Claude:
Review backend + frontend integration.
```

---

## GitHub push

From the root of this repo:

```bash
git init
git add .
git commit -m "Initial AI Swarm Cockpit template"
gh repo create ai-swarm-cockpit --public --source=. --remote=origin --push
```

Or create an empty GitHub repo in the browser, then:

```bash
git remote add origin git@github.com:<your-user>/ai-swarm-cockpit.git
git branch -M main
git push -u origin main
```
