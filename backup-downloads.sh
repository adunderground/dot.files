#!/usr/bin/env bash
# Copy ~/Downloads to OneDrive as plain files (browsable, no unpacking). Safe to re-run:
# only new or changed files are copied, nothing in OneDrive is deleted.
set -euo pipefail

DEST="${DEST:-$(ls -d ~/Library/CloudStorage/OneDrive-* | head -1)/mac-backup}"
mkdir -p "$DEST/Downloads"

rsync -a --exclude .DS_Store ~/Downloads/ "$DEST/Downloads/"

echo "Copied ~/Downloads -> $DEST/Downloads ($(du -sh "$DEST/Downloads" | cut -f1), $(find "$DEST/Downloads" -type f | wc -l | tr -d ' ') files)"
