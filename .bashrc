
[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/fzf/.fzf.bash ] && source ~/fzf/.fzf.bash

stty -ixon

# ----------------------------------------------------------------------

# These are required for some distros/versions

# Increase history
HISTSIZE=20000

# Remove duplicate commands while preserving order by Schwartzian-Transform
nl ~/.bash_history | sort -k2 -k 1,1nr | uniq -f1 | sort -n | cut -f2 > ~/.bash_history_temp
mv -f ~/.bash_history_temp ~/.bash_history

HISTCONTROL=ignoreboth:erasedups
#HISTCONTROL=ignoredups:erasedups
#shopt -s histappend
#PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"
