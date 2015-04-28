syntax on
let g:enable_local_swap_dirs = 1
:let mapleader = ","

" From gmarik/vimrc
filetype off
set nocompatible
set history=256
set autowrite
set autoread
set timeoutlen=500
" Only in Vim 7.3.74+
set clipboard+=unnamed      " Yank to the X window clipboard
set hidden
set hlsearch                    " Highlight previous search results
set ignorecase
set smartcase			" Do case sensitive matching when there's a capital letter
set incsearch                   " Do incremental searching
set nowrap
set textwidth=0
set wildmode=longest,list,full  " Completion modes for wildcard expansion
set backspace=indent,eol,start
set ruler                       " Set the ruler in the bottom right corner
set expandtab                   " Force this, although it's in google.vim
set smarttab
set tabstop=2
set shiftwidth=2                " Force this, although it's in google.vim
set softtabstop=2               " Make tabs act like spaces for editing ops
set showmode                    " Show the mode you're currently in
set showmatch                   " Show matching braces / brackets
set matchtime=5
set number                      " Set line numbers
set title                       " Let vim change my tab/window title
set laststatus=2                " Always display the last status
set autoindent
set cindent
set showcmd                     " Show leader key when pressed
set tags=tags;~/code

set novisualbell
set noerrorbells
set t_vb=
autocmd GUIEnter * set visualbell t_vb=
set shortmess=atI
set nolist " Display unprintable characters f12 - switches
set listchars=tab:·\ ,eol:¶,trail:·,extends:»,precedes:« " Unprintable chars mapping

set foldenable " Turn on folding
set foldmethod=marker " Fold on the marker
set foldlevel=100 " Don't autofold anything (but I can still fold manually)
set foldopen=block,hor,mark,percent,quickfix,tag " what movements open folds 

set mouse-=a   " Disable mouse
set mousehide  " Hide mouse after chars typed

set splitbelow
set splitright
set guifont=Inconsolata:h12
 

 " Automatically change the working directory to the current one
au BufEnter * silent! lcd %:p:h

"Auto commands
au BufRead,BufNewFile {Gemfile,Rakefile,Capfile,*.rake,config.ru}     set ft=ruby
au BufRead,BufNewFile {*.md,*.mkd,*.markdown}                         set ft=markdown
au BufRead,BufNewFile {COMMIT_EDITMSG}                                set ft=gitcommit

au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal g'\"" | endif " restore position in file

" For Split screen users: higlight the status line of the active window
hi StatusLine ctermfg=Cyan


" C-indenting options for java:
" j1: Set java-indenting
" +2s: Indenting a continuing line by 2 * shiftwidth
" l1: Align brackets with the case label
au BufRead,BufNewFile *.java setl cinoptions=j1,+2s,l1
au BufRead,BufNewFile *.java set tabstop=4
au BufRead,BufNewFile *.java set shiftwidth=4
au BufRead,BufNewFile *.java set softtabstop=4


au BufRead,BufNewFile *.scala setl cinoptions=j1,+2s,l1
au BufRead,BufNewFile *.scala set tabstop=2
au BufRead,BufNewFile *.scala set shiftwidth=2
au BufRead,BufNewFile *.scala set softtabstop=2

au BufRead,BufNewFile *.tex set wrap linebreak nolist textwidth=0 wrapmargin=0
au BufRead,BufNewFile *.tex nnoremap j gj
au BufRead,BufNewFile *.tex nnoremap k gk
au BufRead,BufNewFile *.tex vnoremap j gj
au BufRead,BufNewFile *.tex vnoremap k gk

au BufRead,BufNewFile *.md set wrap linebreak nolist textwidth=0 wrapmargin=0
au BufRead,BufNewFile *.md nnoremap j gj
au BufRead,BufNewFile *.md nnoremap k gk
au BufRead,BufNewFile *.md vnoremap j gj
au BufRead,BufNewFile *.md vnoremap k gk

" Key mappings " {{{
" nnoremap <silent> <leader>rs :source ~/.vimrc<CR>
nnoremap <silent> <leader>rs :source $MYVIMRC<CR>
" nnoremap <silent> <leader>rt :tabnew ~/.vimrc<CR>
nnoremap <silent> <leader>rt :tabnew $MYVIMRC<CR>
nnoremap <silent> <leader>re :e $MYVIMRC<CR>
nnoremap <silent> <leader>rd :e ~/.vim/ <CR>

" Tabs 
nnoremap <silent> <leader>[ :tabprev<CR>
nnoremap <silent> <leader>] :tabnext<CR>
" Duplication 
vnoremap <silent> <leader>= yP
nnoremap <silent> <leader>= YP
" Buffers
nnoremap <silent> <leader>- :bd<CR>
" Split line(opposite to S-J joining line) 
nnoremap <silent> <C-J> gEa<CR><ESC>ew 
" nnoremap <silent> <Leader>b :make<CR>
"
" nnoremap <silent> <Leader>o :make open<CR>

" Control+S and Control+Q are flow-control characters: disable them in your terminal settings.
" $ stty -ixon -ixoff
noremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>

" Leader mappings
" nnoremap <leader>m a<Space>{<CR><CR>}<ESC>ki
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <leader>nh :noh<CR>


" Move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
map <leader>= <C-W>=

" Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-sleuth'
" Plugin 'Valloric/YouCompleteMe' " Couldn't get to work
Plugin 'kien/ctrlp.vim'
let g:ctrlp_max_files = 0
" map <leader>mr :CtrlPMRUFiles<CR>
set wildignore+=*.class,*.swp,*/target/*,*/assembly/*,*.backup,*.html,*.pyc
" let g:ctrlp_custom_ignore = '*.html'

Plugin 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
Plugin 'scrooloose/syntastic'
let g:syntastic_scala_checkers=['scalac']
let g:syntastic_mode_map = { 'mode': 'active','active_filetypes': [], 'passive_filetypes': ['scala', 'java'] }
Plugin 'altercation/vim-colors-solarized'

Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'Shougo/neocomplcache'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'corntrace/bufexplorer'
Plugin 'vim-scripts/xptemplate'
Plugin 'derekwyatt/vim-scala'
Plugin 'L9'
Plugin 'LustyJuggler'
Plugin '29decibel/codeschool-vim-theme'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
" let g:easytags_async=1
let g:easytags_async=0

Plugin 'FuzzyFinder'
Plugin 'tpope/vim-fugitive'
Plugin 'git.zip'
" Plugin 'majutsushi/tagbar'
" nnoremap <silent> <Leader>b :TagbarToggle<CR>
Plugin 'scratch.vim'
Plugin 'ZoomWin'
Plugin 'TeX-PDF'
Plugin 'rust-lang/rust.vim'
" noremap <leader>o :ZoomWin<CR>
vnoremap <leader>o <C-C>:ZoomWin<CR>
inoremap <leader>o <C-O>:ZoomWin<CR>
noremap <C-W>+o :ZoomWin<CR>
 
Plugin 'Align'
Plugin 'SuperTab'
Plugin 'repeat.vim'
Plugin 'surround.vim'
" Plugin 'git://git.code.sf.net/p/vim-latex/vim-latex'
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'

" tComment
Plugin 'tomtom/tcomment_vim'
nnoremap // :TComment<CR>
vnoremap // :TComment<CR>

Plugin 'Mark--Karkat'

Plugin 'solarnz/thrift.vim'

Plugin 'fatih/vim-go'
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)

" Command-T
" Plugin "git://git.wincent.com/command-t.git"
" let g:CommandTMatchWindowAtTop=1 " show window at top


call vundle#end()

call tcomment#DefineType('java',             '// %s '         )

syntax enable
set background=dark
colorscheme solarized

filetype plugin indent on


