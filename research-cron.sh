#!/usr/bin/env bash
# Runs one autonomous research pass. Schedule this on the interval you want via cron.
# EDIT the VAULT path below to point at YOUR cloned copy before using.

VAULT="$HOME/claude-research-agent"   # <-- change to your actual path
cd "$VAULT" || exit 1

claude -p "/research-update" \
  --allowedTools "WebSearch,WebFetch,Read,Write,Edit,Glob" \
  --permission-mode acceptEdits \
  --max-turns 40 \
  >> "$VAULT/.claude/research.log" 2>&1

echo "[$(date)] research run finished" >> "$VAULT/.claude/research.log"
