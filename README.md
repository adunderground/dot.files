# dot.files

Mac setup for a fresh machine. Hand **[SETUP.md](SETUP.md)** to an agent.

| Path | What |
|---|---|
| `SETUP.md` | step-by-step rebuild guide (agent-readable) |
| `backup.sh` | run before a wipe: secrets, private config, Claude history, Downloads → OneDrive |
| `backup-downloads.sh` | copy `~/Downloads` to OneDrive (also called by `backup.sh`) |
| `Brewfile` | CLI tools and apps (`brew bundle`) |
| `home/` | `.bash_profile`, `.profile`, `.gitconfig` |
| `bin/` | personal scripts → `~/.local/bin` |
| `macos/` | app prefs (iTerm2, Rectangle, Stats, Itsycal, AltTab, Hidden Bar) |
| `ad-tone/` | writing-voice guide |

Secrets are never committed; `.bash_profile` sources `~/.secrets`.
