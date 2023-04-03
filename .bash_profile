HOST_NAME=ad

source ~/.nvm/nvm.sh
nvm use stable
shopt -s autocd
shopt -s histappend

# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"


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

emojis=("🌐" "🎲" "🌍" "🔱" "🌵" "💙💛" "🚀" "🌚" "👹" "🌞") 

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
source /Users/ad/.docker/init-bash.sh || true # Added by Docker Desktop

# ----------------------
# Functions
# ----------------------

# generate amzqr QR codes directly from the terminal
amzqr() {
  # Check if the amzqr package is installed
  if ! python3 -c 'from amzqr import amzqr' &> /dev/null; then
    echo "Error: The amzqr package is not installed. Please install it using pip3." >&2
    return 1
  fi

  # Set default values for optional arguments
  local version=1
  local level='H'
  local output_file='qrcode.png'
  local output_dir='.'
  local picture_file=''
  local colorize=false
  local contrast=1.0
  local brightness=1.0

  # Parse command-line arguments
  while getopts ":v:l:n:d:p:ccon:bri:" opt; do
    case $opt in
      v)
        version="$OPTARG"
        ;;
      l)
        level="$OPTARG"
        ;;
      n)
        output_file="$OPTARG"
        ;;
      d)
        output_dir="$OPTARG"
        ;;
      p)
        picture_file="$OPTARG"
        ;;
      c)
        colorize=true
        ;;
      o)
        contrast="$OPTARG"
        ;;
      b)
        brightness="$OPTARG"
        ;;
      :)
        echo "Error: -$OPTARG requires an argument." >&2
        return 1
        ;;
      \?)
        echo "Error: Invalid option: -$OPTARG" >&2
        return 1
        ;;
    esac
  done

  # Remove the parsed options from the argument list
  shift $((OPTIND-1))

  # Check if text argument is provided
  if [ $# -ne 1 ]; then
    echo -e "Usage: amzqr [-v VERSION] [-l LEVEL] [-n OUTPUT-FILENAME] [-d OUTPUT-DIR] [-p PICTURE-FILE] [-c] [-con CONTRAST] [-bri BRIGHTNESS] TEXT  \nOR JUST USE A SUDO CUZ THIS THING IS STUPID" >&2
    return 1
  fi

  # Generate the QR code image
  python3 -c "from amzqr import amzqr; amzqr.generate('$1', version=$version, level='$level', file_name='$output_file', save_dir='$output_dir', pic_name='$picture_file', colorized=$colorize, contrast=$contrast, brightness=$brightness)"
}


