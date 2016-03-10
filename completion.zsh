#Completion tweaks.

# Load hostnames from /etc/hosts and ~/.ssh/known_hosts.
#hosts=($(cat /etc/hosts | grep -v "^#" | awk '{print $1}'| cut -d"," -f1), $(cat $HOME/.ssh/known_hosts | awk '{print $1}'| cut -d"," -f1))
hosts=($(cat /etc/hosts | grep -v "^#" | awk '{print $1}'| cut -d"," -f1))
zstyle ':completion:*' hosts $hosts

#zstyle ':completion:*' menu select
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# do not complete internal functions
zstyle ':completion:*:functions' ignored-patterns '_*'

#If you want it to complete users if and only if it can't complete anything else,
#drop the trailing "-".
zstyle ':completion::complete:cd::' tag-order '! users' -


#fpath=($ZDOTDIR/comp $fpath)
# brew install zsh-completions
fpath=(/usr/local/share/zsh-completions /usr/local/share/zsh/site-functions ~/.zsh/completion $fpath)

autoload -U compinit && compinit

# Testing menu list completion.
zmodload zsh/complist
bindkey -M menuselect '^M' .accept-line

# reset completion for specific commands
# mark command for marked.app, and i don't use _mh (mail client?)
# compdef -d ${(k)_comps[(R)_mh]}
compdef -d mark


