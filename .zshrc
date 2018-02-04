#=======================================================
# PATH
#=======================================================
export MANPATH=/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH
export MANPATH=/opt/local/share/man:/opt/local/man:$MANPATH
export NODE_PATH=/usr/local/share/npm/lib/node_modules:$NODE_PATH
export PATH="/usr/local/bin:$PATH"

# Homebrew で pyenv 関連で出る Error 対策
# brew コマンド実行時のみ PATH を変更する
alias brew="PATH=/usr/local/bin:/usr/bin:/usr/sbin:/sbin brew"

# PATH for rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# pyenvさんに~/.pyenvではなく、/usr/loca/var/pyenvを使うようにお願いする
export PYENV_ROOT=/usr/local/var/pyenv
alias conda_activate="source $PYENV_ROOT/versions/anaconda3-5.0.1/bin/activate"
export PATH="$PYENV_ROOT/versions/anaconda3-5.0.1/bin:$PATH"

# pyenvさんに自動補完機能を提供してもらう
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# direnv
eval "$(direnv hook zsh)"

# nvm(node.js)
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

# gopath
export GOPATH=$HOME/workspace/go
export PATH=$PATH:$GOPATH/bin

# npm
export NODE_PATH=$(npm root -g)

# Opam(OCaml package manager)
eval "$(opam config env)"

# Julia
export PATH="/Applications/Julia-0.6.app/Contents/Resources/julia/bin:$PATH"

# Racer(Rust code completion)
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
fpath+=~/.zfunc
source ~/.cargo/env

# Haskell
export PATH="$HOME/.local/bin:$PATH"

# neovim
export XDG_CONFIG_HOME="$HOME/.config"

#=======================================================
# alias
#=======================================================

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

# vim, zsh
alias v='nvim'
alias vi='nvim'
alias zshrc='nvim ~/.zshrc'
alias srczsh='source ~/.zshrc'
alias zpreztorc='nvim ~/.zpreztorc'

# python
alias jupy='jupyter notebook'

# ruby
alias be='bundle exec'
alias rubinius='/usr/local/opt/rubinius/bin/ruby'

# function to echo $PATH
function echopath() { echo $PATH | awk '{gsub(":", "\n", $0); print $0}' }

#=======================================================
# zplug
#=======================================================

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

zplug "zplug/zplug"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "unixorn/rake-completion.zshplugin"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "djui/alias-tips"
zplug "stedolan/jq", \
    from:gh-r, \
    as:command, \
    rename-to:jq
zplug "sorin-ionescu/prezto"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load --verbose

#=======================================================
# zsh config
#=======================================================
autoload colors && colors
autoload -Uz add-zsh-hook
autoload -Uz compinit && compinit -C

setopt no_flow_control

# タイポしているコマンドを指摘
# setopt correct

#cd
setopt auto_cd

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
# Git Function
# ----------------------
# Git log find by commit message
function glf() { $git log --all --grep="$1"; }
# ----------------------

# ----------------------
# others
# ----------------------

# iTermのタブに現在のディレクトリと一つ上のディレクトリを表示
function chpwd() { ls -a; echo -ne "\033]0;$(pwd | rev | awk -F \/ '{print "/"$1"/"$2}'| rev)\007"}
# pecoに関する設定(インクリメンタルサーチ用)
function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection

