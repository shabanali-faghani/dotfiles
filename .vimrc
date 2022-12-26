" SETTINGS

" Disable compatibility with vi which can cause unexpected issues
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of file in use
filetype on

" Enable plugins and load plugin for the detected file type
filetype plugin on

" Load an indent file for the detected file type
filetype indent on

" Turn syntax highlighting on
syntax on

" Enable Mouse
set mouse=a

" Add numbers to each line on the left-hand side
set number
:highlight LineNr ctermfg=green term=bold cterm=NONE

" Highlight cursor line underneath the cursor horizontally
set cursorline

":highlight CursorLine ctermfg=Black ctermbg=LightGray cterm=bold guifg=white guibg=yellow gui=bold
":highlight Cursor ctermfg=Black ctermbg=Cyan cterm=bold guifg=white guibg=yellow gui=bold
":highlight CursorLine ctermbg=LightGray

"autocmd InsertEnter * highlight CursorLine guibg=#000050 guifg=fg
"autocmd InsertLeave * highlight CursorLine guibg=#004000 guifg=fg

" Highlight cursor line underneath the cursor vertically
"set cursorcolumn
"autocmd InsertEnter * highlight CursorColumn ctermfg=White ctermbg=Yellow cterm=bold guifg=white guibg=yellow gui=bold
"autocmd InsertLeave * highlight CursorColumn ctermfg=Black ctermbg=Yellow cterm=bold guifg=Black guibg=yellow gui=NONE

" Set shift width to 4 spaces
set shiftwidth=4

" Set tab width to 4 columns
set tabstop=4

" Use space characters instead of tabs
set expandtab

" Do not save backup files
set nobackup

" Do not let cursor scroll below or above N number of lines when scrolling
set scrolloff=10

" Do not wrap lines. Allow long lines to extend as far as the line goes
set nowrap

" While searching through a file incrementally highlight matching characters as you type
set incsearch

" Ignore capital letters during search
set ignorecase

" Override the ignorecase option if searching for capital letters
" This will allow you to search specifically for capital letters
set smartcase

" Show partial command you type in the last line of the screen
set showcmd

" Show the mode you are on the last line
set showmode

" Show matching words during a search
set showmatch

" Use highlighting when doing a search
set hlsearch

" Set the commands to save in history default number is 20
set history=1000

" Enable auto completion menu after pressing TAB
"set wildmenu

" Make wildmenu behave like similar to Bash completion
"set wildmode=list:longest

" There are certain files that we would never want to edit with Vim
" Wildmenu will ignore files with these extensions
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" Copy/Paste settings

" Use the clipboards of vim and win
set clipboard+=unnamed

" Paste from a windows or from vim
set paste

" Visual selection automatically copied to the clipboard
set go+=a


" MAPPINGS

" These require 'stty -ixon' to be sourced
inoremap <C-s> <esc>:w<cr>      " save files
nnoremap <C-s> :w<cr>
inoremap <C-q> <esc>:qa!<cr>    " quit discarding changes
nnoremap <C-q> :qa!<cr>
inoremap <C-x> <esc>:wq!<cr>    " save and exit
nnoremap <C-x> :wq!<cr>

" Comment current line
inoremap <C-c> <esc>0i#<space>
nnoremap <C-c> 0i#<space><esc>

" Delete current line
inoremap <C-d> <esc>dd
nnoremap <C-d> dd

" Duplicate current line
inoremap <C-S-d> <esc>yyp
nnoremap <C-S-d> yyp

" Efficient and fast search in help to find default key bindings
inoremap <F2> <esc>:help index<cr>:w ! nl -w4 \| fzf-tmux -p --height 40\% --layout reverse --info inline --border --preview 'echo {}' --preview-window down,3,wrap --min-height 15 "$@"<CR>:q<CR><CR>i
nnoremap <F2> :help index<cr>:w ! nl -w4 \| fzf-tmux -p --height 40\% --layout reverse --info inline --border --preview 'echo {}' --preview-window down,3,wrap --min-height 15 "$@"<CR>:q<CR><CR>

" The escape key is in the far corner of the keyboard but the letter 'j' is in the middle
inoremap jj <esc>

" Set the backslash as the leader key
"let mapleader= "\"

" Press \\ to jump back to the last cursor position
nnoremap <leader>\ ``

" Press the space bar to type the : character in command mode
nnoremap <space> :

" Pressing the letter o will open a new line below the current one
" Exit insert mode after creating a new line above or below the current line
"nnoremap o o<esc>
"nnoremap O O<esc>

" Center the cursor vertically when moving to the next word during a search
nnoremap n nzz
nnoremap N Nzz

" Yank from cursor to the end of line
nnoremap Y y$

" You can split the window in Vim by typing :split or :vsplit
" Navigate the split view easier by pressing CTRL+j, CTRL+k, CTRL+h, or CTRL+l
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Resize split windows using arrow keys by pressing:
" CTRL+UP, CTRL+DOWN, CTRL+LEFT, or CTRL+RIGHT
noremap <c-up> <c-w>+
noremap <c-down> <c-w>-
noremap <c-left> <c-w>>
noremap <c-right> <c-w><

" NERDTree specific mappings
" Map the F3 key to toggle NERDTree open and close
nnoremap <F3> :NERDTreeToggle<cr>

" Have nerdtree ignore certain files and directories
let NERDTreeIgnore=['\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pdf$', '\.pyc$', '\.odt$', '\.png$', '\.gif$', '\.db$']
