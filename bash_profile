# Configure colors, if available.
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  c_reset='\[\e[0m\]'
  c_user='\[\033[01;33m\]'
  c_path='\[\033[01;34m\]'
  c_git_clean='\[\e[0;36m\]'
  c_git_dirty='\[\e[0;35m\]'
else
  c_reset=
  c_user=
  c_path=
  c_git_clean=
  c_git_dirty=
fi

# Show current branch if we are in git repo
git_prompt()
{
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi

  git_branch=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')

  if git diff --quiet 2>/dev/null >&2; then
    git_color="$c_git_clean"
  else
    git_color="$c_git_dirty"
  fi

  echo " $git_color[$git_branch]${c_reset}"
}

# Thy holy prompt.
export PROMPT_COMMAND='PS1="${c_user}\u@\h${c_path} \w${c_reset}$(git_prompt)${c_path} $ ${c_reset}\[\e[0m\]"'

if [ "$TERM_PROGRAM" == "Apple_Terminal" ] && [ -z "$INSIDE_EMACS" ]; then
  update_terminal_cwd() {
    # Identify the directory using a "file:" scheme URL,
    # including the host name to disambiguate local vs.
    # remote connections. Percent-escape spaces.
    local SEARCH=' '
    local REPLACE='%20'
    local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
    printf '\e]7;%s\a' "$PWD_URL"
  }

  export PROMPT_COMMAND='update_terminal_cwd; PS1="${c_user}\u@\h${c_path} \w${c_reset}$(git_prompt)${c_path} $ ${c_reset}\[\e[0m\]"'
fi

alias grep='grep --color=auto'

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  alias ls="ls --color=auto"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  alias ls="ls -G"
fi

export HISTSIZE=500000
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL='ignoreboth:erasedups'
export HISTIGNORE='cd:ls:mc'

shopt -s cdspell cmdhist histappend

# Homebrew
export PATH="/usr/local/bin:${PATH}"

# Bash-completion
if [ $(which brew) ]; then
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi
fi
