" 一旦ファイルタイプ関連を無効化する
filetype off

""""""""""""""""""""""""""""""
" プラグインのセットアップ
""""""""""""""""""""""""""""""
if has('vim_starting')
  " 挙動を vi 互換ではなく、Vim のデフォルト設定にする
  set nocompatible " Be iMproved
endif

call plug#begin('~/.vim/plugged')

Plug 'sheerun/vim-polyglot'
Plug 'bronson/vim-trailing-whitespace'

" filer
Plug 'cocopon/vaffle.vim'

" colorscheme
Plug 'morhetz/gruvbox'

" status line
Plug 'itchyny/lightline.vim'

" key binds
Plug 'tyru/columnskip.vim'
Plug 'scrooloose/nerdcommenter'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" LSP
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" git
Plug 'lambdalisue/gina.vim'

" tig
Plug 'furuhama/vim-tig-viewer'

" quickrun
Plug 'thinca/vim-quickrun'

call plug#end()

" Required:
filetype plugin indent on
""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""
" 表示設定
""""""""""""""""""""""""""""""
" カーソルが何行目の何列目に置かれているかを表示する
set ruler
" コマンドラインに使われる画面上の行数
set cmdheight=2
" エディタウィンドウの末尾から2行目にステータスラインを常時表示させる
set laststatus=2
" ウインドウのタイトルバーにファイルのパス情報等を表示する
set title
" コマンドラインモードで<Tab>キーによるファイル名補完を有効にする
set wildmenu wildmode=list:longest,full
" 入力中のコマンドを表示する
set showcmd
" モード表示
set showmode
" 小文字のみで検索したときに大文字小文字を無視する
set smartcase
" 検索結果のハイライト
set hlsearch
" タブ入力を複数の空白入力に置き換える
set expandtab
" 検索ワードの最初の文字を入力した時点で検索を開始する
set incsearch
" 保存されていないファイルがあるときでも別のファイルを開けるようにする
set hidden
" 不可視文字を表示する
set list
" タブと行の続きを可視化する
set listchars=tab:>\ ,extends:<
" 行番号を表示する
set number
" 対応する括弧やブレースを表示する
set showmatch
" 改行時に前の行のインデントを継続する
set autoindent
" 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set smartindent
" タブ文字の表示幅
set tabstop=2
" Vimが挿入するインデントの幅
set shiftwidth=2
" 行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする
set smarttab
" カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]
" turn off visual bell(空文字代入)
set visualbell t_vb=
" error bellをオフに
set noerrorbells
" 文字の削除を有効に
set backspace=indent,eol,start
" Thanks for flying vim を表示しない
set notitle
" 履歴の表示件数を増やす
set history=10000
" カーソル行のハイライト
set cursorline
" yank と clipboard の共有
set clipboard+=unnamed
" ファイルの自動再読み込み
set autoread
" ウィンドウ移動の度に自動読み込みのチェックを行う
augroup vimrc-checktime
  autocmd!
  autocmd WinEnter * checktime
augroup END
" swp ファイルを作らない
set noswapfile
" current directory を切り替える
set autochdir
" <leader> を , に
let mapleader = ','
" colorscheme
set t_Co=256
set background=dark
let g:gruvbox_sign_column='bg0'
colorscheme gruvbox
""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""
" Key bind
""""""""""""""""""""""""""""""
noremap <C-a> ^
noremap <C-e> $
noremap <Esc><Esc> :nohlsearch<CR><Esc>
" nnoremap tt :tabe<CR>:terminal ++curwin<CR>
noremap tn :<C-u>tabnew<CR>
noremap <C-n> gt
noremap <C-p> gT
tnoremap <silent> <ESC> <C-\><C-n>
""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""
" fzf
""""""""""""""""""""""""""""""
nnoremap <silent><C-l> :Rg<CR>
nnoremap <silent><C-s> :GitFiles<CR>
let g:fzf_layout = { 'down': '~40%' }
""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""
" vim-lsp
""""""""""""""""""""""""""""""
let g:lsp_signs_error = {'text': '!'}
let g:lsp_signs_warning = {'text': '>'}
let g:lsp_signs_hint = {'text': '?'}
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0
set completeopt=menuone,noinsert,noselect,preview
let g:asyncomplete_popup_delay = 100
let g:lsp_text_edit_enabled = 1

" ファイル保存時に format を実行する
autocmd BufWritePre * LspDocumentFormatSync

nnoremap gd :LspDefinition<CR>
""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""
" lightline
""""""""""""""""""""""""""""""
let g:lightline = {
  \   'colorscheme': 'wombat',
  \   'mode_map': {'c': 'NORMAL'},
  \   'active': {
  \     'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'filename' ] ]
  \   },
  \   'component_function': {
  \     'modified': 'LightlineModified',
  \     'readonly': 'LightlineReadonly',
  \     'gitbranch': 'gina#component#repo#branch',
  \     'filename': 'LightlineFilename',
  \     'fileformat': 'LightlineFileformat',
  \     'filetype': 'LightlineFiletype',
  \     'fileencoding': 'LightlineFileencoding',
  \     'mode': 'LightlineMode'
  \   }
  \ }

function! LightlineModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! LightlineFilename()
  return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlineFugitive()
  if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
    return fugitive#head()
  else
    return ''
  endif
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction
""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""
" Vaffle
""""""""""""""""""""""""""""""
nnoremap <silent><C-x> :Vaffle pwd<CR>
let g:vaffle_show_hidden_files=1
let g:vaffle_force_delete=1
""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""
" columnskip
""""""""""""""""""""""""""""""
nmap <silent> <C-j> <Plug>(columnskip-j)
xmap <silent> <C-j> <Plug>(columnskip-j)

nmap <silent> <C-k> <Plug>(columnskip-k)
xmap <silent> <C-k> <Plug>(columnskip-k)
""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""
" NERD Commenter
""""""""""""""""""""""""""""""
let g:NERDSpaceDelims=1
let g:NERDDefaultAlign='left'
""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""
" Gina vim
""""""""""""""""""""""""""""""
" alias
command Blame Gina blame
""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""
" filetypeの自動検出(最後の方に書いた方がいいらしい)
""""""""""""""""""""""""""""""
filetype on
