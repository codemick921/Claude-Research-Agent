# Claude Research Agent

A self-updating research assistant built on [Claude Code](https://docs.claude.com/en/docs/claude-code/overview).
You give it a list of topics; on a schedule it searches the web, keeps a living **dossier**
for each topic up to date, and writes you a short report of what's new — all stored as plain
Markdown files on your own machine. It pairs naturally with [Obsidian](https://obsidian.md),
but works fine on its own.

This repository is a **template**. It ships with a blank topic config — you point it at
whatever you want to track (a product, a company, a research field, a competitor, a policy
area) by editing one file.

## What it does

- **Tracks topics you define** and researches them automatically on a schedule.
- **Maintains a living dossier per topic** — a running summary plus a dated changelog of
  every new finding, with source URLs.
- **Doesn't repeat itself** — each dossier keeps a ledger of sources already seen, so it only
  reports genuinely new information across runs.
- **Writes you a digest** after each run, and (optionally) a morning brief.
- Everything is **local Markdown** — no lock-in, fully version-controllable, yours to edit.

---

## Requirements

1. **Node.js** v18+ — https://nodejs.org (install the LTS version).
2. **A Claude account** on a paid plan (Pro or Max). Runs use your plan's usage.
3. **(Optional) Obsidian** — a nice reader for the notes the agent writes.

Check Node is installed:
```bash
node --version
```

---

## Setup

### 1. Install Claude Code
```bash
npm install -g @anthropic-ai/claude-code
claude --version
```

### 2. Get this repository
Clone it (recommended) — the folder it creates **is your vault**:
```bash
git clone https://github.com/YOUR-USERNAME/claude-research-agent.git
cd claude-research-agent
```
> **Downloading the ZIP from GitHub instead?** Unzip it from a terminal
> (`unzip claude-research-agent-main.zip`), **not** by double-clicking — some macOS unzip
> tools silently drop the hidden `.claude/` folder, and the agent's commands live there.

### 3. Configure your topics
Open **`RESEARCH.md`** — this is your control panel. Delete the example topic and add your
own (the format is explained in the file and in [How it works](#how-it-works) below).
Optionally, fill in **`CLAUDE.md`** with your name/role to sharpen results.

### 4. First run
The agent's commands only load when you launch it **from inside this folder** — do this every
time:
```bash
claude
```
The first launch opens your browser to log in. Then, inside the session, type `/help` to
confirm `/research-update` is listed, and run a single topic to test:
```
/research-update example-topic
```
(use one of your real slugs). When it finishes, type `exit` and check the output landed:
```bash
ls 05-RESEARCH/
```
You should see a dossier file with a summary and dated findings. That's it working.

---

## How it works

### Folder structure

| Path | Purpose |
|---|---|
| `RESEARCH.md` | **Control panel.** Your topics and the rules. Edit this to change anything. |
| `CLAUDE.md` | Optional context about you, auto-loaded each session. |
| `05-RESEARCH/` | One **dossier** per topic, e.g. `my-topic.md`. The main output. |
| `00-INBOX/` | Where run **reports** (`research-run-….md`) and the optional brief land. |
| `.claude/commands/` | The agent's commands (the `/research-update` etc. you type). |
| `.claude/settings.json` | Pre-approves web + file tools so runs don't stop to ask permission. |
| `research-cron.sh` | Script to run the agent automatically on a schedule. |
| `01-CAPTURES/`, `02-CONNECTIONS/`, `03-PROJECTS/` | Optional extras for using this as a wider note system. Ignore if you only want research. |

### The control panel — `RESEARCH.md`
Every run reads this file, so it's the only thing you edit to change behaviour. Each topic
has four fields:
- **slug** — short lowercase-hyphen name; becomes the dossier filename
  (`slug: my-topic` → `05-RESEARCH/my-topic.md`).
- **watch for** — what counts as relevant. Be specific; this is your quality filter.
- **search angles** — the phrases the agent actually searches. Specific phrasing = better signal.
- **special instructions** — extra rules (e.g. "factual only, note dates").

The **global rules** at the top apply to every topic (source preferences, "only new info",
output format). Change them once and all topics follow.

### The dossiers — `05-RESEARCH/<slug>.md`
Each is a living document the agent maintains in four sections:
- **Current state** — a one-paragraph summary, updated only when something material changes.
- **Changelog** — dated findings, newest first. The running history.
- **Contradictions & shifts** — flagged when new info overturns something earlier.
- **Sources already covered** — every URL used so far. This is the **dedup ledger** that
  stops the agent reporting the same source twice. Don't prune it.

### Sourcing strategy
By default the agent is told to prefer **primary / official sources** (the maker's own blog,
official docs, filings, peer-reviewed papers), accept **reputable trade press** as a secondary
source, and **skip low-quality listicles and SEO bait**. Every finding is dated and carries
its source URL. It leans on web **search** rather than full-page fetches (see the note in
[Troubleshooting](#troubleshooting)). Tune any of this in the global rules of `RESEARCH.md`.

### The commands (type inside a `claude` session)
- **`/research-update`** — research all topics. Add a slug for just one:
  `/research-update my-topic`.
- **`/daily-brief`** — synthesise recent reports/dossiers into a short brief in `00-INBOX/`.
- **`/deep-research <topic>`** — interrogate what's *already in your vault* (no web search).
- **`/process-inbox`**, **`/weekly-connections`**, **`/monthly-review`** — extras for the
  wider note system below.

---

## Scheduling

Pick one approach.

**Native scheduling (simplest, macOS/Windows desktop app).** Inside a `claude` session, run
`/schedule` and set `/research-update` to your preferred interval (e.g. every 12 hours).

**cron (macOS/Linux).** Edit the `VAULT=` line in `research-cron.sh` to your real path, then:
```bash
chmod +x research-cron.sh
crontab -e
```
Add a line — for example, every 12 hours:
```
0 */12 * * * /bin/bash /full/path/to/claude-research-agent/research-cron.sh
```
`0 */12 * * *` = midnight and noon. `0 7,19 * * *` = 7am/7pm. `0 7 * * *` = once each morning
(cheapest). Each run is a full Claude Code session and uses your plan's usage.

---

## Using it day to day

If you only want research: read the latest dossiers in `05-RESEARCH/` and the reports in
`00-INBOX/` whenever you like — the schedule keeps them fresh.

If you want a fuller "second brain": drop your own notes into `00-INBOX/`, run `/process-inbox`
to file them, `/weekly-connections` to surface links, and `/monthly-review` for a monthly
synthesis. All optional.

---

## Customising

Everything lives in `RESEARCH.md`:
- **New topic** → copy a topic block, give it a new slug, fill in the fields.
- **Different focus** → edit "watch for" and "search angles".
- **Pause a topic** → move it under a `## Paused` heading.
- **Different sources/style** → edit the global rules.
- **Cheaper runs** → add `model: claude-haiku-4-5-20251001` under the top `---` of
  `.claude/commands/research-update.md`, and/or schedule less often.

---

## Troubleshooting

**"Unknown command" for `/research-update`.** You launched `claude` from the wrong place, or
(if you used the ZIP) the hidden `.claude/` folder didn't extract. `cd` into this folder first,
then `claude`. If still missing, re-clone or unzip from a terminal.

**It ran but `05-RESEARCH/` is empty / it made an odd folder.** Usually means `RESEARCH.md`
isn't at the repo root, so the agent gets confused about where it is. Confirm `CLAUDE.md` and
`RESEARCH.md` are both at the top level (`ls`).

**`API Error: 400 … thinking blocks … cannot be modified`.** A known Claude Code bug on long,
busy sessions — not your setup. Quit (Ctrl+C twice) and start fresh; the session can't be
recovered. To avoid it, research **one topic at a time** interactively. Scheduled runs are far
less prone to it.

**A web fetch fails mid-run.** Known issue where full-page fetches can fail in unattended
mode; the command falls back to search results and keeps going, so you still get findings.

**Costs creeping up.** Each run is a full session with web searches. Trim topics, run less
often, or switch to a cheaper model (see Customising).

---

## License

MIT — see [`LICENSE`](LICENSE). Fill in your name and year, or swap in a different license
before publishing.

> Inspired by the "personal chief of staff" knowledge-system idea, rebuilt to run entirely on
> Claude Code and local Markdown.
