" -----------------------------------------------------------------------------
" General
" -----------------------------------------------------------------------------

" Override /etc/vim/vimrc
"
" Uncomment the following to have Vim jump to the last position when
" reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Enable filetype plugins and indent
filetype plugin on
filetype indent on

" Use comma as <leader>
let mapleader="\<space>"

" Auto read file once changed outside
set autoread
autocmd FocusGained,BufEnter * checktime

" Avoid annoying dot file.
set noswapfile
set noundofile

" -----------------------------------------------------------------------------
" AutoComplete
" -----------------------------------------------------------------------------

set completeopt+=menuone,longest

" -----------------------------------------------------------------------------
" Encoding
" -----------------------------------------------------------------------------

if has('multi_byte')
  set encoding=utf-8
  set fileencoding=utf-8
  set fileencodings=ucs-bom,utf-8,gbk,gb18030,big5,euc-jp,latin1
endif

" -----------------------------------------------------------------------------
" Cursor
" -----------------------------------------------------------------------------

" Cursor blink is not a vim problem but a terminal problem

" -----------------------------------------------------------------------------
" Colors and Fonts
" -----------------------------------------------------------------------------

" Enable syntax highlighting
syntax enable


" -----------------------------------------------------------------------------
" User Interface
" -----------------------------------------------------------------------------

" Show line number
set number

" Show command menu
set wildmenu


" -----------------------------------------------------------------------------
" Spaces & Tabs 
" -----------------------------------------------------------------------------

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs
set smarttab

" 1 tab = 2 spaces
set tabstop=2
set softtabstop=2
set shiftwidth=2

" -----------------------------------------------------------------------------
" Search
" -----------------------------------------------------------------------------

" search and backwards search
map <space> /
map <C-space> ?

" Ignore case when searching
set ignorecase

" Be smart when searching
set smartcase

" Highlight search
set hlsearch

" Start seach and match once type ant char
set incsearch

" 
set showmatch

" Turn off highlight
nmap <C-f> :set nohlsearch<cr>

" -----------------------------------------------------------------------------
" Moving around
" -----------------------------------------------------------------------------

map <leader>bd :Bclose<cr>
map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" -----------------------------------------------------------------------------
" Folding
" -----------------------------------------------------------------------------

" Folding based on indent
set foldmethod=indent
set foldlevel=10
nnoremap <leader>a za

" -----------------------------------------------------------------------------
" Helper functions
" -----------------------------------------------------------------------------

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new 
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

" Expand C/C++ Macro()
function! ExpandCMacro()
  "get current info
  let l:macro_file_name = "__macroexpand__" . tabpagenr()
  let l:file_row = line(".")
  let l:file_name = expand("%")
  let l:file_window = winnr()
  "create mark
  execute "normal! Oint " . l:macro_file_name . ";"
  execute "w"
  "open tiny window ... check if we have already an open buffer for macro
  if bufwinnr( l:macro_file_name ) != -1
    execute bufwinnr( l:macro_file_name) . "wincmd w"
    setlocal modifiable
    execute "normal! ggdG"
  else
    execute "bot 10split " . l:macro_file_name
    execute "setlocal filetype=cpp"
    execute "setlocal buftype=nofile"
    nnoremap <buffer> q :q!<CR>
  endif
  "read file with gcc
  silent! execute "r!gcc -E " . l:file_name
  "keep specific macro line
  execute "normal! ggV/int " . l:macro_file_name . ";$\<CR>d"
  execute "normal! jdG"
  "indent
  execute "%!indent -st -kr"
  execute "normal! gg=G"
  "resize window
  execute "normal! G"
  let l:macro_end_row = line(".")
  execute "resize " . l:macro_end_row
  execute "normal! gg"
  "no modifiable
  setlocal nomodifiable
  "return to origin place
  execute l:file_window . "wincmd w"
  execute l:file_row
  execute "normal!u"
  execute "w"
  "highlight origin line
  let @/ = getline('.')
endfunction


" -----------------------------------------------------------------------------
" Vim Plugin Management
" -----------------------------------------------------------------------------

" Use Vim-plug(https://github.com/junegunn/vim-plug) to manage my plugin
call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes

" Bufferline display
Plug 'vim-airline/vim-airline'

" Optional
Plug 'vim-airline/vim-airline-themes'

" Browse the file system
Plug 'scrooloose/nerdtree'

" Automatically show Vim's complete menu while typing
Plug 'vim-scripts/AutoComplPop'

" Initialize plugin system
call plug#end()


" -----------------------------------------------------------------------------
" Plugin Setting
" -----------------------------------------------------------------------------

" vim-airline/vim-airline
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" vim-aireline/vim-airline-themes
" For more avaiable themes, see https://github.com/vim-airline/vim-airline/wiki/Screenshots
" Use theme simple
let g:airline_theme='simple'

" scrooloose/nerdtree
" start NERDTree and put the cursor back in the other window
" autocmd vimenter * NERDTreeFind | wincmd p
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" open and close nerdtree with Ctrl+n
map <C-n> :NERDTreeToggle<CR>
