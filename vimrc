" Sensible setup
set nocompatible
filetype plugin on

" Install Vim Plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
  \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Plugins
call plug#begin()
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'bfrg/vim-cpp-modern'

Plug 'corntrace/bufexplorer'

Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_max_files = 0
" map <leader>mr :CtrlPMRUFiles<CR>
set wildignore+=*.class,*/target/*,*.swp,*/assembly/*,*.backup,
    \*.pyc,*.data,*.train,*.test,*.pdf,*.tar,*.tgz,*/CMakeFiles/*,*/debug/googletest-src/*,
    \*/release/googletest-src/*,*.dia,*.o,*.a

Plug 'tomtom/tcomment_vim'
nnoremap // :TComment<CR>
vnoremap // :TComment<CR>


" Plug 'python-mode/python-mode'
" let g:pymode_warnings=1
" let g:pymode_folding=0
" let g:pymode_doc=0
" let g:pymode_virtualenv=0
" let g:pymode_lint=1
" let g:pymode_lint_on_write=1
" let g:pymode_lint_unmodified=0
" let g:pymode_virtualenv_path = "/home/ubuntu/miniconda3/envs/inferline"
" let g:pymode_rope=0
" let g:pymode_doc=0
" let g:pymode_python = 'python3'
" let g:pymode_lint_ignore = ["E402", "C901", "W605", "E501", "E0401", "C0411", "C0302"]
" " let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'pylint', 'mccabe']
" let g:pymode_lint_checkers = ['pylint']
" let pymode_breakpoint_bind = ''


" let g:pymode_virtualenv=0
" let g:pymode_rope_complete_on_dot=0
" let g:pymode_rope_completion = 0
" " let g:pymode_lint_on_fly=0
" let g:pymode_rope_lookup_project=0
" let g:pymode_options_max_line_length=100
" " let g:pymode_lint_on_write = 1
" let g:pymode_lint_ignore = ["E402", "C901", "W605", "E501"]
" let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'pylint', 'mccabe']
" let pymode_breakpoint_bind = ''
" let g:pymode_virtualenv_path = "/home/ubuntu/miniconda3/envs/inferline"
" let g:pymode_syntax = 0


" Plug 'altercation/vim-colors-solarized'
Plug 'JulioJu/neovim-qt-colors-solarized-truecolor-only'



call plug#end()


map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <leader>h <C-W>h
map <C-l> <C-W>l
map <leader>= <C-W>=


" Toggle Paste Mode
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction


filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=2
" when indenting with '>', use 4 spaces width
set shiftwidth=2
" On pressing tab, insert 4 spaces
set expandtab

let g:enable_local_swap_dirs = 1
let mapleader = ","

nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <leader>nh :noh<CR>
nnoremap <leader>o o<ESC>k
nnoremap <leader>O O<ESC>j
nnoremap <leader>re :e $MYVIMRC<cr>
nnoremap <leader>rs :source $MYVIMRC<cr>


syntax enable

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set background=dark " or dark
colorscheme solarized_nvimqt
" set background=light
" colorscheme solarized

set termguicolors

set hlsearch
set number
set ignorecase
set smartcase			" Do case sensitive matching when there's a capital letter
set incsearch                   " Do incremental searching
set textwidth=0
set ruler                       " Set the ruler in the bottom right corner
set showmode                    " Show the mode you're currently in
set showmatch                   " Show matching braces / brackets
set matchtime=5
set matchpairs+=<:> 
set number                      " Set line numbers
set title                       " Let vim change my tab/window title
set laststatus=2                " Always display the last status
set autoindent
set showcmd                     " Show leader key when pressed
set novisualbell
set noerrorbells
set t_vb=
set splitbelow
set splitright
set nowrap
set hidden
set clipboard+=unnamedplus
au BufEnter * silent! lcd %:p:h

