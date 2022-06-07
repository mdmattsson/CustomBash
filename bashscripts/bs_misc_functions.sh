#
#
# misc functions
#

pause_enter()
{
	read -p "Press [Enter] key to start backup..."
}

get_operating_system()
{
	case "$OSTYPE" in
	  solaris*) echo "SOLARIS" ;;
	  darwin*)  echo "OSX" ;; 
	  linux*)   echo "LINUX" ;;
	  bsd*)     echo "BSD" ;;
	  msys*)    echo "WINDOWS" ;;
	  cygwin*)  echo "WINDOWS" ;;
	  *)        echo "unknown: $OSTYPE" ;;
	esac
}

#!/usr/bin/env bash

SLEEP_DURATION=${SLEEP_DURATION:=1}  # default to 1 second, use to speed up tests

progress-bar() {
  local duration
  local columns
  local space_available
  local fit_to_screen  
  local space_reserved

  space_reserved=6   # reserved width for the percentage value
  duration=${1}
  columns=$(tput cols)
  space_available=$(( columns-space_reserved ))

  if (( duration < space_available )); then 
  	fit_to_screen=1; 
  else 
    fit_to_screen=$(( duration / space_available )); 
    fit_to_screen=$((fit_to_screen+1)); 
  fi

  already_done() { for ((done=0; done<(elapsed / fit_to_screen) ; done=done+1 )); do printf "▇"; done }
  remaining() { for (( remain=(elapsed/fit_to_screen) ; remain<(duration/fit_to_screen) ; remain=remain+1 )); do printf " "; done }
  percentage() { printf "| %s%%" $(( ((elapsed)*100)/(duration)*100/100 )); }
  clean_line() { printf "\r"; }

  for (( elapsed=1; elapsed<=duration; elapsed=elapsed+1 )); do
      already_done; remaining; percentage
      sleep "$SLEEP_DURATION"
      clean_line
  done
  clean_line
}


download()
{
	local thesource="$1"
	local thetarget="$2"
	[[ -f "$2" ]] && return
	
	local theos=$(get_operating_system);
	if [[ "$theos" == "WINDOWS" ]]; then
		curl --progress-bar -L ${thesource} -o ${thetarget}
		
	else
		wget ${thesource} -O ${thetarget}
	fi
}

