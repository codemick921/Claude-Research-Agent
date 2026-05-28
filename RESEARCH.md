# RESEARCH CONFIG — your control panel

> The `/research-update` command reads THIS file on every run. To change what the agent
> tracks or how it writes, edit here — nothing else. Delete the example topic below and add
> your own.

## Global rules (apply to every topic)
- Only record information that is genuinely **new** since the last run. Check each dossier's
  "Sources already covered" list and skip anything already there.
- Never delete or rewrite my existing notes. You may only **append** to and **revise the
  summary of** the topic dossiers in `05-RESEARCH/`.
- Prefer **primary / official sources** (the maker's own blog, official docs, filings,
  peer-reviewed papers) over second-hand commentary. Reputable trade press is acceptable as
  a secondary source. Skip low-quality listicles and SEO bait.
- For every finding, record the source URL and the date you found it.
- If a new finding contradicts the current dossier summary, flag it loudly — don't silently
  overwrite.
- Be concise. One sharp sentence per finding beats a paragraph.

## Output format for each finding
`- [YYYY-MM-DD] <one-sentence finding> — <source URL>`

## Topics to track
Each topic needs four lines. The **slug** becomes the dossier filename
(`slug: my-topic` → `05-RESEARCH/my-topic.md`). Add or remove topics freely.

### Topic 1 — EXAMPLE (edit or delete this)
- **slug:** example-topic
- **watch for:** the kinds of facts that matter to you — e.g. new releases, pricing changes,
  major announcements, research findings, policy changes.
- **search angles:** the phrases you'd actually type into a search engine — e.g.
  "<subject> latest", "<subject> 2026 update", "<subject> release", "<subject> vs alternatives".
- **special instructions:** optional — e.g. "factual updates only, ignore opinion pieces;
  always note the effective date".

### Topic 2
- **slug:**
- **watch for:**
- **search angles:**
- **special instructions:**

---
**Schedule:** this config is read by every scheduled run (default suggested: every 12 hours).
**To pause a topic:** move it under a `## Paused` heading.
