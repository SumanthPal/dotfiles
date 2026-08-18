" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
set nocompatible
filetype off

" Begin Vundle plugins
call vundle#begin()

" Let Vundle manage Vundle
Plugin 'VundleVim/Vundle.vim'

" IDE-like functionality
Plugin 'preservim/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'dense-analysis/ale'
Plugin 'airblade/vim-gitgutter'

" Visual enhancements
Plugin 'ryanoasis/vim-devicons'
Plugin 'joshdick/onedark.vim'

" Code editing enhancements
Plugin 'jiangmiao/auto-pairs'
Plugin 'tpope/vim-surround'
Plugin 'sheerun/vim-polyglot'

" Your existing plugins
Plugin 'bluz71/vim-mistfly-statusline'

call vundle#end()
filetype plugin indent on

" Basic settings
syntax on
set number
set relativenumber
set cursorline
set showmatch
set incsearch
set hlsearch
set expandtab
set tabstop=2
set shiftwidth=2
set showcmd
set wildmenu
set wildmode=list:longest
set mouse=a
set clipboard=unnamed
set backspace=indent,eol,start

" Theme settings
set termguicolors
colorscheme habamax

" NERDTree settings
nnoremap <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" fzf settings
nnoremap <C-p> :Files<CR>

" Auto-open NERDTree when Vim starts
autocmd VimEnter * NERDTree | wincmd p

" Exit Vim if NERDTree is the only window remaining
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
