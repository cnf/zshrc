# Alert me when other users log in.
watch=(notme)

# If ZSH is not defined, use the current script's directory.
[[ -z "$ZSH" ]] && export ZSH="${${(%):-%x}:a:h}"

# Set ZSH_CACHE_DIR to the path where cache files should be created
# or else we will use the default cache/
if [[ -z "$ZSH_CACHE_DIR" ]]; then
  ZSH_CACHE_DIR="$ZSH/cache"
fi

# Make sure $ZSH_CACHE_DIR is writable, otherwise use a directory in $HOME
if [[ ! -w "$ZSH_CACHE_DIR" ]]; then
  ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
fi

DIRSTACKSIZE=20
LISTPROMPT=''
LOGCHECK=60
REPORTTIME=3
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S'
SPROMPT='zsh: correct '%R' to '%r' ? ([Y]es/[N]o/[E]dit/[A]bort) '
WATCHFMT='%n %a %l from %m at %t.'

export BROWSER='open'
# http://geoff.greer.fm/lscolors/
export CLICOLOR=1
# export LSCOLORS="ExGxFxDxCxDxDxhbhdacEc"
export LSCOLORS="Exfxcxdxbxegedabagacad"
export LS_COLORS="di=01;34:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:"
export EDITOR='vim'
export LESSOPEN="|lesspipe %s"
export VISUAL=$EDITOR

