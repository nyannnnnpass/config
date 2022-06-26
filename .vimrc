"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use comma as <leader>
let mapleader="\<space>"

""""""""""""""""""
" Colors and Fonts
""""""""""""""""""

" Enable syntax highlighting
syntax enable


""""""""""""""""""
" UI
""""""""""""""""""

" Show line number
set number

" Show command menu
set wildmenu

" Remind me line wrap
set colorcolumn=80

""""""""""""""""""
" Search
""""""""""""""""""
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Moving around
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <leader>bd :Bclose<cr>
map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Plugin Management
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

" Initialize plugin system
call plug#end()


"""""""""""""""""""""""""""""
" Plugin Setting
"""""""""""""""""""""""""""""

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
autocmd vimenter * NERDTreeFind | wincmd p
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" open and close nerdtree with Ctrl+n
map <C-n> :NERDTreeToggle<CR>
