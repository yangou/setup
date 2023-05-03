call plug#begin()
	Plug 'ghifarit53/tokyonight-vim'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'scrooloose/nerdtree'
	Plug 'elixir-editors/vim-elixir'
call plug#end()

set termguicolors

let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 1
colorscheme tokyonight

set rtp+=/usr/local/opt/fzf

let g:airline_powerline_fonts = 1

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" highlight Normal ctermbg=None
" highlight LineNr ctermfg=DarkGrey

let mapleader = ","

syntax on
set nowrap
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set autoindent
set number
set showcmd
set cursorline
filetype plugin indent on
set wildmenu
set lazyredraw
set showmatch
set incsearch
set hlsearch
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=indent
set smartcase
set mouse=a

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeWinPos = "right"
let NERDTreeShowHidden = 1

nnoremap tt :NERDTreeToggle<CR>
nnoremap tf :NERDTreeFind<CR>

nnoremap <SPACE> za
nnoremap <leader><SPACE> :nohlsearch<CR>
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
vnoremap <leader>y :w !pbcopy<CR><CR>
vnoremap // y/<C-R>"<CR>
