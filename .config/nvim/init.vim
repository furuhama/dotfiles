set t_Co=256 "screen が 256色
set number "桁表示
set backspace=indent,eol,start
set mouse=a "マウス有効
set laststatus=2 "ステータスラインの表示
set listchars=tab:»\ ,trail:-,extends:»,precedes:«,nbsp:% "space 対応
set clipboard=unnamed "clipbordと対応
set ruler "カーソルが何行目の何列目に置かれているかを表示
set autoindent "改行時に前の行のインデントを継続する
set tabstop=2 "画面上でタブ文字が占める幅
set softtabstop=2 "連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set shiftwidth=2 "自動インデントでずれる幅
set expandtab "タブ入力を複数の空白入力に置き換える
set smartindent "改行時に入力された行の末尾に合わせて次の行のインデントを増減する
syntax on

" vim-go
let g:go_template_autocreate = 0
let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_term_enabled = 1
let g:go_highlight_build_constraints = 1

let g:deoplete#sources#go#align_class = 1
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
let g:deoplete#sources#go#package_dot = 1

" quick-run
let g:quickrun_config = {'*': {'hook/time/enable': '1'},}

" dein settings {{{"
" dein自体の自動インストール"
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath
" プラグイン読み込み＆キャッシュ作成"
let s:toml_file = fnamemodify(expand('<sfile>'), ':h').'/dein.toml'
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  call dein#load_toml(s:toml_file)
  call dein#end()
  call dein#save_state()
endif
"不足プラグインの自動インストール"
if has('vim_starting') && dein#check_install()
  call dein#install()
endif
"}}}"

