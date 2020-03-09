#=======================================================
# PATH, ENV
#=======================================================
export NODE_PATH=/usr/local/share/npm/lib/node_modules:$NODE_PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/opt/binutils/bin:$PATH
export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
export PATH=/usr/local/opt/findutils/libexec/gnubin:$PATH
export PATH=/usr/local/opt/gnu-sed/libexec/gnubin:$PATH
export PATH=/usr/local/opt/gnu-tar/libexec/gnubin:$PATH
export PATH=/usr/local/opt/openssl/bin:$PATH
export PATH=/usr/local/opt/curl/bin:$PATH

# MANPATH
export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
export MANPATH=/usr/local/opt/findutils/libexec/gnuman:$MANPATH
export MANPATH=/opt/local/share/man:/opt/local/man:$MANPATH
export MANPATH=/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH
export MANPATH=/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH
export MANPATH=/usr/local/opt/gawk/share/man:$MANPATH
export MANPATH=/usr/local/opt/erlang/lib/erlang/man:$MANPATH

# PATH for rbenv
export PATH=$HOME/.rbenv/shims:$PATH
# rbenv init 処理が重たいので rehash を適宜手動で行うことにした
# eval "$(rbenv init -)"
source ~/.rbenv_init

# pyenvさんに~/.pyenvではなく、/usr/loca/var/pyenvを使うようにお願いする
export PYENV_ROOT=/usr/local/var/pyenv
# pyenv init 処理が重たいので rehash を適宜手動で行うことにした
# eval "$(pyenv init -)"
source ~/.pyenv_init

# direnv
eval "$(direnv hook zsh)"
# To surpress direnv STDOUT log, set DIRENV_LOG_FORMAT to NULL
export DIRENV_LOG_FORMAT=

# nvm(node.js)
# nvm command loading takes a lot of time
# and make lazy load command
nvm() {
  echo "Lazy loading nvm..."

  # Remove nvm function
  unfunction "$0"

  # Set PATH
  export NVM_DIR=$HOME/.nvm

  # Load nvm
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

  # Set PATH for npm
  export NODE_PATH=$(npm root -g):$NODE_PATH

  # Call nvm
  $0 "$@"
}

# goenv
export GOENV_ROOT=$HOME/.goenv
export PATH=$PATH:$GOENV_ROOT/bin
export GOENV_DISABLE_GOPATH=1
eval "$(goenv init -)"
# gopath
export GOPATH=$HOME/.go
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$GOPATH/bin

# OCaml
# alias ocaml="rlwrap ocaml"

# Opam(OCaml package manager)
# eval "$(opam config env)"

# Racer(Rust code completion)
export PATH=~/.cargo/bin:$PATH
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
fpath+=~/.zfunc
source ~/.cargo/env

# Haskell
export PATH=$HOME/.local/bin:$PATH

# neovim
export XDG_CONFIG_HOME=$HOME/.config

# PostgreSQL
export PGDATA=/usr/local/var/postgres

# Set library path
export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/lib

# for Hyper(electron based terminal app) to display Japanese languages
export LANG=ja_JP.UTF-8

# for mysql(5.7)
export PATH=/usr/local/opt/mysql@5.7/bin:$PATH

# java
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

export EDITOR=nvim
export VISUAL=nvim

# Rabbit (Slide tool)
export DYLD_LIBRARY_PATH=/usr/local/opt/cairo/lib

#=======================================================
# alias
#=======================================================

# cc
alias gcc='gcc-9'

# git
alias gs='git status'
alias gc='git commit -m'
alias gcv='git commit -v'
alias ga='git add'
alias gd='git diff'
alias gl='git log'
alias gb='git branch'
alias gch='git checkout'
alias gg='git grep'
alias gish='git push'
alias gill='git pull'
alias gitch='git fetch'
alias gclean="git branch --merged | rg -v '\*' | sed -e 's/[*| ] //' | rg -v '^(master|release|develop)$' | xargs -I % git branch -d %"

# vim
alias vi='nvim'

# ruby
alias be='DISABLE_SPRING=1 bundle exec'

# function to echo $PATH
function echopath() { echo $PATH | awk '{gsub(":", "\n", $0); print $0}' }

#=======================================================
# zplug
#=======================================================

# brew upgrade 等で zsh が起動しなくなったら下記ディレクトリのシンボリックリンクをチェック
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

# Source Prezto.
# if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
#   source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
# fi
#
# この処理もファイルの確認を行わずに実行することにした
source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

zplug "zplug/zplug"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "sorin-ionescu/prezto"

# zsh の起動が遅いので未インストールのものをチェックする工程を飛ばしている
# plugin をいじった場合にはここのコメントアウトを外すこと
#
# Install plugins if there are plugins that have not been installed
# if ! zplug check --verbose; then
#   printf "Install? [y/N]: "
#   if read -q; then
#     echo; zplug install
#   fi
# fi

# zplug load --verbose
zplug load

#=======================================================
# zsh config
#=======================================================
autoload colors && colors
autoload -Uz add-zsh-hook
autoload -Uz compinit && compinit -C

setopt no_flow_control

# タイポしているコマンドを指摘したい場合以下を有効に
# setopt correct
# ウザいので off にしている
unsetopt correct

# 移動したディレクトリをスタックに積んでいく
setopt auto_pushd

setopt prompt_subst

# historyの共有
setopt share_history
# 重複を記録しない
setopt hist_ignore_dups
# ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_ignore_all_dups
# スペースで始まるコマンド行はヒストリリストから削除
setopt hist_ignore_space
# 余分な空白は詰めて記録
setopt hist_reduce_blanks
# 古いコマンドと同じものは無視
setopt hist_save_no_dups
# historyコマンドは履歴に登録しない
setopt hist_no_store
# 補完時にヒストリを自動的に展開
setopt hist_expand
# 履歴をインクリメンタルに追加
setopt inc_append_history
# 開始と終了を記録
setopt EXTENDED_HISTORY
# コマンドラインでもコメントアウトができるように
setopt interactive_comments
# zsh デフォルトのコマンド履歴インクリメンタルサーチを無効に
bindkey -r '^S'
# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zsh_history
# メモリに保存される履歴の件数
export HISTSIZE=1000000
# 履歴ファイルに保存される履歴の件数
export SAVEHIST=1000000
#color
export LSCOLORS=gxfxxxxxcxxxxxxxxxgxgx
export LS_COLORS='di=01;36:ln=01;35:ex=01;32'
export LESS='-g -i -M -R -S -W -z-4 -x4'
export LESSOPEN='| /usr/local/bin/src-hilite-lesspipe.sh %s'
zstyle ':completion:*' list-colors 'di=36' 'ln=35' 'ex=32'
#大文字小文字を意識しない補完
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

#=======================================================

# ----------------------
# others
# ----------------------

function killport() {
  lsof -i4:$1 | tail -1 | awk '{ print $2}' | xargs kill -9
}

# iTermのタブに現在のディレクトリと一つ上のディレクトリを表示
function chpwd() { ls -a; echo -ne "\033]0;$(pwd | rev | awk -F \/ '{print "/"$1"/"$2}'| rev)\007"}

function history-fzf() {
  # BSD 系の `tail` コマンドには -r で逆順に出力するオプションが存在する
  # 一方で GNU/Linux 系の `tail` コマンドには -r オプションが存在せず、
  # 代わりに `tac`(= cat の逆さ読み)コマンドが用意されている
  # 僕のデバイスでは brew で gnu の coreutils を入れているため後者を利用する
  BUFFER=$(history -n 1 | tac | fzf --query "$LBUFFER")
  CURSOR=$#BUFFER

  zle reset-prompt
}
zle -N history-fzf
bindkey '^r' history-fzf

function ghq-fzf() {
  cd $(ghq list -p | fzf)

  # ここで vcs_info を呼び出さないとディレクトリ移動後の初回のプロンプト表示で
  # 移動前の vcs の情報が表示されてしまう
  vcs_info
  zle reset-prompt
}
zle -N ghq-fzf
bindkey '^h' ghq-fzf

bindkey -e
