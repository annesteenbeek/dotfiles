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
 " Plugin 'bling/vim-airline'
 Plugin 'terryma/vim-multiple-cursors'

 call vundle#end()
 syntax enable
 set number
 filetype plugin indent on
 set t_Co=256 " enable 256-color mode
 colorscheme desert
 set autoindent
 set tabstop=4 " tab spacing
 set ruler " always show info along bottom.
 set expandtab " use spaces instead of tabs
 set softtabstop=4 " unify
 set shiftround " always indent/outdent to the nerest tabstop


