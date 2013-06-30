# .git.bash

# Configuration
export GIT_REVERSE=false

# Usage: glhf <branch>(HEAD)
# Lists and describes all commits on <branch> ahead of trunk.
function glhf {
  local flags=''
  if $GIT_REVERSE; then
    flags='--reverse'
  fi
  git log $flags --pretty=format:'%Cred%h%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --stat=150,150 trunk..$1 2>/dev/null
}

# Usage: gg <options>
# Lists each branch and its commits ahead of trunk.
function gg {
  local GRAY="\033[1;30m"
  local YELLOW="\033[1;33m"
  local AUTO="\033[0m"

  # Parse options.
  local showhidden=false
  args=`getopt a $*`
  set -- $args
  for i; do
    if [ "$i" = '-a' ]; then
      showhidden=true
    fi
  done

  local flags=''
  if $GIT_REVERSE; then
    flags='--reverse'
  fi

  local tmpdir="$(mktemp -d gg.XXXX)" # had to add the name template here
  local active="$(_gitbr)"
  (
    for branch in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
      if ! $showhidden && [ ${branch:0:1} = '_' ]; then
        continue
      fi

      # Run each git command in parallel subshells because git can be slow.
      local tmpfile0="${tmpdir}/${branch}-0.tmp"
      local tmpfile1="${tmpdir}/${branch}-1.tmp"
      (
        local status="$($branch)"

        # Show an asterisk beside the active branch.
        if [ "$active" = "$branch" ]; then
          printf '* ' > $tmpfile0
        else
          printf '  ' > $tmpfile0
        fi

        echo -e "${YELLOW}$branch ${GRAY}$status${AUTO}" >> $tmpfile0
      ) &
      (
        local commits=`git log ${flags} --pretty=format:'%Cred%h%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit trunk..${branch}`

        # Hide commits if there are more than 100 to show.
        if [ `echo "$commits" | wc -l` -gt 100 ]; then
          commits="${GRAY}(More than 100 commits.)${AUTO}"
        fi

        if [ -n "$commits" ]; then
          # Truncate long lines (subject should be <70 characters anyway).
          echo -e "$commits" | sed "s/^/    /" | cut -c -130 >> $tmpfile1
        fi
      ) &
    done

    wait
  ) 2>/dev/null

  for file in `ls $tmpdir`; do
    cat $tmpdir/$file
  done
  rm -r $tmpdir
}

# Internal, usage: _gitbr
# Prints the name of the active branch.
function _gitbr {
  git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/'
}

# Internal, usage: _gitbehind <branch>
# Prints [behind _] as appropriate.
function _gitbehind {
  local behind=`git rev-list "$1..trunk" | wc -l`

  test $[ $behind ] -gt 0 && {
    printf "[behind $behind]"
  }
}

