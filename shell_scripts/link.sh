#!/usr/bin/env sh

if [ ! -d "$HOME/dotfiles" ]; then
    echo "Please locale dotfiles directory under \$HOME"
    exit 1
fi

set_link() {
    ln -vfs $HOME/dotfiles/$1 $HOME/$1
}

set_link .gdbinit
set_link .gitattributes
set_link .gitconfig
set_link .gitignore_global
set_link .gitmessage
set_link .hgrc
set_link .hushlogin
set_link .pryrc
set_link .pyenv_init
set_link .pylintrc
set_link .rbenv_init
set_link .tigrc
set_link .tmux.conf
set_link .vimrc
set_link .zshrc

set_link_with_dir() {
    mkdir -p $HOME/$1
    ln -vfs $HOME/dotfiles/$1/$2 $HOME/$1/$2
}

set_link_with_dir .bundle config
set_link_with_dir .cargo config
set_link_with_dir .rbenv default-gems
set_link_with_dir Library/Preferences cargo-atcoder.toml

# nvim is a directory
mkdir -p .config
ln -vfs $HOME/dotfiles/.config/nvim $HOME/.config/
