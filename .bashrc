# current directory

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"


# additional scripts

# Usage: gg <options>
# Lists each branch and its commits ahead of trunk.
if [ -f $DIR/.git.bash ]; then
  . $DIR/.git.bash
fi


# git enhancements

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
} 
function proml {
  local        BLUE="\[\033[0;34m\]"
  local         RED="\[\033[0;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"
  local       GREEN="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local       WHITE="\[\033[1;37m\]"
  local  LIGHT_GRAY="\[\033[0;37m\]"
  case $TERM in
    xterm*)
    TITLEBAR='\[\033]0;\u@\h:\w\007\]'
    ;;
    *)
    TITLEBAR=""
    ;;
  esac 
  PS1="${TITLEBAR}\
  $GREEN[$GREEN\u@\h:\w$LIGHT_GRAY\$(parse_git_branch)$GREEN]\
  $GREEN\$ "
  PS2='> '
  PS4='+ '
}
proml
alias oneline="git log --pretty=oneline"
alias onelinedates="git log --pretty=format:'%h was %an, %ai, message: %s'"
alias grc="git rebase --continue"
