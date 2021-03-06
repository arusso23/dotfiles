POWERLINE="$(which powerline-go)"

function __ps1_rc() {
  if [ $? -eq 0 ]; then
    PROMPT_ZERO_RC=${PROMPT_ZERO_RC:-[✓]}
    echo -en "$BGreen${PROMPT_ZERO_RC}$Color_Off"
  else
    PROMPT_NONZERO_RC=${PROMPT_NONZERO_RC:-[✘]}
    echo -en "$BRed${PROMPT_ZERO_RC}$Color_Off"
  fi
}

function __ps1_git_prompt() {
  [[ $(:binexists git) -eq 1 ]] || return
  local git_status="`git status -unormal 2>&1`"
  if ! [[ "$git_status" =~ (N|n)ot\ a\ git\ repo ]]; then
    if [[ "$git_status" =~ nothing\ to\ commit ]]; then
      local Color_On=$Green
    elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
      local Color_On=$Purple
    else
      local Color_On=$Red
    fi

    if [[ "$git_status" =~ On\ branch\ ([^[:space:]]+) ]]; then
      branch=${BASH_REMATCH[1]}
    else
      # Detached HEAD. (branch=HEAD is a faster alternative.)
      branch="(`git describe --all --contains --abbrev=4 HEAD 2> /dev/null || echo HEAD`)"
    fi

    echo -en "$Color_On[$branch]$Color_Off "
  fi
}

function __ps1_battery_percentage() {
  #PROMPT_BATTERY_ICON="🔋 "
  [[ "$PLATFORM" != "OSX" ]] && return
  local _has_battery=$(ioreg -c AppleSmartBattery | grep BatteryInstalled | awk '{print $5}'|tr [:upper:] [:lower:])
  if [ "$_has_battery" == "yes" ] && [[ $PROMPT_BATTERY_STATUS -eq 1 ]]; then
    local _battery_percentage=$(ioreg -c AppleSmartBattery | grep Capacity | grep -v Legacy| tr '\n' ' | ' | awk '{printf("%.0f%%", $10/$15 * 100)}')
    echo -en "${PROMPT_BATTERY_ICON}${_battery_percentage} "
  fi
}

function __get_ps1_prompt() {
  RC=$(__ps1_rc)
  # setup our prompt
  if [[ $PROMPT_MINIMAL -eq 1 ]]; then
    PS1="\$ "
  elif [[ $PROMPT_SIMPLE -eq 1 ]]; then
    PS1="\u@\h:\W \$ "
  elif [[ $PROMPT_POWERLINE -ne 0 ]] && [ -x "$POWERLINE" ]; then
    PS1="$("$POWERLINE" -numeric-exit-codes -error $? -colorize-hostname -path-aliases ${PROMPT_POWERLINE_ALIASES} | sed 's/\s\+$/\ /')"
  else
    PS1="$(__ps1_battery_percentage)${RC} \u@\h:\W $(__ps1_git_prompt)\$ "
  fi

  # defined in preexec.sh
  PostCommand
}

PROMPT_COMMAND=__get_ps1_prompt
