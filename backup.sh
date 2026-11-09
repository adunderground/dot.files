#!/usr/bin/env bash
# Run on the OLD laptop before the wipe. Copies everything that must NOT go in this
# public repo (secrets, WorkBoard-internal Claude config and history, foreman boards) to OneDrive.
set -euo pipefail

DEST="${DEST:-$(ls -d ~/Library/CloudStorage/OneDrive-* | head -1)/mac-backup}"
mkdir -p "$DEST"

# Secrets: every export in ~/.bash_profile that carries a token/key -> ~/.secrets
grep -E '^export (GITHUB_USERNAME|NPM_AUTH_TOKEN|NPM_TOKEN|GITHUBTOKEN|WB_IDENTITY_PUBLIC_KEY|WB_JWT_[A-Z_]+|NPM_DHTMLX_TOKEN)=' \
  ~/.bash_profile > ~/.secrets
chmod 600 ~/.secrets

cd ~
tar -czf "$DEST/private.tgz" \
  .secrets .ssh .npmrc \
  .claude/CLAUDE.md .claude/settings.json .claude/commands .claude/skills .claude/bin \
  .agents .config/herdr/config.toml .config/iterm2/cc-status \
  adev/.foreman adev/skills-lock.json adev/bash_profile.sh \
  adev/Tiltfile adev/tilt-agents-runtime.override.yaml adev/vnextwobo-mongo.override.yml \
  adev/Coreai4387ResetCommand.php adev/pros-cons.txt adev/docs \
  2> >(grep -v 'Removing leading' >&2) || true

echo "Wrote $DEST/private.tgz ($(du -h "$DEST/private.tgz" | cut -f1))"

# Claude history: Code transcripts + memory, prompt history, and the desktop app's
# Code-tab sidebar (titles, pins, groups). Quit the Claude app first for a clean copy.
tar -czf "$DEST/claude-history.tgz" \
  .claude/projects .claude/history.jsonl \
  "Library/Application Support/Claude/claude-code-sessions" \
  "Library/Application Support/Claude/claude_desktop_config.json" \
  2> >(grep -v 'Removing leading' >&2) || true

echo "Wrote $DEST/claude-history.tgz ($(du -h "$DEST/claude-history.tgz" | cut -f1))"
"$(dirname "$0")/backup-downloads.sh"
echo "Now export Raycast settings by hand: Raycast > Settings > Advanced > Export -> $DEST/"
