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
            print -Pn "\e]2;${1:q} — %2~\a"
        }
esac

#=========
autoload -z colors; colors

if [ $UID -eq 0 ]; then
    user="%B%F{red}%m%{$reset_color%}"
    symbol='#'
else
    user="%B%F{green}%m%{$reset_color%}"
    symbol='$'
fi

function battery_charge {
    if [[ `uname` == 'Darwin' ]]
    then
        bat_data=`ioreg -rc AppleSmartBattery`
        ac_adapt=`echo ${bat_data}|grep ExternalConnected| awk '{print $3}'`
        charging=`echo ${bat_data}|grep IsCharging|awk '{print $3}'`
        full=`echo ${bat_data}|grep FullyCharged|awk '{print $3}'`
        bat_percent=`echo ${bat_data} | awk '$1~/Capacity/{c[$1]=$3} END{OFMT="%.0f"; max=c["\"MaxCapacity\""]; print (max>0? 100*c["\"CurrentCapacity\""]/max: "?")}'`
    else
        return
    fi

    if [[ ("$ac_adapt" == "Yes") && ("$full" == "Yes") ]]
    then
        bat_charge=""
        bat_color=""
        # return
    elif [[ "$ac_adapt" == "Yes" && "$charging" == "Yes" ]]
    then
        bat_charge=`echo -e '\U26A1\UFE0E'`
        bat_color="%B%F{black}"
    else

        if [[ $bat_percent -ge 80 ]]
        then
            bat_charge=`echo -e '\U0025CF\U0025CF\U0025CF'`
            bat_color="%F{green}"
        elif [[ $bat_percent -ge 60 ]]
        then
            bat_charge=`echo -e '\U0025CF\U0025CF\U0025CB'`
            bat_color="%F{yellow}"
        elif [[ $bat_percent -ge 40 ]]
        then
            bat_charge=`echo -e '\U0025CF\U0025CB\U0025CB'`
            bat_color="%F{yellow}"
        elif [[ $bat_percent -ge 20 ]]
        then
            bat_charge=`echo -e '\U0025CB\U0025CB\U0025CB'`
            bat_color="%F{red}"
        else
            bat_charge=`echo -e '\U0025CB\U0025CB\U0025CB'`
            bat_color="\e[5m%F{red}"
        fi
    fi
    echo "%{$bat_color%}$bat_charge%{$reset_color%}"
    # U+26A1⚡
    return
}

function rsymbol {
    git branch >/dev/null 2>/dev/null && echo "%B%F{yellow}±" && return
    #hg root >/dev/null 2>/dev/null && echo "%B%F{yellow}☿" && return
    [ -d .svn ] && echo "%B%F{yellow]%}⨰" && return
    echo $symbol
}

function venv {
    [ $VIRTUAL_ENV ] || return
    # echo "  %B%F{cyan}$(basename ${VIRTUAL_ENV} | tr '[A-Z]' '[a-z]')%{$reset_color%}"
    echo "  %B%F{cyan}$(basename ${VIRTUAL_ENV})%{$reset_color%}"
}

function getla {
    if [[ "$VENDOR" == "apple" || "$VENDOR" == "portbld" ]]; then
        uptime | cut -d ":" -f 4 | cut -d ' ' -f 2
        return
    fi
    if [[ "$VENDOR" == "apple" || "$VENDOR" == "portbld" ]]; then
        uptime | cut -d ":" -f 3 | cut -d ',' -f 2
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
#zstyle ':vcs_info:git*' formats "%B%F{yellow}‹%r/%b› %m%u%c% %{$reset_color%}"
function vcs_prompt_info {
    echo "$(git_prompt_info)"
    #echo "${vcs_info_msg_0_}$(git_prompt_info)"
}


setopt PROMPT_SUBST
PROMPT='%{$reset_color%}$user %B%F{blue}%2~ $(rsymbol) %{$reset_color%}'
RPROMPT='%{$reset_color%}$(vcs_prompt_info)%{$reset_color%}$(venv)  $(battery_charge)%{$reset_color%}'
SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

export VIRTUAL_ENV_DISABLE_PROMPT=1
