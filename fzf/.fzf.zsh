# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "$HOME/.fzf/shell/key-bindings.zsh"

# ---------------------------My Settings--------------------------------

# Extended version of fzf-history-widget to:
#   - not use $BUFFER as query eagerly
#   - execute the selected command immediately by 'enter'
#   - put the selected command at prompt for edit by 'ctrl-e'
#   - put the query at command line by 'ctrl-q'
#   - and delete the selected command by 'ctrl-d' (not working at the moment!:)
extended-fzf-history-widget() {
  # Unlike bash, the '^R' binding in zsh (& fzf) doesn't clear prompt at first and whatever is at command line is used
  # as query for searching in history. It is often annoying and undesirable. So, let's disable this eager/greedy search!
  # We can do it either by clearing prompt at first or even better, by removing --query option from fzf command.
  # zle kill-whole-line  # removed '--query=${(qqq)LBUFFER}' from options, instead
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  local selected num
  local queries=$HOME/.extended_fzf_history_queries
  selected=( $(fc -rl 1 | perl -ne 'print if !$seen{(/^\s*[0-9]+\**\s+(.*)/, $1)}++' |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort,ctrl-z:ignore $FZF_CTRL_R_OPTS --history=$queries --bind left:previous-history,right:next-history --expect=ctrl-e,ctrl-q,ctrl-d --print-query +m" $(__fzfcmd)) )
  local ret=$?
  # --print-query puts query (if any) at the beginning of the fzf returned result
  # --expect puts expected key[s] (if pressed) between user query (if any) and fzf returned result
  # So, the $selected will be as follows: (query\s)?(expected-key\s)?(command-number\*?)\s(command)
  # ** Since there is no explicit separator in fzf output between query, expected-key and command, I used some criteria to
  # separate them. But since these criteria are not deterministic, sometimes when 'ctrl-e' is in query for example, this widget
  # won't work correctly because of the conflict between query and edit mode recognition criteria. Hence, this widget is
  # not foolproof but is guaranteed to work in most cases, probably near 100%, due to the nature of the queries and commands!
  local debug=$([[ $1 == "--debug" ]]; echo $(($? == 0)))
  (($debug)) && echo "--debug: \$selected:" \'$selected\'
  # delete duplicates, preserve latest at order and keep only the last 20 queries
  nl $queries | sort -k2 -k1,1nr | uniq -f1 | sort -n | cut -f2 | tail -20 | tee $queries > /dev/null
  if [ -n "$selected" ]; then
    local edit=0
    if [[ ${selected[*]} =~ ctrl-q ]]; then
      (($debug)) && echo "--debug: ctrl-q found"
      echo ${selected[@]/ctrl-q//} | cut -d/ -f1 | wc -w | tr -d ' ' | read index
      (($debug)) && echo "--debug: ctrl-q index:" \'$index\'
      zle reset-prompt
      echo ${selected[@]:0:$index} | read BUFFER
      CURSOR=$((#BUFFER))
      return $ret
    elif [[ ${selected[*]} =~ ctrl-e ]]; then
      (($debug)) && echo "--debug: ctrl-e found"
      edit=1
      echo ${selected[@]/ctrl-e//} | cut -d/ -f1 | wc -w | tr -d ' ' | read index
      (($debug)) && echo "--debug: ctrl-e index:" \'$index\'
      shift $((index+1)) selected
      (($debug)) && echo "--debug: \$selected (after $(($index+1)) shift):" \'$selected\'
    elif [[ ${selected[*]} =~ ctrl-d ]]; then
      (($debug)) && echo "--debug: ctrl-d found"
      echo ${selected[@]/ctrl-d//} | cut -d/ -f1 | wc -w | tr -d ' ' | read index
      (($debug)) && echo "--debug: ctrl-d index:" \'$index\'
      shift $((index+1)) selected
      (($debug)) && echo "--debug: \$selected (after $(($index+1)) shift):" \'$selected\'
      # history -d $(history | grep '${selected[@]}' | awk '{ print $1 }') && return $ret  # not working
      echo "deleting command not working at the moment!" && zle reset-prompt && return $ret
    else
      (($debug)) && echo "--debug: no expected key found"
      # TODO escape regex sensitive characters in $selected
      selected=(`echo ${selected[@]} | perl -pe 's|(.+?\s)?([0-9]+\*?\s.+)|\2|'`)  # remove query (if any)
      (($debug)) && echo "--debug: \$selected (after removing query):" \'$selected\'
    fi
    num=$selected[1]
    (($debug)) && echo "--debug: \$num:" \'$num\'
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
      [[ $edit == 1 ]] || zle accept-line
    fi
  fi
  zle reset-prompt
  return $ret
}
zle -N extended-fzf-history-widget
bindkey -M emacs '^[OB' extended-fzf-history-widget
bindkey -M vicmd '^[OB' extended-fzf-history-widget
bindkey -M viins '^[OB' extended-fzf-history-widget

# Rebind old action of down arrow (i.e. '^[OB') to another key like ctrl-down
bindkey '^[[1;5B' down-line-or-history
bindkey '^[[1;5A' up-line-or-history   # just for ease of use and less cognitive load!
# To use in future here are the steps to find 'down-line-or-history' and the code of ctrl-down to bind together
#bindkey -l
#bindkey -M main | fzf -m
#zle -la | fzf -m  # built-in widgets
#showkey -a  # shows key codes

# ----------------------------------------------------------------------

# tmux popup (-p) requires version >= 3.2
# Hard to type 'kill<tab><tab>'!
fkill() {
  local pid
  # TODO define a global variable for 'fzf-tmux -m -p ...' and use it in commands by eval
  pid=$(ps -ef | sed 1d | fzf-tmux -m -p --height 40% --layout reverse --info inline --border --preview 'echo {}' --preview-window down,3,wrap --min-height 15 "$@" | awk '{print $2}')
  [[ "x$pid" == "x" ]] && return
  echo 'kill -'${1:-9} $pid
  echo $pid | xargs kill -${1:-9}
  zle reset-prompt
}
zle -N fkill
#bindkey '^K' fkill  # overrides shell ctrl-k
bindkey 'kk' fkill

# ----------------------------------------------------------------------

# Easy(-peasy!) ps
fps() {
  local pss
  pss=$(ps -ef | sed 1d | fzf-tmux -m -p --height 40% --layout reverse --info inline --border --preview 'echo {}' --preview-window down,3,wrap --min-height 15 "$@")
  if [ ! -z "$pss" ]; then
    echo $pss
    zle reset-prompt
  fi
}
zle -N fps
bindkey '^P' fps
#bindkey 'pp' fps  # commented in favor of jpp

bindkey -s '^[^P' "ps axo pid,rss,comm --no-headers | fzf-tmux -p --reverse --preview 'sudo pwdx {1}; ps o args {1}; ps mu {1}'^M"
