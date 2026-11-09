#!/usr/bin/env bash
# Refresh the app settings saved in this repo from the current Mac. Re-run before the
# wipe, review `git diff`, commit. Only public-safe settings land here; anything with
# credentials goes through backup.sh to OneDrive instead.
set -euo pipefail
cd "$(dirname "$0")"
AS=~/Library/Application\ Support

# Menu-bar apps + iTerm2. Machine-local state (window frames, update checks, run
# counters, telemetry) is stripped so imports don't clobber the new Mac's state.
mkdir -p macos/prefs
for id in com.knollsoft.Rectangle eu.exelban.Stats com.mowglii.ItsycalApp \
          com.lwouis.alt-tab-macos com.dwarvesv.minimalbar com.googlecode.iterm2; do
  defaults export "$id" - | python3 -I -c '
import plistlib, sys
p = plistlib.loads(sys.stdin.buffer.read())
for k in [k for k in p if k.startswith(("NoSync", "SU", "NSWindow Frame", "NSSplitView", "NSToolbar"))
          or k in ("CodeReviewSavedPrompts", "AIVectorStore")]:
    del p[k]
sys.stdout.buffer.write(plistlib.dumps(p, fmt=plistlib.FMT_XML))' > "macos/prefs/$id.plist"
done

# LidRun automation rules
mkdir -p macos/lidrun && cp "$AS/LidRun/rules.json" macos/lidrun/

# Editors: settings, keybindings, snippets, extension lists
for ed in Code Cursor; do
  mkdir -p "editors/$ed"
  for f in settings.json keybindings.json; do
    [ -f "$AS/$ed/User/$f" ] && cp "$AS/$ed/User/$f" "editors/$ed/"
  done
  [ -d "$AS/$ed/User/snippets" ] && rsync -a --delete "$AS/$ed/User/snippets/" "editors/$ed/snippets/"
done
code --list-extensions > editors/Code/extensions.txt
ls ~/.cursor/extensions | grep -v '\.json$' | sed -E 's/-[0-9]+\.[0-9]+.*$//' | sort -u > editors/Cursor/extensions.txt

grep -rliE 'ghp_|PRIVATE KEY|password|secret' macos editors && echo "^ review these before committing" || echo "Settings refreshed; review git diff"
