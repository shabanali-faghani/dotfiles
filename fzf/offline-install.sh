#!/bin/bash

# Install fzf from current local installation on servers not connected to internet

# Local paths in ~/.fzf/.fzf.bash[zsh] must be changed to /usr/local/bin
set -x
HOST=$1
USER=${2:-root}
scp -r ~/.fzf $USER@$HOST:/usr/local/bin/
ssh $USER@$HOST 'echo "[ -f /usr/local/bin/.fzf/.fzf.bash ] && source /usr/local/bin/.fzf/.fzf.bash" >> /etc/bashrc'
# ssh $USER@$HOST 'echo "[ -f /usr/local/bin/.fzf/.fzf.zsh ] && source /usr/local/bin/.fzf/.fzf.zsh" >> /etc/zshrc'
ssh $USER@$HOST 'chmod +x /usr/local/bin/.fzf/bin/fzf'
ssh $USER@$HOST 'chmod +x /usr/local/bin/.fzf/bin/fzf-tmux'
