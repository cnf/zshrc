# Don't export the PS1 variable to prevent naive tampering.
typeset +x PS1

case $TERM in
    *xterm*|*rxvt*)
        # Special function precmd, executed before displaying each prompt.
        function precmd() {
            # Set the terminal title to the current working directory.
            #vcs_info
            print -Pn "\e]0;%m — %2~\a"
        }
        
        # Special function preexec, executed before running each command.
        function preexec () {
            print -Pn "\e]2;${2:q} — %~\a"
        }
esac

#=========
autoload -z colors; colors

if [ $UID -eq 0 ]; then
    user="%{$fg_bold[red]%}%m%{$reset_color%}"
    symbol='#'
else
    user="%{$fg_bold[green]%}%m%{$reset_color%}"
    symbol='$'
fi

function rsymbol {
    git branch >/dev/null 2>/dev/null && echo "%{$fg_bold[yellow]%}±" && return
    #hg root >/dev/null 2>/dev/null && echo "%{$fg_bold[yellow]%}☿" && return
    [ -d .svn ] && echo "%{$fg_bold[yellow]%}⨰" && return
    echo $symbol
}

function venv {
    [ $VIRTUAL_ENV ] || return
    #echo "  %{$fg_bold[cyan]%}$(basename ${VIRTUAL_ENV} | tr '[A-Z]' '[a-z]')%{$reset_color%}"
    echo "  %{$fg_bold[cyan]%}$(basename ${VIRTUAL_ENV})%{$reset_color%}"
}

function getla {
    if [[ "$VENDOR" == "apple" || "$VENDOR" == "portbld" ]]; then
        uptime | cut -d ":" -f 4 | cut -d ' ' -f 2
        return
    fi
    cat /proc/loadavg | cut -d " " -f 1
}

#autoload -Uz vcs_info
##zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
##zstyle ':vcs_info:*' formats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
##zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
#zstyle ':vcs_info:*' check-for-changes true
#zstyle ':vcs_info:*' stagedstr "⚐"
#zstyle ':vcs_info:*' unstagedstr "⚑"
#zstyle ':vcs_info:git*' formats "%{$fg_bold[yellow]%}‹%r/%b› %m%u%c% %{$reset_color%}"
function vcs_prompt_info {
    echo "$(git_prompt_info)"
    #echo "${vcs_info_msg_0_}$(git_prompt_info)"
}


setopt PROMPT_SUBST
PROMPT='$user %{$fg_bold[blue]%}%2~ $(rsymbol) %{$reset_color%}'
RPS1='$(vcs_prompt_info)%{$reset_color%}$(venv)  %{$fg_bold[black]%}$(getla)%{$reset_color%}'
#RPS1='%{$reset_color%}$(venv)%{$reset_color%}  %{$fg_bold[black]%}$(getla)%{$reset_color%}'

export VIRTUAL_ENV_DISABLE_PROMPT=1
