# Completion tweaks.

# Load hostnames from /etc/hosts and ~/.ssh/known_hosts.
#hosts=($(cat /etc/hosts | grep -v "^#" | awk '{print $1}'| cut -d"," -f1), $(cat $HOME/.ssh/known_hosts | awk '{print $1}'| cut -d"," -f1))
hosts=($(cat /etc/hosts | grep -v "^#" | awk '{print $1}'| cut -d"," -f1))
zstyle ':completion:*' hosts $hosts

#zstyle ':completion:*' menu select
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'


#fpath=($ZDOTDIR/comp $fpath)
# brew install zsh-completions
fpath=(/usr/local/share/zsh-completions $fpath)

autoload -U compinit && compinit

# reset completion for specific commands
# mark command for marked.app, and i don't use _mh (mail client?)
compdef -d ${(k)_comps[(R)_mh]}
#compdef -d mark


