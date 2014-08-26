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
    user="%B%F{red}%m%f%b"
    symbol='#'
else
    user="%B%F{green}%m%f%b"
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
        time_left=`echo ${bat_data}|grep TimeRemaining|awk '{print $3}'`
    else
        return
    fi

    if [[ ("$ac_adapt" == "Yes") && ("$full" == "Yes") ]]
    then
        bat_charge=""
        bat_color=""
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
            bat_color="%{\e[5m%}%F{red}"
        fi
        if [[ $time_left -le 10 ]]
        then
            bat_color="%{\e[5m%}%K{red}"
        fi
    fi
    echo "%f%b$bat_color$bat_charge%f%b%k"
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
    # echo "  %B%F{cyan}$(basename ${VIRTUAL_ENV} | tr '[A-Z]' '[a-z]')%f%b"
    echo "  %B%F{cyan}$(basename ${VIRTUAL_ENV})%f%b"
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

function vcs_prompt_info {
    echo "$(git_prompt_info)"
    #echo "${vcs_info_msg_0_}$(git_prompt_info)"
}


setopt PROMPT_SUBST
PROMPT='%f%b$user %B%F{blue}%2~ $(rsymbol)%f%b '
RPROMPT='%f%b$(vcs_prompt_info)%f%b$(venv)  $(battery_charge)%f%b'
SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

export VIRTUAL_ENV_DISABLE_PROMPT=1
