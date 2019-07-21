" ======================
" display settings
" ======================
set ruler
set cursorline
set cmdheight=2
set laststatus=2
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
set number
" ctags で <C-]> した時に候補が複数ある場合はリストを表示する
set cscopetag
" diffs(plit) コマンドを vertical に比較する形にする
set diffopt=vertical

" ======================
" keybind settings
" ======================
noremap <Esc><Esc> :nohlsearch<CR><Esc>
tnoremap <silent> <ESC> <C-\><C-n>
tnoremap <C-q> <C-\><C-n>:q<CR>
nnoremap tt :tabe<CR>:terminal<CR>
noremap : ;
noremap ; :
noremap tn :<C-u>tabnew<CR>
noremap <C-n> gt
noremap <C-p> gT
noremap <C-a> ^
noremap <C-e> $
let mapleader=","

" ======================
" vim primitive command setting
" ======================
set splitright
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif
