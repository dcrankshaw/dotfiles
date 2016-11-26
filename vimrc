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
autocmd GUIEnter * set vb t_vb=
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
set guifont=Inconsolata:h16
" set guifont=Inconsolata\ for\ Powerline:h12
" let g:Powerline_symbols = 'fancy'
set encoding=utf-8
set t_Co=256
set fillchars+=stl:\ ,stlnc:\
" set term=xterm-256color
" set termencoding=utf-8
 

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

function! TexFormatExpr(start, end)
    silent execute a:start.','.a:end.'s/[.!?]\zs /\r/g'
endfunction

au BufRead,BufNewFile *.tex set formatexpr=TexFormatExpr(v:lnum,v:lnum+v:count-1)

au BufRead,BufNewFile *.md set wrap linebreak nolist textwidth=0 wrapmargin=0
au BufRead,BufNewFile *.md nnoremap j gj
au BufRead,BufNewFile *.md nnoremap k gk
au BufRead,BufNewFile *.md vnoremap j gj
au BufRead,BufNewFile *.md vnoremap k gk

" au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab autoindent fileformat=unix

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
nnoremap <leader>o o<ESC>k
nnoremap <leader>O O<ESC>j


" Move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <leader>h <C-W>h
map <C-l> <C-W>l
map <leader>= <C-W>=


" copy filename
map <silent> <leader>. :let @+=expand('%:p').':'.line('.')<CR>
map <silent> <leader>/ :let @+=expand('%:p:h')<CR>
" copy path


" Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-sleuth'

" Plugin 'scrooloose/syntastic'
" let g:syntastic_scala_checkers=['scalac']
" let g:syntastic_mode_map = { 'mode': 'active','active_filetypes': [], 'passive_filetypes': ['scala', 'java'] }
" let g:syntastic_cpp_compiler = 'clang++'
" let g:syntastic_cpp_compiler_options = ' -std=c++14 -stdlib=libc++'

Plugin 'Valloric/YouCompleteMe'
let g:ycm_extra_conf_globlist = [ '/Users/crankshaw/Dropbox/berkeley/amplab/clipper-cpp/*' ]
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'
let g:ycm_path_to_python_interpreter = '/usr/bin/python'
let g:ycm_enable_diagnostic_signs = 1
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_always_populate_location_list = 1
nnoremap <C-]> :YcmCompleter GoTo<CR>

Plugin 'Valloric/ListToggle'

Plugin 'jeaye/color_coded'

Plugin 'rdnetto/YCM-Generator'
" Plugin 'kien/ctrlp.vim'
Plugin 'ctrlpvim/ctrlp.vim'
let g:ctrlp_max_files = 0
" map <leader>mr :CtrlPMRUFiles<CR>
set wildignore+=*.class,*/target/*,*.swp,*/assembly/*,*/data/*,*.backup,*.html,
    \*.pyc,*.data,*.train,*.test,*.pdf,*.tar,*.tgz,*/CMakeFiles/*,*/debug/googletest-src/*,
    \*/release/googletest-src/*
" let g:ctrlp_custom_ignore = '/Users/crankshaw/clipper-cpp/debug,/Users/crankshaw/clipper-cpp/release'

Plugin 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

"
Plugin 'altercation/vim-colors-solarized'
Plugin 'jnurmine/Zenburn'

Plugin 'nathanaelkane/vim-indent-guides'
" Plugin 'Shougo/neocomplete.vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'corntrace/bufexplorer'
Plugin 'vim-scripts/xptemplate'
Plugin 'derekwyatt/vim-scala'
" Syntax highlight
" Plugin 'gmarik/vim-markdown'
" Plugin 'timcharper/textile.vim'

" Distraction free writing
Plugin 'junegunn/goyo.vim'
let g:goyo_width=90
let g:goyo_height='95%'
let g:goyo_linenr=0
map <C-g> :Goyo<CR>

" Python PEP8 checking
Plugin 'nvie/vim-flake8'


Plugin 'L9'
" Plugin 'LustyJuggler'
" Plugin '29decibel/codeschool-vim-theme'
Plugin 'xolox/vim-misc'
" Plugin 'xolox/vim-easytags'
" " let g:easytags_async=1
" let g:easytags_async=0

Plugin 'FuzzyFinder'
Plugin 'tpope/vim-fugitive'
Plugin 'git.zip'
" Plugin 'majutsushi/tagbar'
" nnoremap <silent> <Leader>b :TagbarToggle<CR>
Plugin 'scratch.vim'
Plugin 'TeX-PDF'
Plugin 'rust-lang/rust.vim'
let g:rustfmt_autosave = 1
Plugin 'racer-rust/vim-racer'
let g:racer_cmd = "/Users/crankshaw/.cargo/bin/racer"
" let $RUST_SRC_PATH="/usr/local/src/rustc-1.8.0/src"

" Plugin 'ZoomWin'
" noremap <leader>o :ZoomWin<CR>
" vnoremap <leader>o <C-C>:ZoomWin<CR>
" inoremap <leader>o <C-O>:ZoomWin<CR>
" noremap <C-W>+o :ZoomWin<CR>
 
Plugin 'Align'
" Plugin 'SuperTab'
Plugin 'repeat.vim'
Plugin 'surround.vim'
Plugin 'kshenoy/vim-signature'
" Plugin 'git://git.code.sf.net/p/vim-latex/vim-latex'
Plugin 'lervag/vimtex'
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'

" tComment
Plugin 'tomtom/tcomment_vim'
nnoremap // :TComment<CR>
vnoremap // :TComment<CR>

" Plugin 'Mark--Karkat'

" Plugin 'solarnz/thrift.vim'

" Plugin 'fatih/vim-go'
" au FileType go nmap <Leader>gd <Plug>(go-doc)
" au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
" au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
" au FileType go nmap <Leader>ds <Plug>(go-def-split)
" au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
" au FileType go nmap <Leader>dt <Plug>(go-def-tab)

Plugin 'bling/vim-airline'
Plugin 'cespare/vim-toml'
Plugin 'rhysd/vim-clang-format'
let g:clang_format#code_style = "google"
let g:clang_format#style_options = {
            \ "AccessModifierOffset" : -4,
            \ "AllowShortIfStatementsOnASingleLine" : "true",
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "Standard" : "C++14"}
let g:clang_format#detect_style_file = 1
let g:clang_format#auto_format = 1
let g:clang_format#auto_formatexpr = 1




" Plugin 'cstrahan/vim-capnp'

" Command-T
" Plugin "git://git.wincent.com/command-t.git"
" let g:CommandTMatchWindowAtTop=1 " show window at top


call vundle#end()

call tcomment#DefineType('java',             '// %s '         )
" call tcomment#DefineType('capnp',             '# %s '         )


syntax enable
set background=dark
colorscheme solarized
" colorscheme zenburn
let g:solarized_constrast = "high"
let g:airline_section_a = airline#section#create(['%<', 'file', 'readonly'])
let g:airline_section_b =  airline#section#create_left(['mode', 'paste', 'iminsert'])
let g:airline_section_c = '' " airline#section#create(['hunks'])
let g:airline_section_gutter = airline#section#create(['%=%y%m%r[%{&ff}]'])
let g:airline_section_x =  airline#section#create_right(['filetype'])
let g:airline_section_y = '%y%m%r%=[%{&ff}]' "airline#section#create_right(['ffenc'])
let g:airline_section_z = airline#section#create(['%(%l,%c%V%) %P'])
let g:airline_section_warning = '' "airline#section#create(['whitespace'])
" let g:airline_powerline_fonts = 1
" let g:airline_theme='bubblegum'
let g:airline#extensions#tabline#enabled = 1

filetype plugin indent on


