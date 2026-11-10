# Mac rebuild — instructions for an agent

You are setting up Arkady's Mac after an Intune wipe. Work top to bottom. Each step is
idempotent; re-run it if unsure. Stop and ask Arkady when a step needs a login, a GUI
click, or a password — never type passwords or tokens yourself.

This repo is **public**. Never commit secrets, tokens, or WorkBoard-internal files
(`~/.claude/*`, skills, memory, foreman boards). Those live in OneDrive as `private.tgz`.

---

## 0. Before the wipe (old laptop, Arkady runs this)

Unpushed branches and stashes are intentionally abandoned — don't try to save them.

1. Quit the Claude desktop app, then from Terminal: `./backup.sh` → writes
   `OneDrive-WorkBoard/mac-backup/{private,claude-history}.tgz`, `mac-backup/Downloads/` and `~/.secrets`.
2. Raycast → Settings → Advanced → **Export** → save into the same OneDrive folder.
3. `./export-settings.sh` → refreshes app settings in this repo; review `git diff`,
   then commit and push.
4. Confirm OneDrive shows both `.tgz` files synced (cloud icon, not "uploading").

---

## 1. Company setup (Arkady, follows the #mdm-migration-oct steps)

1. Enable Location Services during setup. Register the Mac (top-right notification).
2. `wobo-onboard` in Terminal — sign in to Microsoft/GitHub/npm when asked, then leave it
   ~1h. It installs the dev stack (OrbStack, k8s, tilt, az, …). Guide:
   https://github.com/Workboard/wobo-cli/blob/main/localdev/DEVELOPER-GUIDE.md
3. From **Company Portal**: Slack, Office, OneDrive, Teams, Chrome, Edge, StrongDM,
   Defender. Sign in to StrongDM and connect `dt-westus-litellm` (127.0.0.1:10133).

Do not start step 2 below until `wobo-onboard` finishes — it owns Homebrew's dev packages.

## 2. Homebrew + apps

```bash
command -v brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
mkdir -p ~/adev && git clone https://github.com/adunderground/dot.files.git ~/adev/dot.files
brew trust oven-sh/bun   # newer brew refuses third-party taps until trusted
brew bundle --file ~/adev/dot.files/Brewfile
```

`cask "github"` fails (needs sudo) when Company Portal already installed GitHub Desktop — ignore it.

Not in brew, install by hand: Claude desktop (claude.ai/download), WorkBoardAI, LidRun.

## 3. Shell + git

```bash
cd ~/adev/dot.files
cp home/.bash_profile home/.profile home/.gitconfig ~/
mkdir -p ~/.local/bin && cp bin/* ~/.local/bin/
# login shell is Homebrew bash 5: /bin/bash 3.2 loses history with .bash_profile's PROMPT_COMMAND
grep -qx /opt/homebrew/bin/bash /etc/shells || echo /opt/homebrew/bin/bash | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/bash
fnm install 22 && fnm default 22
curl -LsSf https://astral.sh/uv/install.sh | sh   # creates ~/.local/bin/env, sourced by .profile
```

## 4. Restore private backup

```bash
tar -xzf ~/Library/CloudStorage/OneDrive-WorkBoard/mac-backup/private.tgz -C ~
chmod 600 ~/.secrets; chmod 700 ~/.ssh; chmod 600 ~/.ssh/id_rsa
```

Secrets (JWT keys, tokens) also exist in Arkady's own encrypted cloud file. If
`private.tgz` is missing or stale, ask him for the `~/.secrets` contents from there.

This restores `~/.secrets`, `~/.ssh`, `~/.npmrc`, `~/.claude/{CLAUDE.md,settings.json,
commands,skills,bin}`, `~/.agents`, herdr/iTerm hook config, and
`~/adev/.foreman` plus loose files in `~/adev`. Then:

```bash
ln -sfn ~/adev/.foreman ~/Code/plans 2>/dev/null || { mkdir -p ~/Code && ln -sfn ~/adev/.foreman ~/Code/plans; }
ln -sf ~/.claude/skills/pull-wobo-repos/pull-wobo-repos.sh ~/.local/bin/pull-wobo-repos
```

### Claude history

Install the Claude desktop app and sign in, then **quit it** (Cmd-Q) before the Code tab
creates fresh state. Restore and relaunch:

```bash
tar -xzf ~/Library/CloudStorage/OneDrive-WorkBoard/mac-backup/claude-history.tgz -C ~
```

Brings back every Code session transcript, Claude memory (`~/.claude/projects/*/memory`),
prompt history, and the Code-tab sidebar with its pins. Check: the sidebar shows the
pinned sessions, and `claude --resume` inside `~/adev/ai-agents` lists old sessions.

Everything here is keyed by absolute path (`/Users/arkady.dolina/adev/...`). It only
works unchanged if the username is still `arkady.dolina` and repos are back under
`~/adev` (step 7). If the username changed, stop and tell Arkady — the folder names in
`~/.claude/projects` and the paths inside the session files both need rewriting.
Sessions that lived in `*-worktrees` folders are readable but resume into a missing dir.
The sidebar restore copies app internals, not an official export: if it doesn't come
back, transcripts and memory are still intact in `~/.claude/projects`.

## 5. App preferences

Quit each app first, **including iTerm2** — it rewrites its prefs on quit, so run this
from Terminal.app, not iTerm:

```bash
cd ~/adev/dot.files
for f in macos/prefs/*.plist; do n=$(basename "$f" .plist); defaults import "$n" "$f"; done
mkdir -p ~/Library/Application\ Support/LidRun && cp macos/lidrun/rules.json ~/Library/Application\ Support/LidRun/
./macos/system.sh     # Dock, Finder, dark mode, screenshots, menu-bar clock
```

Saved app settings:

| App | What comes back | Source |
|---|---|---|
| iTerm2 | profile, Anonymous Pro 16, colors, window size, keys | `macos/prefs` |
| Rectangle | all shortcuts, launch at login | `macos/prefs` |
| Stats | enabled modules, widgets, menu-bar order | `macos/prefs` |
| Itsycal | icon style, week start, agenda days | `macos/prefs` |
| AltTab, Hidden Bar | shortcuts, appearance | `macos/prefs` (AltTab license: `private.tgz`) |
| LidRun | automation rules | `macos/lidrun` |
| macOS | Dock, Finder, hot corner, screenshots, clock | `macos/system.sh` |
| VS Code, Cursor | settings, keybindings, snippets, extensions | `editors/` (below) |
| DBeaver, OBS, gh | connections + saved credentials, scenes, gh config | `private.tgz` (step 4) |
| Raycast | everything | `.rayconfig` in OneDrive (manual import) |

Editors (after the app is installed and opened once):

```bash
cd ~/adev/dot.files/editors
cp Code/settings.json ~/Library/Application\ Support/Code/User/
xargs -n1 code --install-extension < Code/extensions.txt
cp Cursor/settings.json ~/Library/Application\ Support/Cursor/User/
```

The Anonymous Pro font comes from the Brewfile; if iTerm shows Monaco,
`brew install --cask font-anonymous-pro` and relaunch iTerm.

Not saved (re-sync by signing in): Chrome, Firefox, Slack, Teams, Outlook, Spotify,
Postman, Obsidian (vault is the `AD_obsidian` repo, config in its `.obsidian/`).
Signal Desktop has to be re-linked from the phone; choose to transfer message history.
IntelliJ and pgAdmin/MySQL Workbench had no custom setup worth saving.

Then ask Arkady to:
- Raycast: Settings → Advanced → **Import** the `.rayconfig` from OneDrive.
- Grant Accessibility / Screen Recording to Rectangle, Raycast, AltTab, Stats, LidRun
  (System Settings → Privacy & Security). You cannot click these for him.
- Re-add Dock apps (order isn't restored) and re-enter the iTerm AI API key if used.

## 6. CLIs and agent tooling

```bash
npm i -g @anthropic-ai/claude-code @playwright/cli
uv tool install --python 3.12 git+https://github.com/NVIDIA/skillspector.git   # yara-python has no wheel for newest Python
curl https://cursor.com/install -fsS | bash          # cursor-agent
gh auth login
```

- **twg** (Jira/Confluence CLI): install per https://developer.atlassian.com/cloud/twg-cli/
  into `~/.local/bin/twg`, then log in (Arkady does the auth step).
- **codex**: install from openai.com/codex if still used.
- Claude plugins: open `claude`, run `/plugin` — marketplaces in the restored
  `settings.json` re-download on first launch. `wobo-marketplace` points at
  `~/adev/wobo-marketplace`, so clone it first (step 7).
  Do this only after the Claude history restore (step 4): until then `claude-plugins-official`
  plugins (playwright, mattpocock-skills) report "not found".
- Skills from `~/adev/skills-lock.json` (caveman etc.): from `~/adev`,
  `npx skills experimental_install` (`--frozen-lockfile` refuses if upstream changed).

## 7. Repos

```bash
cd ~/adev
for r in ai-agents server vnextwobo wobo-okr app-services rbr workstreams data-service-api \
         wobo-fastmcp wobo-cli wobo-components wobo-marketplace rehearsal connect hro-domain \
         product-prototypes; do
  [ -d $r ] || gh repo clone Workboard/$r
done
gh repo clone adunderground/AD_obsidian
gh repo clone adunderground/ti2026
gh repo clone ayghri/i-have-adhd
```

Skip anything `wobo-onboard` already cloned. Worktree dirs (`*-worktrees`) are not
restored; recreate from pushed branches as needed.

## 8. Verify

Open a new terminal and confirm: emoji prompt + cowsay fortune appear, `node -v` is 22,
`echo ${NPM_TOKEN:+set}` prints `set`, `gh auth status` is green, `claude` starts with
plugins loaded, Rectangle shortcuts move windows, Stats/Itsycal are in the menu bar.
Report anything that failed as a list.
