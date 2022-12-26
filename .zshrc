# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

#ZSH_THEME="robbyrussell"
ZSH_THEME="jreese"

plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# ----------------------------------------------------------------------

[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/fzf/.fzf.zsh ] && source ~/fzf/.fzf.zsh

# https://github.com/Aloxaf/fzf-tab
source ~/fzf-tab/fzf-tab.plugin.zsh
[ -f ~/.completion.zsh ] && source ~/.completion.zsh

# ----------------------------------------------------------------------

sudo-it() {
  prefix="sudo"
  BUFFER="$prefix $BUFFER"
  CURSOR=$(($CURSOR + $#prefix + 1))
}
zle -N sudo-it
bindkey "^S" sudo-it

comment-it() {    # TODO change this to toggle-comment to be able both comment and uncomment
  BUFFER="# $BUFFER"
  CURSOR=$(($#BUFFER))
  zle accept-line
}
zle -N comment-it
bindkey "^[#" comment-it  # alt-# (alt-shift-#/3)
bindkey "^[3" comment-it  # alt-3 (easy alt-#)


bindkey "^Q" clear-screen
bindkey -s '^W' 'ls -lh^M'
bindkey -s '^[^W' 'ls -lah^M'
bindkey -s '^[^S' 'sudo su -^M'
bindkey -s '^[^I' 'sudo apt install '
bindkey -s '^[t' 'tmux new-session -A -s default^M'

# ----------------------------------------------------------------------

stty -ixon

#PROMPT=${PROMPT/\%c/\%~}
#RPROMPT="%S%F{blue}%T%f%s"
