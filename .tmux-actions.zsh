# Inspired by Intellij's great 'Actions' feature (only tested for some simple commands)
actions() {
  [[ -f $HOME/.tmux_actions_history ]] || touch $HOME/.tmux_actions_history
  lastquery=$( tail -n 1 $HOME/.tmux_actions_history )
  #command=$(tmux list-keys -T | fzf-tmux -p --reverse --query "$lastquery" --history=$HOME/.tmux_actions_history)
  command=$(tmux list-keys -T | fzf --reverse --info inline --border --preview 'echo {}' --preview-window down,4,wrap --min-height 15 "$@" --query "$lastquery" --history=$HOME/.tmux_actions_history --bind left:previous-history,right:next-history)
  if [ "x$command" = "x" ]; then
    return
  fi
  # TODO remove duplicates from $HOME/.tmux_actions_history
  echo tmux ${command:49}
  echo ${command:49} | xargs tmux
  zle reset-prompt
}
zle -N actions
# bindkey '^[^A' actions  # bind to this from .tmux.conf
