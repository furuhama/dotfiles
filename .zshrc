# to measure performance, enable below
# zmodload zsh/zprof

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

export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
export MANPATH=/usr/local/opt/findutils/libexec/gnuman:$MANPATH
export MANPATH=/opt/local/share/man:/opt/local/man:$MANPATH
export MANPATH=/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH
export MANPATH=/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH
export MANPATH=/usr/local/opt/gawk/share/man:$MANPATH
export MANPATH=/usr/local/opt/erlang/lib/erlang/man:$MANPATH

# PATH for rbenv
export PATH=$HOME/.rbenv/shims:$PATH
# rbenv が homebrew で入れた openssl にデフォルトで依存しなくなったため
# homebrew 経由の openssl を見るように環境変数にて指定
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
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
  export NVM_DIR=$HOME/.config/nvm

  # Load nvm
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

  # Set PATH for npm
  export NODE_PATH=$(npm root -g):$NODE_PATH

  # Call nvm
  $0 "$@"
}

# goenv
goenv() {
  echo "Lazy loading goenv..."

  unfunction "$0"

  eval "$(goenv init -)"

  $0 "$@"
}
export GOENV_ROOT=$HOME/.goenv
export GOENV_DISABLE_GOPATH=1
export PATH=$PATH:$GOENV_ROOT/bin
# gopath
export GOPATH=$HOME/.go
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$GOPATH/bin
# Rust
if [ -d "$HOME/.cargo" ]; then
    export PATH=~/.cargo/bin:$PATH
    export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
    fpath+=~/.zfunc
    source ~/.cargo/env
fi
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
# デフォルトのエディタ設定
export EDITOR=vim
export VISUAL=vim
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

#=======================================================
# alias
#=======================================================

# utils
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lh'
alias la='ll -A'
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
alias vi='vim'
# ruby
alias be='DISABLE_SPRING=1 bundle exec'

#=======================================================
# zplug
#=======================================================

# brew upgrade 等で zsh が起動しなくなったら下記ディレクトリのシンボリックリンクをチェック
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "zplug/zplug"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# zsh の起動が遅いので未インストールのものをチェックする工程を飛ばしている
# plugin をいじった場合にはここのコメントアウトを外すこと
# if ! zplug check --verbose; then
#   printf "Install? [y/N]: "
#   if read -q; then
#     echo; zplug install
#   fi
# fi

zplug load

#=======================================================
# prompt
#=======================================================

# Load required functions.
autoload -Uz add-zsh-hook
autoload -Uz vcs_info
autoload colors && colors

# Add hook for calling vcs_info before each command.
add-zsh-hook precmd vcs_info

# Set vcs_info parameters.
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{green}S%f'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}U%f'
zstyle ':vcs_info:*' formats ' - [%b%c%u]'
zstyle ':vcs_info:*' actionformats " - [%b%c%u|%F{cyan}%a%f]"
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b|%F{cyan}%r%f'
zstyle ':vcs_info:git*+set-message:*' hooks git_status
zstyle ':completion:*' list-colors 'di=36' 'ln=35' 'ex=32'
#大文字小文字を意識しない補完
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# いろんな顔文字をランダムで表示したい
# (下記部分はバックグラウンドプロセスの数を表示している)
# %F{menta}%(1j. %j.)%f
KAOMOJIS=("( '-')" "( T-T)" "( .-.)" "( 0_0)" "( >_<)" "( *-*)" "( o_o)" "(′•_•)" "( 'm')")
KAOMOJI_LENGTH="${#KAOMOJIS[@]}"
KAOMOJI="${KAOMOJIS[${$((RANDOM % KAOMOJI_LENGTH + 1))}]}"
# いろんな顔文字ver
PROMPT='%2~${vcs_info_msg_0_}%F{magenta}%(1j. %j.)%f ${KAOMOJI} '
RPROMPT=''

#=======================================================
# zsh config
#=======================================================

# Ctrl-S を vim で有効にしたい
stty start undef
stty stop undef
# フロー制御を使わない
setopt no_flow_control
# タイポしているコマンドを指摘したい場合以下を有効に(ウザいので off にしている)
unsetopt correct
# 移動したディレクトリをスタックに積んでいく
setopt auto_pushd
# prompt 表示のたびに変数展開
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
# ジョブの制御
setopt monitor

#=======================================================
# others
#=======================================================

function killport() {
  lsof -i4:$1 | tail -1 | awk '{ print $2}' | xargs kill -9
}

# function to echo $PATH
function echopath() { echo $PATH | awk '{gsub(":", "\n", $0); print $0}' }

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
# zsh デフォルトのコマンド履歴インクリメンタルサーチを無効に
bindkey -r '^S'
# その上で history-fzf を登録
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

# emacs-like keybind
bindkey -e
