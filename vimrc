set nocompatible              " be iMproved, required
filetype off                  " required  

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
  
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'rcabralc/monokai-airline.vim'
" Plugin 'edkolev/tmuxline.vim'
" Plugin 'Valloric/YouCompleteMe'
Plugin 'davidhalter/jedi-vim' " autocomplete
Plugin 'terryma/vim-multiple-cursors'
Plugin 'michaeljsmith/vim-indent-object' " Indent whole blocks
" Plugin 'wincent/command-t'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'sickill/vim-monokai'
Plugin 'tpope/vim-surround'
Plugin 'raimondi/delimitmate'
Plugin 'w0rp/ale' " Syntax linting
Plugin 'kshenoy/vim-signature' " shows nav marks in the gutter
Plugin 'majutsushi/tagbar'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'gasparch/ctrlp-tagbar.vim'
Plugin 'lervag/vimtex' " latex tooling
" Plugin 'python-mode/python-mode' " Python specific plugin
Plugin 'chrisbra/csv.vim' " CSV formatting


call vundle#end()
syntax enable
set number
filetype plugin indent on
set autoindent
set tabstop=4 " tab spacing
set shiftwidth=4
set ruler " always show info along bottom.
set expandtab " use spaces instead of tabs
set softtabstop=4 " unify
set shiftround " always indent/outdent to the nerest tabstop
set showcmd " sho command in bottom bar
set cursorline " highlight current line
set wildmenu " visual autocomplete for command menu
set lazyredraw " redraw only when needed
set showmatch " highlight matchin [{()}]
set foldenable " enable folding
set foldlevelstart=10 " open most folds by default
set foldnestmax=10 " 10 nested fold max

set pastetoggle=<F2> " Toggle pasting mode
set clipboard=unnamed " copy and paste to system clipboard


" ----------- ctrl-p ------------
" set tags+=tags
let g:ctrlp_extensions = ['tag']

" ----------- Colors and gutter settings --------
set t_Co=256 " enable 256-color mode
colorscheme monokai

let g:airline_powerline_fonts = 1
let g:airline_theme='monokai' 
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1

" ------ Powerline -----
" set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/

" set laststatus=2
" set colorcolumn=80 " Column width
" highlight ColorColumn ctermbg=234
 
let g:ale_sign_error = '⨉'
let g:ale_sign_warning = '⚠'
highlight ALEErrorSign ctermbg=237 ctermfg=160 guibg=#3a3a3a guifg=#d70000
highlight ALEWarningSign ctermbg=237 ctermfg=148 guibg=#3a3a3a guifg=#afd700

" highlight clear SignColumn
" highlight GitGutterAdd ctermfg=green guifg=darkgreen
highlight GitGutterChange ctermbg=237 
" highlight GitGutterDelete ctermfg=red guifg=darkred
" highlight GitGutterChangeDelete ctermfg=yellow guifg=darkyellow

" Syntax highlighting for launch files
autocmd BufRead,BufNewFile *.launch set filetype=xml

" --------- Mappings -----------
let mapleader = ","

" Overwrite jedi binding first
let g:jedi#goto_command = "<leader>g"
map <Leader>d <esc>:NERDTreeToggle<CR>  " Nerdtree toggling
nmap <Leader>t <esc>:TagbarToggle<CR> " Toggle tagbar

" NERDCommenter toggle 
nmap <C-_>   <Plug>NERDCommenterToggle
vmap <C-_>   <Plug>NERDCommenterToggle<CR>gv

map <Leader>n <esc>:tabnext<CR>
map <Leader>m <esc>:tabprevious<CR>

map <Leader>p :pclose<CR>

map <c-h> <c-w>h
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l

" map sort function to a key
vnoremap <Leader>s :sort<CR>

" easier moving of code blocks
vnoremap < <gv 
vnoremap > >gv

" Column wrapping to fit 
vmap Q gq
nmap Q gqap

" --------- Plugin settings --------
" Nerdtree
let NERDTreeIgnore = ['\.pyc$'] " Hide .pyc files

" NerdCommenter
let g:NERDCompactSexyComs = 1 " Use compact syntax for prettified multi-line comments
let g:NERDSpaceDelims = 1 " Add spaces after comment delimiters by default

" ------------ Folding highlighting ----------
fu! CustomFoldText()
    "get first non-blank line
    let fs = v:foldstart
    while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
    endwhile
    if fs > v:foldend
        let line = getline(v:foldstart)
    else
        let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
    endif

    let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
    let foldSize = 1 + v:foldend - v:foldstart
    let foldSizeStr = " " . foldSize . " lines "
    let foldLevelStr = repeat("+--", v:foldlevel)
    let lineCount = line("$")
    let foldPercentage = printf("[%.1f", (foldSize*1.0)/lineCount*100) . "%] "
    let expansionString = repeat(".", w - strwidth(foldSizeStr.line.foldLevelStr.foldPercentage))
    return line . expansionString . foldSizeStr . foldPercentage . foldLevelStr
endf

set foldtext=CustomFoldText()
set foldmethod=indent   
set foldnestmax=10
set nofoldenable
set foldlevel=2

" ------ Vimtex ------
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

