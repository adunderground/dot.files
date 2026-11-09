# Mac rebuild — instructions for an agent

You are setting up Arkady's Mac after an Intune wipe. Work top to bottom. Each step is
idempotent; re-run it if unsure. Stop and ask Arkady when a step needs a login, a GUI
click, or a password — never type passwords or tokens yourself.

This repo is **public**. Never commit secrets, tokens, or WorkBoard-internal files
(`~/.claude/*`, skills, memory, foreman boards). Those live in OneDrive as `private.tgz`.

---

## 0. Before the wipe (old laptop, Arkady runs this)

Unpushed branches and stashes are intentionally abandoned — don't try to save them.

1. `./backup.sh` → writes `OneDrive-WorkBoard/mac-backup/private.tgz` and `~/.secrets`.
2. Raycast → Settings → Advanced → **Export** → save into the same OneDrive folder.
3. Commit and push this repo.
4. Confirm OneDrive shows `private.tgz` synced (cloud icon, not "uploading").

---

## 1. Company setup (Arkady, follows the #mdm-migration-oct steps)

1. Enable Location Services during setup. Register the Mac (top-right notification).
2. `wobo-onboard` in Terminal — sign in to Microsoft/GitHub/npm when asked, then leave it
   ~1h. It installs the dev stack (OrbStack, k8s, tilt, az, …). Guide:
   https://github.com/Workboard/wobo-cli/blob/main/localdev/DEVELOPER-GUIDE.md
3. From **Company Portal**: Slack, Zoom, Office, OneDrive, Teams, Chrome, Edge, StrongDM,
   Defender. Sign in to StrongDM and connect `dt-westus-litellm` (127.0.0.1:10133).

Do not start step 2 below until `wobo-onboard` finishes — it owns Homebrew's dev packages.

## 2. Homebrew + apps

```bash
command -v brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
mkdir -p ~/adev && git clone https://github.com/adunderground/dot.files.git ~/adev/dot.files
brew bundle --file ~/adev/dot.files/Brewfile
```

Not in brew, install by hand: Claude desktop (claude.ai/download), WorkBoardAI, Orca, LidRun.

## 3. Shell + git

```bash
cd ~/adev/dot.files
cp home/.bash_profile home/.profile home/.gitconfig ~/
mkdir -p ~/.local/bin && cp bin/* ~/.local/bin/
chsh -s /bin/bash   # login shell is bash, not zsh
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
commands,skills,bin,projects/*/memory}`, `~/.agents`, herdr/iTerm hook config, and
`~/adev/.foreman` plus loose files in `~/adev`. Then:

```bash
ln -sfn ~/adev/.foreman ~/Code/plans 2>/dev/null || { mkdir -p ~/Code && ln -sfn ~/adev/.foreman ~/Code/plans; }
ln -sf ~/.claude/skills/pull-wobo-repos/pull-wobo-repos.sh ~/.local/bin/pull-wobo-repos
```

Claude memory dirs are keyed by path (`-Users-arkady-dolina-adev-ai-agents`). If the
username changed, rename those folders to match the new `$HOME`.

## 5. App preferences

Quit each app first, then:

```bash
cd ~/adev/dot.files/macos/prefs
for f in *.plist; do defaults import "${f%.plist}" "$f"; done
```

Covers Rectangle, Stats, Itsycal, AltTab, Hidden Bar. Then ask Arkady to:
- Raycast: Settings → Advanced → **Import** the `.rayconfig` from OneDrive.
- Grant Accessibility / Screen Recording to Rectangle, Raycast, AltTab, Stats
  (System Settings → Privacy & Security). You cannot click these for him.
- Set each menu-bar app to launch at login.

## 6. CLIs and agent tooling

```bash
npm i -g @anthropic-ai/claude-code @playwright/cli
uv tool install git+https://github.com/NVIDIA/skillspector.git
curl https://cursor.com/install -fsS | bash          # cursor-agent
gh auth login
```

- **twg** (Jira/Confluence CLI): install per https://developer.atlassian.com/cloud/twg-cli/
  into `~/.local/bin/twg`, then log in (Arkady does the auth step).
- **codex**: install from openai.com/codex if still used.
- Claude plugins: open `claude`, run `/plugin` — marketplaces in the restored
  `settings.json` re-download on first launch. `wobo-marketplace` points at
  `~/adev/wobo-marketplace`, so clone it first (step 7).
- Skills from `~/adev/skills-lock.json` (caveman etc.): `npx skills install` from `~/adev`.

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
