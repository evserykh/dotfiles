# Ruby Version Manager
if [ -s "$HOME/.rvm/scripts/rvm" ]; then
  source "$HOME/.rvm/scripts/rvm"

  export PATH=$PATH:$HOME/.rvm/bin
fi

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
  # Shell is non-interactive.  Be done now!
  return
fi

[[ -f ~/.bash_profile ]] && . ~/.bash_profile
