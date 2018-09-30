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
source git_repos.sh

# get svn repositories setting
source svn_repos.sh

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
function main() {
  git_pull
  svn_pull
}

# To be sure that `$git_repos` and `$svn_repos` variables are defined.
if [ -n "$git_repos" ] && [ -n "$svn_repos" ]; then
  main
fi
