#
#
#
#
export PATH="$PATH:$HOME/bashscripts/oh-my-posh/bin"
eval "$(oh-my-posh --init --shell bash --config $HOME/bashscripts/oh-my-posh/themes/michael.omp.json)"

# -----------------------------------------------------------------------------
# constants
# -----------------------------------------------------------------------------
# if using colors with echo, make sure to invoke with "echo -e"
readonly COLOR_NONE="\033[0m"
readonly COLOR_NORMAL="\033[0;37m"
readonly COLOR_LGREEN="\033[1;32m"
readonly COLOR_GREEN="\033[0;32m"
readonly COLOR_LRED="\033[1;31m"
readonly COLOR_RED="\033[0;31m"
readonly COLOR_YELLOW="\033[1;33m"
readonly COLOR_CYAN="\033[0;36m"
readonly COLOR_DARKGRAY="\033[1;30m"

STATUS_PASSED=$(printf "${COLOR_GREEN}%s${COLOR_NONE}" "PASSED")
readonly STATUS_PASSED
STATUS_FAILED=$(printf "${COLOR_RED}%s${COLOR_NONE}"   "FAILED")
readonly STATUS_FAILED

readonly LOG_LEVEL_DEBUG="DEBUG"
readonly LOG_LEVEL_INFO="INFO"
readonly LOG_LEVEL_WARN="WARN"
readonly LOG_LEVEL_ERROR="ERROR"



source ~/bashscripts/bs_aliases.sh
source ~/bashscripts/bs_ssh_functions.sh
#source ~/bashscripts/bs_start_ssh_agent.sh
source ~/bashscripts/bs_misc_functions.sh
source ~/bashscripts/bs_git_functions.sh
source ~/bashscripts/bs_prompt.sh
export GIT_PS1_SHOWCOLORHINTS=true # Option for git-prompt.sh to show branch name in color


# export GIT_PS1_SHOWCOLORHINTS=true # Option for git-prompt.sh to show branch name in color
git config --global color.ui true
# git config color.status.changed "cyan normal bold"
# git config color.status.header "white normal dim"
# git config color.status.changed blue
# git config color.status.untracked magenta

# git config color.status.added "cyan normal bold" # git config color.status.header "white normal"
# git config color.status.changed "cyan normal bold" 
# git config color.status.untracked "cyan normal bold"
# git config color.diff.old "red normal bold"
# git config color.diff.new "green normal bold"

#. ~/bashscripts/git-flow-completion.sh

#https://stackoverflow.com/questions/1057564/pretty-git-branch-graphs
#checkout .gitconfig for got aliases

# source $HOME/bashscripts/bash-git-prompt/git_remote_check.sh
# source $HOME/bashscripts/bash-git-prompt/git_prompt.sh

source $HOME/bashscripts/bs_git-flow-completion.sh


echo "Welcome $(whoami)"
echo "'repo'=create repo,  'brepo'=create & build remake po, 'rebuild'=rebuilds cmake'"
