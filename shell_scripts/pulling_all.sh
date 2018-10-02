#!/usr/bin/env sh

# `pulling_all.sh` is an automaric git pulling processer.
# This would improve your reading git repositories to pull upstream changes.
#
#
# USAGE:
# Just run `./pulling_all.sh` in your directory.
# To be sure to put `git_repos.sh` & `svn_repos.sh` files at the same directory.
#
#
# EXAMPLE:
#
# == git_repos.sh ==
#
# git_repos=( \
#   "[repository_name] [branch_name]" \
#   "[repository_name] [branch_name]" \
#
#   ...
#
# )
#
# == svn_repos.sh ==
#
# svn_repos=( \
#   "[repository_name]" \
#   "[repository_name]" \
#
#   ...
#
# )

# get git repositories setting
if [ -r ./git_repos.sh ]; then
  source git_repos.sh
fi

# get svn repositories setting
if [ -r ./svn_repos.sh ]; then
  source svn_repos.sh
fi

# pulling all git repositories
function git_pull() {
  for repo_and_branch in "${git_repos[@]}"; do
    # shadowing `repo_and_branch` variable to str->array casting
    local repo_and_branch=(${repo_and_branch[@]})
    local repo=${repo_and_branch[0]}
    local branch=${repo_and_branch[1]}

    echo "==============================================="
    echo "start pulling => ${repo} [${branch}]"
    echo "-----------------------------------------------\n"

    cd ${repo}
    git pull --rebase origin ${branch}
    cd ..

    echo ""
    echo "===============================================\n"
  done
}

# pulling all svn repositories
function svn_pull() {
  for repo in "${svn_repos[@]}"; do
    echo "==============================================="
    echo "start pulling => ${repo[0]}"
    echo "-----------------------------------------------\n"

    cd ${repo[0]}
    hg pull --rebase
    cd ..

    echo ""
    echo "===============================================\n"
  done
}

# main function
# To be sure that `$git_repos` and `$svn_repos` variables are defined.
function main() {
  if [ -n "$git_repos" ]; then
    git_pull
  fi

  if [ -n "$svn_repos" ]; then
    svn_pull
  fi
}

# Run main function
main
