export BASH_SILENCE_DEPRECATION_WARNING=1

HOST_NAME=arkady.dolina

shopt -s histappend

# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

eval "$(fnm env --use-on-cd --shell bash)"

export PATH=$PATH:$HOME/bin

export HISTSIZE=5000
export HISTFILESIZE=10000

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
bldgrn='\e[1;32m' # Bold Green
bldpur='\e[1;35m' # Bold Purple
txtrst='\e[0m'    # Text Reset

emojis=("🌐" "🇺🇦" "🎲" "🌍" "🧹" "🏄‍♂️" "🌚" "🌞") 

EMOJI=${emojis[$RANDOM % ${#emojis[@]} ]}

print_before_the_prompt () {
    dir=$PWD
    home=$HOME
    dir=${dir/"$HOME"/"~"}
    printf "\n $txtred%s: $bldpur%s $txtgrn%s\n$txtrst" "$HOST_NAME" "$dir" "$(vcprompt)"
}

PROMPT_COMMAND=print_before_the_prompt
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
PS1="$EMOJI >"

fortune | cowsay -s

function mkcd()
{
	mkdir $1 && cd $1
}

# -------
# Aliases
# -------
alias 🍺="git checkout -b drunk"
alias a='code .'
alias c='code .'
alias reveal-md="reveal-md --theme night --highlight-theme hybrid --port 1337"
alias ns='npm start'
alias start='npm start'
alias nr='npm run'
alias run='npm run'
alias nis='npm i -S'
alias l="ls" # List files in current directory
alias ll="ls -al" # List all files in current directory in long list format
alias o="open ." # Open the current directory in Finder

# ----------------------
# Git Aliases
# ----------------------
alias ga='git add'
alias gaa='git add .'
alias gaaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gd='git diff'
alias gi='git init'
alias gl='git log'
alias gp='git pull'
alias gpsh='git push'
alias gss='git status -s'
alias gs='echo ""; echo "*********************************************"; echo -e "   DO NOT FORGET TO PULL BEFORE COMMITTING"; echo "*********************************************"; echo ""; git status'

# Secrets live in ~/.secrets (never committed; backed up to OneDrive)
[ -f ~/.secrets ] && . ~/.secrets

. "$HOME/.local/bin/env"

# Toggle Ukrainian keyboard layout on/off
ukr() {
  swift - <<'SWIFT'
import Carbon
let all = TISCreateInputSourceList(nil, true)!.takeRetainedValue() as NSArray as! [TISInputSource]
guard let src = all.first(where: {
    guard let p = TISGetInputSourceProperty($0, kTISPropertyInputSourceID) else { return false }
    return Unmanaged<CFString>.fromOpaque(p).takeUnretainedValue() as String == "com.apple.keylayout.Ukrainian-PC"
}) else { print("Ukrainian layout not found"); exit(1) }
let on = TISGetInputSourceProperty(src, kTISPropertyInputSourceIsEnabled)
    .map { CFBooleanGetValue(Unmanaged<CFBoolean>.fromOpaque($0).takeUnretainedValue()) } ?? false
let err = on ? TISDisableInputSource(src) : TISEnableInputSource(src)
guard err == noErr else { print("failed: \(err)"); exit(1) }
print("Ukrainian \(on ? "removed" : "added")")
SWIFT
}

# Foreman Flow — read-only TUI of a foreman board: fflow <project-slug> [goal-bead-id]
fflow() {
	local slug=$1 db=~/Code/plans/$1/.beads
	[[ -z $slug ]] && { echo "usage: fflow <project-slug> [bead-id]" >&2; return 2; }
	[[ -d $db ]] || { echo "fflow: no board at $db" >&2; return 1; }
	bun --install=fallback run ~/adev/wobo-marketplace/plugins/engineer-tools/foreman/scripts/flow/index.ts --db "$db" ${2:+"$2"}
}
