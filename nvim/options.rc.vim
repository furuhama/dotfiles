" ======================
" display settings
" ======================
set ruler
set cursorline
set cmdheight=2
set laststatus=2
set title
set wildmenu wildmode=list:longest,full
set showcmd
set showmode
set smartcase
set hlsearch
set t_Co=256
set termguicolors
set expandtab
set incsearch
set hidden
set list
set listchars=tab:>\ ,extends:<
set number
set showmatch
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set smarttab
set whichwrap=b,s,h,l,<,>,[,]
set visualbell t_vb=
set noerrorbells
set backspace=indent,eol,start
set notitle
set noswapfile
set history=10000
set clipboard+=unnamedplus
noremap <Esc><Esc> :nohlsearch<CR><Esc>
tnoremap <silent> <ESC> <C-\><C-n>
tnoremap <C-q> <C-\><C-n>:q<CR>
nnoremap @t :tabe<CR>:terminal<CR>
noremap : ;
noremap ; :
noremap st :<C-u>tabnew<CR>
noremap <C-n> gt
noremap <C-p> gT
let mapleader=","

autocmd MyAutoCmd FileType c set tabstop=4 shiftwidth=4
autocmd MyAutoCmd FileType cpp set tabstop=4 shiftwidth=4
autocmd MyAutoCmd FileType haskell set tabstop=4 shiftwidth=4
autocmd MyAutoCmd FileType go set tabstop=4 shiftwidth=4 noexpandtab
autocmd MyAutoCmd FileType markdown set tabstop=2 shiftwidth=2 expandtab
