# Alice's over-engineered z-shell configuration, released in the public domain.
# Shell builtin, file, and process management aliases.

# I like some of my commands to act consistently across platforms.
if [[ "$VENDOR" == "apple" ]]; then
    alias d='du -h -d 1'
    alias grep='grep --colour'
    alias clear="osascript -e 'tell application \"System Events\" to keystroke \"k\" using command down'"
    alias ls='ls -F -G'
    alias acls="ls -Gl@eF"
    alias lock='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'

    alias stroke='/Applications/Utilities/Network\ Utility.app/Contents/Resources/stroke'
    alias scan='sudo nmap -sS -PN'
elif [[ "$VENDOR" == "portbld" ]]; then
    alias d='du -h -d 1'
    alias grep='grep --colour'
    alias ls='ls -F -G'
else
    alias d='du --total -h --max-depth=1'
    alias ls='ls -F --color=auto'
fi

# Disable autocorrection for these commands.
# Usually the target name doesn't exist, which triggers the 'did you mean' prompt.
alias cp='nocorrect cp -i'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv -i'
alias rm='nocorrect rm -i'

# Disable globbing for these commands as they perform their own.
alias find='noglob find'

# Various very short aliases.
alias path='echo -e ${PATH//:/\\n}'
#alias which='type -all'
alias lsd='ls -ld *(-/DN)'
alias py='python'
alias v='less'

# Fix common mistakes.
alias cd.='cd .'
alias cd/='cd /'

# Process management.
alias p='ps ax'
