#!/bin/bash

# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "$HOME/.fzf/shell/key-bindings.bash"

# ---------------------------My Settings--------------------------------

# Bind Down arrow to '__fzf_history__'
bind '"\e[B": " \C-e\C-u\C-y\ey\C-u`__fzf_history__`\e\C-e\er\e^"'
# In some cases Down arrow code is '\eOB'
#bind '"\eOB": " \C-e\C-u\C-y\ey\C-u`__fzf_history__`\e\C-e\er\e^"'

# ----------------------------------------------------------------------

fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf-tmux -m -p --height 40% --layout reverse --info inline --border --preview 'echo {}' --preview-window down,3,wrap --min-height 15 "$@" | awk '{print $2}')
  if [ "x$pid" != "x" ]; then
    echo 'kill -'${1:-9} $pid
    echo $pid | xargs kill -${1:-9}
  fi
}
#bind -x '"\C-K":"fkill"'  # overrides shell ctrl-k
bind -x '"kk":"fkill"'

# ----------------------------------------------------------------------

fps() {
  local pss
  pss=$(ps -ef | sed 1d | fzf-tmux -m -p --height 40% --layout reverse --info inline --border --preview 'echo {}' --preview-window down,3,wrap --min-height 15 "$@")
  if [ ! -z "$pss" ]; then
    echo $pss
  fi
}
bind -x '"\C-P":"fps"'
#bind -x '"pp":"fps"'

# -------------------------Under Development----------------------------

# Modified version where you can press
#  - CTRL-O to open with `open` command,
#  - CTRL-E or Enter key to open with the $EDITOR
fo() {
  local out file key
  IFS=$'\n' out=($(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e))
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}

# fcd - fuzzy cd from anywhere
# ex: fcd word1 word2 ... (even part of a file name)
# zsh autoload function
fcd() {
  local file
  file="$(locate -Ai -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1)"
  if [[ -n $file ]]; then
    if [[ -d $file ]]; then
      cd -- $file
    else
      cd -- ${file:h}
    fi
  fi
}
