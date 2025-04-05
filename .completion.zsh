# https://github.com/Aloxaf/fzf-tab/wiki/Configuration

# -------------------------------------------------------------------------

# Bind ctrl-space to fzf-tab-completion
bindkey -M emacs '^@'  fzf-tab-complete
bindkey -M viins '^@'  fzf-tab-complete

# To unbind tab key comment/delete the following lines in fzf-tab/fzf-tab.zsh
#  bindkey -M emacs '^I'  fzf-tab-complete
#  bindkey -M viins '^I'  fzf-tab-complete

# ... or keep both, or vice versa! Each of which has its own pros and cons!

# -------------------------------------------------------------------------

#zstyle ':fzf-tab:*' fzf-command fzf            # default
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup  # use tmux-popup instead

zstyle ':completion:*:descriptions' format '[%d]' # for using '$group'

# bindkey '^Xh' _complete_help

# -------------------------------------------------------------------------

# My default settings

# default preview settings
#zstyle ':fzf-tab:*' fzf-flags --preview-window=right:60:wrap  --bind "page-down:preview-page-down,page-up:preview-page-up,q:abort" # preview-up/down works by default with ctrl-up/down
zstyle ':fzf-tab:*' fzf-flags --preview-window=right:60  --bind "page-down:preview-page-down,page-up:preview-page-up,q:abort" # preview-up/down works by default with ctrl-up/down

# default right and bottom padding of the tmux popup window
zstyle ':fzf-tab:*' popup-pad 60 0

# default minimal size of the popup window
zstyle ':fzf-tab:*' popup-min-size 100 8

# -------------------------------------------------------------------------

# cd
#zstyle ':fzf-tab:complete:cd:*' fzf-preview 'sudo exa -1 --color=always $realpath'
#zstyle ':fzf-tab:complete:cd:*' fzf-preview 'sudo ls -1 --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'sudo exa --color=always --tree --level=1 $realpath'
#zstyle ':fzf-tab:complete:cd:*' fzf-preview 'sudo exa --color=always --tree --level=2 $realpath'
#zstyle ':fzf-tab:complete:cd:*' fzf-preview 'sudo exa --long --color=always --tree --level=2 $realpath'
#zstyle ':fzf-tab:complete:cd:*' fzf-flags --preview-window=right:70:wrap  --bind "j:down,k:up,alt-j:preview-down,alt-k:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up,q:abort"

# systemctl
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
zstyle ':fzf-tab:complete:systemctl-*:*' popup-pad 80 0

# commands
zstyle ':fzf-tab:complete:-command-:*' fzf-preview 'tldr $word 2> /dev/null'
# zstyle ':fzf-tab:complete:-command-:*' fzf-preview '(out=$(tldr "$word") 2>/dev/null && echo $out) || (out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out) || echo "${(P)word}"'

# sudo
zstyle ':fzf-tab:complete:sudo:*' fzf-preview 'tldr $word 2> /dev/null'

# tldr
zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr $word'

# diff
zstyle ':fzf-tab:complete:diff:*' popup-min-size 120 12

# kill|ps
# give a preview of commandline arguments when completing kill or ps
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap
