set nocompatible              " be iMproved, required
filetype off                  " required  

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
  
 " let Vundle manage Vundle, required
 Plugin 'VundleVim/Vundle.vim'
 
 Plugin 'scrooloose/nerdtree.git'
 Plugin 'lrvick/Conque-Shell.git'
 Plugin 'christoomey/vim-tmux-navigator'
 Plugin 'vim-airline/vim-airline'
 Plugin 'vim-airline/vim-airline-themes'
 Plugin 'Valloric/YouCompleteMe'
 Plugin 'terryma/vim-multiple-cursors'
 Plugin 'michaeljsmith/vim-indent-object'
 Plugin 'majutsushi/tagbar'
 Plugin 'wincent/command-t'
 " Plugin 'airblade/vim-gitgutter'
 Plugin 'tpope/vim-commentary'
 Plugin 'tpope/vim-fugitive'
 Plugin 'mhinz/vim-signify'
 Plugin 'edkolev/tmuxline.vim'
 Plugin 'sickill/vim-monokai'
 Plugin 'rcabralc/monokai-airline.vim'
 Plugin 'severin-lemaignan/vim-minimap'
 Plugin 'tpope/vim-surround'
 Plugin 'raimondi/delimitmate'


 call vundle#end()
 syntax enable
 set number
 filetype plugin indent on
 set t_Co=256 " enable 256-color mode
 set autoindent
 set tabstop=4 " tab spacing
 set shiftwidth=4
 set ruler " always show info along bottom.
 set expandtab " use spaces instead of tabs
 set softtabstop=4 " unify
 set shiftround " always indent/outdent to the nerest tabstop
 set showcmd " sho command in bottom bar
 set cursorline " highlight current line
 " hi CursorLine term=bold cterm=bold guibg=Grey40 " make it so it's not underlined
 set wildmenu " visual autocomplete for command menu
 set lazyredraw " redraw only when needed
 set showmatch " highlight matchin [{()}]
 set foldenable " enable folding
 set foldlevelstart=10 " open most folds by default
 set foldnestmax=10 " 10 nested fold max

 colorscheme monokai
 let g:airline_powerline_fonts = 1
 let g:airline_theme='monokai' 
 let g:airline#extensions#branch#enabled = 1
 set laststatus=2

 nmap <silent> <C-D> :NERDTreeToggle<CR> " Nerdtree toggling
 " set background=dark
 " highlight Normal ctermfg=grey ctermbg=black
